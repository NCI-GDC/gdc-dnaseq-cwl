#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=XX_SCRATCH_DIR_XX
###SBATCH --cpus-per-task=XX_THREAD_COUNT_XX


#environment variables
SCRATCH_DIR="XX_SCRATCH_DIR_XX"
THREAD_COUNT=XX_THREAD_COUNT_XX

#job variables
BAM_URL_ARRAY="XX_BAM_URL_ARRAY_XX"
CASE_ID="XX_CASE_ID_XX"

#server environment
S3_CFG_PATH=${HOME}/.s3cfg.cleversafe
EXPORT_PROXY_STR="export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128;"

#private cwl
GIT_CWL_SERVER="github.com"
GIT_CWL_SERVER_FINGERPRINT="2048 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48"
GIT_CWL_DEPLOY_KEY_S3_URL="s3://bioinformatics_scratch/deploy_key/coclean_cwl_deploy_rsa"
GIT_CWL_REPO=" -b slurm_script git@github.com:NCI-GDC/cocleaning-cwl.git"
COCLEAN_WORKFLOW="workflows/coclean/coclean_workflow.cwl.yaml"
BUILDBAMINDEX_TOOL="tools/picard_buildbamindex.cwl.yaml"


#cwl runner
CWLTOOL_REQUIREMENTS_PATH="slurm_sh/requirements.txt"
CWLTOOL_URL="https://github.com/chapmanb/cwltool.git"
CWLTOOL_HASH="221cf2395b2745ae1c3899c691d94edf3152327d"

#index file names
KNOWN_INDEL_VCF="Homo_sapiens_assembly38.known_indels.vcf.gz"
KNOWN_SNP_VCF="dbsnp_144.hg38.vcf.gz"
REFERENCE_GENOME="GRCh38.d1.vd1"

#input bucket
S3_GATK_INDEX_BUCKET="s3://bioinformatics_scratch/coclean"
#output buckets
S3_OUT_BUCKET="s3://tcga_exome_blca_coclean"
S3_LOG_BUCKET="s3://tcga_exome_blca_coclean_log"


function get_git_name()
{
    echo ""
    echo "get_git_name()"
    
    local repo_str="$1"

    local git_array=(${repo_str})
    local git_url=${git_array[-1]}
    echo "repo_str=${repo_str}"
    echo "git_url=${git_url}"
    IFS=':' read -r -a array <<< "${git_url}"
    owner_repo=${array[-1]}
    echo "owner_repo=${owner_repo}"
    git_repo=$(basename ${owner_repo})
    echo "git_repo=${git_repo}"
    git_name="${git_repo%.*}" # need global var for return
    echo "${git_name}"
}

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
    local this_virtenv_dir=${HOME}/.virtualenvs/p2_${uuid}
    source ${this_virtenv_dir}/bin/activate
    pip install --upgrade pip
}

function pip_install_requirements()
{
    echo ""
    echo "pip_install_requirements()"

    local git_cwl_repo="$1"
    local requirements_path="$2"
    local export_proxy_str="$3"
    local data_dir=$4
    local uuid=$5

    local this_virtenv_dir=${HOME}/.virtualenvs/p2_${uuid}
    source ${this_virtenv_dir}/bin/activate
    
    get_git_name "${git_cwl_repo}"
    echo ${git_name}
    requirments_dir="${data_dir}/${git_name}/"
    requirements_path="${requirments_dir}/${requirements_path}"
    
    eval ${export_proxy_str}
    pip install -r ${requirements_path}
}

function setup_deploy_key()
{
    echo ""
    echo "setup_deploy_key()"
    
    local s3_cfg_path="$1"
    local s3_deploy_key_url="$2"
    local data_dir="$3"
    
    local prev_wd=`pwd`
    local key_name=$(basename ${s3_deploy_key_url})
    echo "cd ${data_dir}"
    cd ${data_dir}
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
    local data_dir="$5"

    
    local prev_wd=`pwd`
    echo "eval ${export_proxy_str}"
    eval ${export_proxy_str}
    echo "cd ${data_dir}"
    cd ${data_dir}
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
            cd ${prev_wd}
            exit 1
        fi
    fi
    cd ${prev_wd}
}


function get_gatk_index_files()
{
    echo ""
    echo "get_gatk_index_files()"
    
    local s3_cfg_path="$1"
    local s3_index_bucket="$2"
    local index_dir="$3"
    local reference_genome="$4"
    local known_snp_vcf="$5"
    local known_indel_vcf="$6"

    local gatk_index_dir="${index_dir}"
    mkdir -p ${gatk_index_dir}
    prev_wd=`pwd`
    echo "cd ${gatk_index_dir}"
    cd ${gatk_index_dir}
    
    s3cmd -c ${s3_cfg_path} --force get ${s3_index_bucket}/${reference_genome}.dict
    s3cmd -c ${s3_cfg_path} --force get ${s3_index_bucket}/${reference_genome}.fa
    s3cmd -c ${s3_cfg_path} --force get ${s3_index_bucket}/${reference_genome}.fa.fai
    s3cmd -c ${s3_cfg_path} --force get ${s3_index_bucket}/${known_snp_vcf}
    s3cmd -c ${s3_cfg_path} --force get ${s3_index_bucket}/${known_snp_vcf}.tbi
    s3cmd -c ${s3_cfg_path} --force get ${s3_index_bucket}/${known_indel_vcf}
    s3cmd -c ${s3_cfg_path} --force get ${s3_index_bucket}/${known_indel_vcf}.tbi

    echo "cd ${prev_wd}"
    cd ${prev_wd}
}

function get_bam_files()
{
    echo ""
    echo "get_bam_files()"
    
    local s3_cfg_path="$1"
    local bam_url_array="$2"
    local data_dir="$3"

    echo "s3_cfg_path=${s3_cfg_path}"
    echo "bam_url_array=${bam_url_array}"
    echo "data_dir=${data_dir}"
    
    local prev_wd=`pwd`
    echo "cd ${data_dir}"
    cd ${data_dir}
    for bam_url in ${bam_url_array}
    do
        echo "s3cmd -c ${s3_cfg_path} --force get ${bam_url}"
        s3cmd -c ${s3_cfg_path} --force get ${bam_url}
    done
    echo "cd ${prev_wd}"
    cd ${prev_wd}
}

function generate_bai_files()
{
    echo ""
    echo "generate_bai_files()"
    
    local data_dir="$1"
    local bam_url_array="$2"
    local case_id="$3"
    local git_cwl_repo="$4"
    local buildbamindex_tool="$5"

    get_git_name "${git_cwl_repo}"
    echo "git_name=${git_name}"
    local cwl_dir=${data_dir}/${git_name}
    local cwl_tool_path=${cwl_dir}/${buildbamindex_tool}
    
    local prev_wd=`pwd`
    cd ${data_dir}

    local this_virtenv_dir=${HOME}/.virtualenvs/p2_${case_id}
    local cwlrunner_path=${this_virtenv_dir}/bin/cwltool

    for bam_url in ${bam_url_array}
    do
        local bam_name=$(basename ${bam_url})
        local bam_path=${data_dir}/${bam_name}
        local cwl_command="--debug --outdir ${data_dir} ${cwl_tool_path} --uuid ${case_id} --input_bam ${bam_path}"

        echo "${cwlrunner_path} ${cwl_command}"
        ${cwlrunner_path} ${cwl_command}
    done
    cd ${prev_wd}
}

function run_coclean()
{
    echo ""
    echo "run_coclean()"
    
    local data_dir="$1"
    local bam_url_array="$2"
    local case_id="$3"
    local coclean_workflow="$4"
    local reference_genome="$5"
    local known_indel_vcf="$6"
    local known_snp_vcf="$7"
    local thread_count="$8"
    local git_cwl_repo="$9"
    local index_dir="$10"

    local reference_genome_path=${index_dir}/${reference_genome}
    local known_indel_vcf_path=${index_dir}/${known_indel_vcf}
    local known_snp_vcf_path=${index_dir}/${known_snp_vcf}
    
    get_git_name "${git_cwl_repo}"
    local cwl_dir=${data_dir}/${git_name}
    local workflow_path=${cwl_dir}/${coclean_workflow}
    
    local coclean_dir=${data_dir}/coclean
    local tmp_dir=${data_dir}/tmp/tmp
    local tmpout_dir=${data_dir}/tmp_out/tmp
    local prev_wd=`pwd`
    mkdir -p ${coclean_dir}
    mkdir -p $(dirname ${tmp_dir})
    mkdir -p $(dirname ${tmpout_dir})
    cd ${coclean_dir}
    
    # setup cwl command removed  --leave-tmpdir
    local cwl_command="--debug --outdir ${coclean_dir} --tmpdir-prefix ${tmp_dir} --tmp-outdir-prefix ${tmpout_dir} ${workflow_path} --reference_fasta_path ${reference_genome_path}.fa --uuid ${case_id} --known_indel_vcf_path ${known_indel_vcf_path} --known_snp_vcf_path ${known_snp_vcf_path} --thread_count ${thread_count}"
    for bam_url in ${bam_url_array}
    do
        local bam_name=$(basename ${bam_url})
        local bam_path=${data_dir}/${bam_name}
        local bam_paths="${bam_paths} --bam_path ${bam_path}"
    done
    local cwl_command="${cwl_command} ${bam_paths}"

    # run cwl
    local this_virtenv_dir=${HOME}/.virtualenvs/p2_${case_id}
    local cwlrunner_path=${this_virtenv_dir}/bin/cwltool
    echo "calling:
         ${cwlrunner_path} ${cwl_command}"
    ${cwlrunner_path} ${cwl_command}
    if [ $? -eq 0 ]
    then
        echo "completed cocleaning"
    else
        echo "failed cocleaning"
        ##update db with a fail
        exit 1
    fi
    cd ${prev_wd}
}

function upload_coclean_results()
{
    echo ""
    echo "upload_coclean_results()"
    
    local case_id="$1"
    local bam_url_array="$2"
    local s3_out_bucket="$3"
    local s3_log_bucket="$4"
    local s3_cfg_path="$5"
    local data_dir="$6"
    
    local coclean_dir=${data_dir}/coclean
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
    echo ""
    echo "remove_data()"
    
    local data_dir="$1"
    local case_id="$2"
    
    echo "rm -rf ${data_dir}"
    rm -rf ${data_dir}
    local this_virtenv_dir=${HOME}/.virtualenvs/p2_${case_id}
    echo "rm -rf ${this_virtenv_dir}"
    rm -rf ${this_virtenv_dir}
}

function clone_pip_git_hash()
{
    echo ""
    echo "clone_pip_cwltool()"

    local uuid="$1"
    local git_url="$2"
    local git_hash="$3"
    local data_dir="$4"
    local export_proxy_str="$5"

    echo uuid=${uuid}
    echo git_url=${git_url}
    echo git_hash=${git_hash}
    echo data_dir=${data_dir}
    echo export_proxy_str=${export_proxy_str}
    
    eval ${export_proxy_str}
    
    this_virtenv_dir=${HOME}/.virtualenvs/p2_${uuid}
    source ${this_virtenv_dir}/bin/activate

    prev_wd=`pwd`
    echo "cd ${data_dir}"
    cd ${data_dir}

    git clone ${git_url}
    get_git_name "${git_url}"
    echo "${git_name}"
    echo "cd ${data_dir}/${git_name}"
    cd ${data_dir}/${git_name}
    echo "git reset --hard ${git_hash}"
    git reset --hard ${git_hash}

    echo "pip install -e ."
    pip install -e .
}

function main()
{
    ## hit db with start time ${CASE_ID}

    local data_dir="${SCRATCH_DIR}/data_"${CASE_ID}
    local index_dir=${data_dir}/index
    
    #remove_data ${data_dir} ${CASE_ID} ## removes all data from previous run of script
    #mkdir -p ${data_dir}
    
   
    #setup_deploy_key "${S3_CFG_PATH}" "${GIT_CWL_DEPLOY_KEY_S3_URL}" "${data_dir}"
    #clone_git_repo "${GIT_CWL_SERVER}" "${GIT_CWL_SERVER_FINGERPRINT}" "${GIT_CWL_REPO}" "${EXPORT_PROXY_STR}" "${data_dir}"
    #install_unique_virtenv "${CASE_ID}" "${EXPORT_PROXY_STR}"
    #pip_install_requirements "${GIT_CWL_REPO}" "${CWLTOOL_REQUIREMENTS_PATH}" "${EXPORT_PROXY_STR}" "${data_dir}" "${CASE_ID}"
    #clone_pip_git_hash "${CASE_ID}" "${CWLTOOL_URL}" "${CWLTOOL_HASH}" "${data_dir}" "${EXPORT_PROXY_STR}"
    #get_gatk_index_files "${S3_CFG_PATH}" "${S3_GATK_INDEX_BUCKET}" "${index_dir}" "${REFERENCE_GENOME}" "${KNOWN_SNP_VCF}" "${KNOWN_INDEL_VCF}"
    #get_bam_files "${S3_CFG_PATH}" "${BAM_URL_ARRAY}" "${data_dir}"
    #generate_bai_files "${data_dir}" "${BAM_URL_ARRAY}" "${CASE_ID}" "${GIT_CWL_REPO}" "${BUILDBAMINDEX_TOOL}"
    run_coclean "${data_dir}" "${BAM_URL_ARRAY}" "${CASE_ID}" "${COCLEAN_WORKFLOW}" "${reference_genome_path}" "${known_indel_vcf_path}" "${known_snp_vcf_path}" "${THREAD_COUNT}" "${GIT_CWL_REPO}" "${index_dir}"
    #upload_coclean_results ${case_id} ${BAM_URL_ARRAY} ${S3_OUT_BUCKET} ${S3_LOG_BUCKET} ${S3_CFG_PATH} \
    #                       ${data_dir}
    #remove_data ${data_dir} ${CASE_ID}
    ## hit db with end time ${CASE_ID}
}

main "$@"
