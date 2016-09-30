#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=/mnt/SCRATCH
#SBATCH --mem=18000

##ENV VARIABLE
SCRATCH_DIR=/mnt/SCRATCH
CACHE_DIR=${SCRATCH_DIR}/cache/cache
TMP_DIR=${SCRATCH_DIR}/tmp/tmp
VIRTUALENV_NAME=p2

##JOB VARIABLE
BAM_SIGNPOST_ID=fe73fd64-9913-4fee-bdc7-4a2de2e14606
CWL_RUNNER_PATH=${HOME}/cocleaning-cwl/workflows/dnaseq/runner.cwl
JSON_PATH=${HOME}/cocleaning-cwl/workflows/dnaseq/ex_runner.json
UUID=XX_UUID_XX

##FAIL VARIABLE
CWL_STATUS_PATH=${HOME}/cocleaning-cwl/workflows/status/status_postgres_workflow.cwl
DB_CRED_PATH=${HOME}/connect_jhsavage_test.ini
DB_TABLE_NAME=wgs_330_status
GIT_REPO=https://github.com/NCI-GDC/cocleaning-cwl
GIT_REPO_HASH=393704572ad4109bc5cca8942c294cad1678ce7b

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

    echo cwltool --debug --cachedir ${cache_dir} --tmpdir-prefix ${tmp_dir} --enable-net --custom-net host --outdir ${job_dir} ${cwl_path} ${json_path}
    cwltool --debug --cachedir ${cache_dir} --tmpdir-prefix ${tmp_dir} --enable-net --custom-net host --outdir ${job_dir} ${cwl_path} ${json_path}
}

function status_fail()
{
    local bam_signpost_id=${1}
    local cache_dir=${2}
    local cwl_status_path=${3}
    local db_cred_path=${4}
    local db_table_name=${5}
    local ini_section=${6}
    local job_dir=${7}
    local repo=${8}
    local repo_hash=${9}
    local tmp_dir=${10}
    local uuid=${11}

    cwltool --debug --cachedir ${cache_dir} --tmpdir-prefix ${tmp_dir} --enable-net --custom-net host --outdir ${job_dir} ${cwl_status_path} --ini_section ${ini_section} --input_signpost_id ${bam_signpost_id} --postgres_creds_path ${db_cred_path} --repo ${repo} --repo_hash ${repo_hash} --status FAIL --table_name ${db_table_name} --uuid ${uuid}
    if [ $? -ne 0 ]
    then
        echo FAIL TO FAIL
        exit 1
    fi
}

function main()
{
    local bam_signpost_id=${BAM_SIGNPOST_ID}
    local cwl_runner_path=${CWL_RUNNER_PATH}
    local cwl_status_path=${CWL_STATUS_PATH}
    local db_cred_path=${DB_CRED_PATH}
    local db_table_name=${DB_TABLE_NAME}
    local json_path=${JSON_PATH}
    local repo=${REPO}
    local repo_hash=${REPO_HASH}
    local scratch_dir=${SCRATCH_DIR}
    local uuid=${UUID}
    local virtualenv_name=${VIRTUALENV_NAME}
    local cache_dir=${scratch_dir}/${uuid}/cache
    local job_dir=${scratch_dir}/${uuid}/
    local tmp_dir=${scratch_dir}/${uuid}/tmp

    mkdir -p ${cache_dir}
    mkdir -p ${job_dir}
    mkdir -p ${tmp_dir}

    activate_virtualenv ${virtualenv_name}

    runner ${cache_dir} ${cwl_runner_path} ${job_dir} ${json_path} ${tmp_dir}
    if [ $? -ne 0 ]
    then
        echo FAIL
        status_fail ${bam_signpost_id} ${cache_dir} ${cwl_status_path} ${db_cred_path} ${db_table_name} ${ini_section} \
                    ${job_dir} ${repo} ${repo_hash} ${tmp_dir} ${uuid}
        exit 1
    fi

    #rm -rf ${job_dir}
}

main "$@"
