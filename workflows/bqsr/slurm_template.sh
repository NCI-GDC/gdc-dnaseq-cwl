#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=XX_SCRATCH_DIR_XX
#SBATCH --cpus-per-task=XX_RESOURCE_CORE_COUNT_XX
##SBATCH## --mem=XX_RESOURCE_MEMORY_MEBIBYTES_XX
##SBATCH## --tmp=XX_RESOURCE_DISK_MEBIBYTES_XX

##ENV VARIABLE
SCRATCH_DIR=XX_SCRATCH_DIR_XX
CACHE_DIR=${SCRATCH_DIR}/cache/cache
TMP_DIR=${SCRATCH_DIR}/tmp/tmp
VIRTUALENV_NAME=p2

##JOB VARIABLE
INPUT_GDC_ID=XX_INPUT_GDC_ID_XX
CWL_RUNNER_PATH=${HOME}/gdc-dnaseq-cwl/workflows/bqsr/runner.cwl
JSON_PATH=XX_JSON_PATH_XX

##FAIL VARIABLE
CWL_STATUS_PATH=${HOME}/gdc-dnaseq-cwl/workflows/bqsr/status_postgres_workflow.cwl
DB_CRED_PATH=${HOME}/XX_DB_CRED_XX
DB_CRED_SECTION=DEFAULT
DB_TABLE_NAME=XX_DB_TABLE_NAME_XX
GIT_REPO=https://github.com/NCI-GDC/gdc-dnaseq-cwl
GIT_REPO_HASH=XX_REPO_HASH_XX

function activate_virtualenv()
{
    local virtualenv_name=${1}

    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
    source ${HOME}/.virtualenvs/${virtualenv_name}/bin/activate
}

function runner()
{
    local cache_dir=${1}
    local cwl_path=${2}
    local job_dir=${3}
    local json_path=${4}
    local tmp_dir=${5}

    cwltool --debug --tmp-outdir-prefix ${cache_dir} --tmpdir-prefix ${tmp_dir} --custom-net host --outdir ${job_dir} ${cwl_path} ${json_path}
}

function status_fail()
{
    local cache_dir=${1}
    local cwl_path=${2}
    local db_cred_path=${3}
    local db_cred_section=${4}
    local db_table_name=${5}
    local git_repo=${6}
    local git_repo_hash=${7}
    local input_gdc_id=${8}
    local job_dir=${9}
    local tmp_dir=${10}

    cwltool --debug --tmp-outdir-prefix ${cache_dir} --tmpdir-prefix ${tmp_dir} --custom-net host --outdir ${job_dir} ${cwl_path} --ini_section ${db_cred_section} --input_signpost_id ${input_gdc_id} --postgres_creds_path ${db_cred_path} --repo ${git_repo} --repo_hash ${git_repo_hash} --status FAIL --table_name ${db_table_name}
    if [ $? -ne 0 ]
    then
        echo FAIL TO FAIL
        exit 1
    fi
}

function main()
{
    local cwl_runner_path=${CWL_RUNNER_PATH}
    local cwl_status_path=${CWL_STATUS_PATH}
    local db_cred_path=${DB_CRED_PATH}
    local db_cred_section=${DB_CRED_SECTION}
    local db_table_name=${DB_TABLE_NAME}
    local json_path=${JSON_PATH}
    local git_repo=${GIT_REPO}
    local git_repo_hash=${GIT_REPO_HASH}
    local input_gdc_id=${INPUT_GDC_ID}
    local scratch_dir=${SCRATCH_DIR}

    local virtualenv_name=${VIRTUALENV_NAME}
    local cache_dir=${scratch_dir}/${input_gdc_id}/cache
    local job_dir=${scratch_dir}/${input_gdc_id}/
    local tmp_dir=${scratch_dir}/${input_gdc_id}/tmp

    mkdir -p ${cache_dir}
    mkdir -p ${job_dir}
    mkdir -p ${tmp_dir}
    activate_virtualenv ${virtualenv_name}
    runner ${cache_dir} ${cwl_runner_path} ${job_dir} ${json_path} ${tmp_dir}
    if [ $? -ne 0 ]
    then
        echo FAIL
        status_fail ${cache_dir} ${cwl_status_path} ${db_cred_path} ${db_cred_section} ${db_table_name} ${git_repo} ${git_repo_hash} ${input_gdc_id} ${job_dir} ${tmp_dir}
        exit 1
    fi
    rm -rf ${job_dir}
}

main "$@"
