#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=XX_SCRATCH_DIR_XX
###SBATCH --cpus-per-task=XX_THREAD_COUNT_XX

SCRATCH_DIR="XX_SCRATCH_DIR_XX"
BAM_URL_ARRAY="XX_BAM_URL_ARRAY_XX"
CASE_ID="XX_CASE_ID_XX"
THREAD_COUNT=XX_THREAD_COUNT_XX
S3_CFG_PATH=${HOME}/.s3cfg.cleversafe
GIT_CWL_SERVER="github.com"
GIT_CWL_SERVER_FINGERPRINT="2048 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48"
GIT_CWL_DEPLOY_KEY_S3_URL="s3://bioinformatics_scratch/deploy_key/coclean_cwl_deploy_rsa"
GIT_CWL_REPO=" -b slurm_script git@github.com:NCI-GDC/cocleaning-cwl.git"
EXPORT_PROXY_STR="export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128;"

#index file names
KNOWN_INDEL_VCF="Homo_sapiens_assembly38.known_indels.vcf.gz"
KNOWN_SNP_VCF="dbsnp_144.hg38.vcf.gz"
REFERENCE_GENOME="GRCh38.d1.vd1"

#buckets used
S3_GATK_INDEX_BUCKET="s3://bioinformatics_scratch/coclean"
S3_OUT_BUCKET="s3://tcga_exome_blca_coclean"
S3_LOG_BUCKET="s3://tcga_exome_blca_coclean_log"

COCLEAN_WORKFLOW="coclean/coclean_workflow.cwl.yaml"
BUILDBAMINDEX_TOOL="picard_buildbamindex.cwl.yaml"

function install_unique_virtenv()
{
    echo ""
    echo "install_unique_virtenv()"
    local uuid="$1"
    local export_proxy_str="$2"
    eval ${export_proxy_str}
    echo "deactive"
    deactivate
    echo "pip install virtualenvwrapper --user"
    pip install virtualenvwrapper --user
    source ${HOME}/.local/bin/virtualenvwrapper.sh
    mkvirtualenv --python /usr/bin/python2 p2_${uuid}
    this_virtenv_dir=${HOME}/.virtualenvs/p2_${uuid}
    source ${this_virtenv_dir}/bin/activate
    pip install --upgrade pip
}

function pip_install_requirements()
{
    echo ""
    echo "pip_install_requirements()"
    local requirements_path="$1"
    local export_proxy_str="$2"
    eval ${export_proxy_str}
    pip install -r ${requirements_path}
}

function setup_deploy_key()
{
    echo ""
    echo "setup_deploy_key()"
    local s3_cfg_path="$1"
    local s3_deploy_key_url="$2"
    local store_dir="$3"
    local prev_wd=`pwd`
    local key_name=$(basename ${s3_deploy_key_url})
    echo "cd ${store_dir}"
    cd ${store_dir}
    eval `ssh-agent`
    echo "s3cmd -c ${s3_cfg_path} get --force ${s3_deploy_key_url}"
    s3cmd -c ${s3_cfg_path} get --force ${s3_deploy_key_url}
    echo "chmod 400 ${key_name}"
    chmod 400 ${key_name}
    echo "ssh-add ${key_name}"
    ssh-add ${key_name}
    ssh-add -L
    echo "cd ${prev_wd}"
    cd ${prev_wd}
}

function clone_git_repo()
{
    echo ""
    echo "clone_git_repo()"
    local git_server="$1"
    local git_server_fingerprint="$2"
    local git_repo="$3"
    local export_proxy_str="$4"
    local storage_dir="$5"
    local git_name="$6"
    local prev_wd=`pwd`

    echo "git_name=${git_name}"
    echo "eval ${export_proxy_str}"
    eval ${export_proxy_str}
    echo "cd ${storage_dir}"
    cd ${storage_dir}
    #check if key is in known hosts
    echo 'ssh-keygen -H -F ${git_server} | grep "Host ${git_server} found: line 1 type RSA" -'
    ssh-keygen -H -F ${git_server} | grep "Host ${git_server} found: line 1 type RSA" -
    if [ $? -eq 0 ]
    then
        echo "git_server ${git_server} is known"
        echo "git clone ${git_repo}"
        git clone ${git_repo}
    else # if not known, get key, check it, then add it
        echo "git_server ${git_server} is NOT known"
        echo "ssh-keyscan ${git_server} > ${git_server}_gitkey"
        ssh-keyscan ${git_server} > ${git_server}_gitkey
        echo `ssh-keygen -lf ${git_server}_gitkey` | grep "${git_server_fingerprint} ${git_server} (RSA)"
        if [ $? -eq 0 ]
        then
            echo "cat ${git_server}_gitkey >> ${HOME}/.ssh/known_hosts"
            cat ${git_server}_gitkey >> ${HOME}/.ssh/known_hosts
            echo "git clone ${git_repo}"
            git clone ${git_repo}
        else
            echo "git server fingerprint is not '${git_server_fingerprint} ${git_server} (RSA)', but instead:  `ssh-keygen -lf ${git_server}_gitkey`"
            exit 1
        fi
    fi
    cd ${prev_wd}
}


function get_gatk_index_files()
{
    local s3_cfg_path=$1
    local s3_index_bucket=$2
    local storage_dir=$3
    local reference_genome=$4
    local known_snp_vcf=$5
    local known_indel_vcf=$6

    local gatk_index_dir="${storage_dir}/index"
    mkdir -p ${gatk_index_dir}
    
    s3cmd -c ${s3_cfg_path} --force get ${s3_index_bucket}/${reference_genome}.dict
    s3cmd -c ${s3_cfg_path} --force get ${s3_index_bucket}/${reference_genome}.fa
    s3cmd -c ${s3_cfg_path} --force get ${s3_index_bucket}/${reference_genome}.fa.fai
    s3cmd -c ${s3_cfg_path} --force get ${s3_index_bucket}/${known_snp_vcf}
    s3cmd -c ${s3_cfg_path} --force get ${s3_index_bucket}/${known_snp_vcf}.tbi
    s3cmd -c ${s3_cfg_path} --force get ${s3_index_bucket}/${known_indel_vcf}
    s3cmd -c ${s3_cfg_path} --force get ${s3_index_bucket}/${known_indel_vcf}.tbi
}

function get_bam_files()
{
    local s3_cfg_path=$1
    local bam_url_array=$2
    local storage_dir=$3
    local prev_wd=`pwd`
    cd ${storage_dir}
    for bam_url in ${bam_url_array}
    do
        s3cmd -c ${s3_cfg_path} --force get ${bam_url}
    done
    cd ${prev_wd}
}

function generate_bai_files()
{
    local storage_dir=$1
    local bam_url_array=$2
    local case_id=$3
    local cwl_tool_path=$4
    local prev_wd=`pwd`
    cd ${storage_dir}

    local this_virtenv_dir=${HOME}/.virtualenvs/p2_${case_id}
    local cwlrunner_path=${this_virtenv_dir}/bin/cwltool

    for bam_url in ${bam_url_array}
    do
        local bam_name=$(basename ${bam_url})
        local bam_path=${storage_dir}/${bam_name}
        local cwl_command="--debug --outdir ${storage_dir} ${cwl_tool_path} --uuid ${case_id} --input_bam ${bam_path}"

        echo "${cwlrunner_path} ${cwl_command}"
        ${cwlrunner_path} ${cwl_command}
    done
    cd ${prev_wd}
}

function run_coclean()
{
    local storage_dir=$1
    local bam_url_array=$2
    local case_id=$3
    local coclean_workflow_path=$4
    local reference_genome_path=$5
    local known_indel_vcf_path=$6
    local known_snp_vcf_path=$7
    local thread_count=$8
    local coclean_dir=${storage_dir}/coclean
    local tmp_dir=${storage_dir}/tmp
    local prev_wd=`pwd`
    mkdir -p ${coclean_dir}
    mkdir -p ${tmp_dir}
    cd ${coclean_dir}
    
    # setup cwl command removed  --leave-tmpdir
    local cwl_command="--debug --outdir ${coclean_dir} ${coclean_workflow_path} --reference_fasta_path ${reference_genome_path}.fa --uuid ${case_id} --known_indel_vcf_path ${known_indel_vcf_path} --known_snp_vcf_path ${known_snp_vcf_path} --thread_count ${thread_count} --tmp-outdir-prefix ${tmp_dir}"
    for bam_url in ${bam_url_array}
    do
        local bam_name=$(basename ${bam_url})
        local bam_path=${storage_dir}/${bam_name}
        local bam_paths="${bam_paths} --bam_path ${bam_path}"
    done
    local cwl_command="${cwl_command} ${bam_paths}"

    # run cwl
    local this_virtenv_dir=${HOME}/.virtualenvs/p2_${case_id}
    local cwlrunner_path=${this_virtenv_dir}/bin/cwltool
    echo "calling:
         ${cwlrunner_path} ${cwl_command}"
    ${cwlrunner_path} ${cwl_command}

    cd ${prev_wd}
}

function upload_coclean_results()
{
    local case_id=$1
    local bam_url_array=$2
    local s3_out_bucket=$3
    local s3_log_bucket=$4
    local s3_cfg_path=$5
    local storage_dir=$6
    
    
    local coclean_dir=${storage_dir}/coclean
    local prev_wd=`pwd`
    cd ${coclean_dir}
    for bam_url in ${bam_url_array}
    do
        local gdc_id=$(basename $(dirname ${bam_url}))
        local bam_file=$(basename ${bam_url})
        local bam_base="${bam_file%.*}"
        local bai_file="${bam_base}.bai"
        local bam_path=${coclean_dir}/${bam_file}
        local bai_path=${coclean_dir}/${bai_file}
        echo "uploading: s3cmd -c ${s3_cfg_path} put ${bai_path} ${S3_OUT_BUCKET}/${gdc_id}/"
        s3cmd -c ${s3_cfg_path} put ${bai_path} ${s3_out_bucket}/${gdc_id}/
        echo "uploading: s3cmd -c ${s3_cfg_path} put ${bam_path} ${S3_OUT_BUCKET}/${gdc_id}/"
        s3cmd -c ${s3_cfg_path} put ${bam_path} ${s3_out_bucket}/${gdc_id}/
    done
    s3cmd -c ${s3_cfg_path} put ${coclean_dir}/${case_id}.db ${s3_log_bucket}/
}

function remove_data()
{
    local data_dir=$1
    local case_id=$2
    echo "rm -rf ${data_dir}"
    rm -rf ${data_dir}
    local this_virtenv_dir=${HOME}/.virtualenvs/p2_${case_id}
    echo "rm -rf ${this_virtenv_dir}"
    rm -rf ${this_virtenv_dir}
}

function get_git_name()
{
    local repo_str=${GIT_CWL_REPO} #only global used in a function
    local git_array=(${repo_str})
    local git_url=${git_array[-1]}
    echo "repo_str=${repo_str}"
    echo "git_url=${git_url}"
    IFS=':' read -r -a array <<< "${git_url}"
    owner_repo=${array[-1]}
    echo "owner_repo=${owner_repo}"
    git_repo=$(basename ${owner_repo})
    echo "git_repo=${git_repo}"
    git_name="${git_repo%.*}"
    echo "${git_name}"
}

function main()
{
    local data_dir="${SCRATCH_DIR}/data_"${CASE_ID}
    remove_data ${data_dir} ${CASE_ID} ## removes all data from previous run of script
    mkdir -p ${data_dir}
    
    get_git_name
    echo "git_name=${git_name}"
    local cwl_dir=${data_dir}/${git_name}
    local cwl_pip_requirements="${cwl_dir}/slurm_sh/requirements.txt"
    
    setup_deploy_key "${S3_CFG_PATH}" "${GIT_CWL_DEPLOY_KEY_S3_URL}" "${data_dir}"
    clone_git_repo "${GIT_CWL_SERVER}" "${GIT_CWL_SERVER_FINGERPRINT}" "${GIT_CWL_REPO}" "${EXPORT_PROXY_STR}" "${data_dir}" "${git_name}"
    install_unique_virtenv "${CASE_ID}" "${EXPORT_PROXY}"
    pip_install_requirements "${cwl_pip_requirements}" "${EXPORT_PROXY}"
    
    #get_gatk_index_files ${S3_CFG_PATH} ${S3_GATK_INDEX_BUCKET} ${data_dir} \
    #                     ${REFERENCE_GENOME} ${KNOWN_SNP_VCF} ${KNOWN_INDEL_VCF}
    #get_bam_files ${S3_CFG_PATH} ${bam_url_array} ${data_dir}

    ###setup path variables
    local buildbamindex_tool_path=${cwl_dir}/tools/${BUILDBAMINDEX_TOOL}
    local coclean_workflow_path=${cwl_dir}/workflows/${COCLEAN_WORKFLOW}
    local reference_genome_path=${data_dir}/index/${REFERENCE_GENOME}
    local known_indel_vcf_path=${data_dir}/index/${KNOWN_INDEL_VCF}
    local known_snp_vcf_path=${data_dir}/index/${KNOWN_SNP_VCF}
    
    #generate_bai_files ${data_dir} ${bam_url_array} ${CASE_ID} ${buildbamindex_tool_path}
    #run_coclean ${data_dir} ${bam_url_array} ${CASE_ID} ${coclean_workflow_path} \
    #            ${reference_genome_path} ${known_indel_vcf_path} ${known_snp_vcf_path} \
    #            ${THREAD_COUNT}
    #upload_coclean_results ${case_id} ${bam_url_array} ${S3_OUT_BUCKET} ${S3_LOG_BUCKET} ${S3_CFG_PATH} \
    #                       ${data_dir}
    #remove_data ${data_dir} ${CASE_ID}
}

main "$@"
