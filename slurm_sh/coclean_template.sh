#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=/mnt/scratch/

SCRATCH_DIR="/mnt/scratch"
BAM_URL_ARRAY="XX_BAM_URL_ARRAY_XX"
CASE_ID="XX_CASE_ID_XX"
THREAD_COUNT=XX_THREAD_COUNT_XX
S3_CFG_PATH=${HOME}/.s3cfg.cleversafe
GIT_CWL_SERVER="github.com"
GIT_CWL_SERVER_FINGERPRINT="16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48"
GIT_CWL_DEPLOY_KEY="s3://bioinformatics_scratch/deploy_key/coclean_cwl_deploy_rsa"
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
CWL_RUNNER_TMPDIR_PREFIX="XX_TMPDIR_PREFIX_XX"

function install_unique_virtenv()
{
    uuid=$1
    export_proxy_str=$2
    eval ${export_proxy_str}
    pip install virtualenvwrapper --user
    source ${HOME}/.local/bin/virtualenvwrapper.sh
    mkvirtualenv --python /usr/bin/python2 p2_${uuid}
    this_virtenv_dir=${HOME}/.virtualenvs/p2_${uuid}
    source ${this_virtenv_dir}/bin/activate
    pip install --upgrade pip
}

function pip_install_requirements()
{
    requirements_path=$1
    export_proxy_str=$2
    eval ${export_proxy_str}
    pip install -r ${requirements_path}
}

function setup_deploy_key()
{
    s3_cfg_path=$1
    s3_deploy_key_url=$2
    store_dir=$3
    prev_wd=`pwd`
    key_name=$(basename ${s3_deploy_key_url})
    cd ${store_dir}
    eval `ssh-agent`
    s3cmd -c ${s3_cfg_path} get ${s3_deploy_key_url}
    ssh-add ${key_name}
    cd ${prev_wd}
}

function clone_git_repo()
{
    git_server=$1
    git_server_fingerprint=$2
    git_repo=$3
    export_proxy_str=$4
    storage_dir=$5
    prev_wd=`pwd`
    eval ${export_proxy_str}
    cd ${storage_dir}
    #check if key is in known hosts
    ssh-keygen -H -F ${git_server} | grep "Host ${git_server} found: line 1 type RSA" -
    if [ $? -q 0 ]
    then
        git clone ${git_repo}
    else # if not known, get key, check it, then add it
        ssh-keyscan ${git_server} > ${git_server}_gitkey
        echo `ssh-keygen -lf gitkey` | grep ${git_server_fingerprint}
        if [ $? -q 0 ]
        then
            cat ${git_server}_gitkey >> ${HOME}/.ssh/known_hosts
            git clone ${git_repo}
        else
            echo "git server fingerprint is not ${git_server_fingerprint}, but instead:  `ssh-keygen -lf ${git_server}_gitkey`"
            exit 1
        fi
    fi
    cd ${prev_wd}
}


function get_gatk_index_files()
{
    s3_cfg_path=$1
    s3_index_bucket=$2
    storage_dir=$3
    reference_genome=$4
    known_snp_vcf=$5
    known_indel_vcf=$6

    gatk_index_dir="${storage_dir}/index"
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
    s3_cfg_path=$1
    bam_url_array=$2
    storage_dir=$3
    prev_wd=`pwd`
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
        local cwl_command="--debug --outdir ${storage_dir} ${BUILDBAMINDEX_TOOL_PATH} --uuid ${case_id} --input_bam ${bam_path}"

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
    local prev_wd=`pwd`
    mkdir -p ${coclean_dir}
    cd ${coclean_dir}
    
    # setup cwl command removed  --leave-tmpdir
    cwl_command="--debug --outdir ${coclean_dir} ${coclean_workflow_path} --reference_fasta_path ${reference_genome_path}.fa --uuid ${case_id} --known_indel_vcf_path ${known_indel_vcf_path} --known_snp_vcf_path ${known_snp_vcf_path} --thread_count ${thread_count}"
    for bam_url in ${bam_url_array}
    do
        bam_name=$(basename ${bam_url})
        bam_path=${storage_dir}/${bam_name}
        bam_paths="${bam_paths} --bam_path ${bam_path}"
    done
    cwl_command="${cwl_command} ${bam_paths}"

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
    repo_str=$1
    git_url=($repo_str)[-1]
    IFS=':' read -r -a array <<< "$git_url"
    git_reponame=($array)[-1]
    git_name="${git_reponame%.*}"
    echo "$git_name"
}

function main()
{
    data_dir="${SCRATCH_DIR}/data_"${CASE_ID}
    mkdir -p ${data_dir}
    setup_deploy_key ${S3_CFG_PATH} ${S3_DEPLOY_KEY_URL} ${data_dir}
    clone_git_repo ${GIT_SERVER} ${GIT_SERVER_FINGERPRINT} ${GIT_CWL_REPO} ${EXPORT_PROXY_STR} ${data_dir}    
    install_unique_virtenv ${CASE_ID} ${EXPORT_PROXY}

    git_name=$(get_git_name ${GIT_CWL_REPO})
    cwl_dir=${data_dir}/${git_name}
    cwl_pip_requirements=${cwl_dir}/slurm_sh/requirements.sh

    pip_install_requirments ${cwl_pip_requirements} ${EXPORT_PROXY}
    get_gatk_index_files ${S3_CFG_PATH} ${S3_GATK_INDEX_BUCKET} ${data_dir} \
                         ${REFERENCE_GENOME} ${KNOWN_SNP_VCF} ${KNOWN_INDEL_VCF}
    get_bam_files ${S3_CFG_PATH} ${bam_url_array} ${data_dir}

    #setup path variables
    buildbamindex_tool_path=${cwl_dir}/tools/${BUILDBAMINDEX_TOOL}
    coclean_workflow_path=${cwl_dir}/workflows/${COCLEAN_WORKFLOW}
    reference_genome_path=${data_dir}/index/${REFERENCE_GENOME}
    known_indel_vcf_path=${data_dir}/index/${KNOWN_INDEL_VCF}
    known_snp_vcf_path=${data_dir}/index/${KNOWN_SNP_VCF}
    
    generate_bai_files ${data_dir} ${bam_url_array} ${CASE_ID} ${buildbamindex_tool_path}
    run_coclean ${data_dir} ${bam_url_array} ${CASE_ID} ${coclean_workflow_path} \
                ${reference_genome_path} ${known_indel_vcf_path} ${known_snp_vcf_path} \
                ${THREAD_COUNT}
    upload_coclean_results ${case_id} ${bam_url_array} ${S3_OUT_BUCKET} ${S3_LOG_BUCKET} ${S3_CFG_PATH} \
                           ${data_dir}
    remove_data ${data_dir} ${CASE_ID}
}

main "$@"
