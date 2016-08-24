#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=XX_SCRATCH_DIR_XX
#SBATCH --cpus-per-task=XX_THREAD_COUNT_XX

##ENV VARIABLE
SCRATCH_DIR="XX_SCRATCH_DIR_XX"
CACHE_DIR="${SCRATCH_DIR}/cache/cache"
TMP_DIR="${SCRATCH_DIR}/tmp/tmp"
VIRTUALENV_NAME="cwl"

##WORKFLOW
GIT_CWL_REPO="git@github.com:NCI-GDC/cocleaning-cwl.git"
GIT_CWL_HASH="XX_GIT_CWL_HASH_XX"
CWL_DIR="${HOME}/cocleaning-cwl"
QUEUE_STATUS_WORKFLOW="workflows/status/status_postgres_workflow.cwl.yaml"
WORKFLOW="workflows/read_write/etl.cwl"

##JOB VARIABLES
DB_TABLE_NAME='read_write'
ETL_JSON_PATH="XX_ETL_JSON_PATH_XX"
S3_LOAD_BUCKET="XX_S3_LOAD_BUCKET_XX"
UUID="XX_UUID_XX"

function activate_virtualenv()
{
    local virtualenv_name="${1}"

    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
    source ${HOME}/.virtualenvs/${virtualenv_name}/bin/activate
}


function run_stress()
{
    local cache_dir="${1}"
    local etl_cwl_path="${2}"
    local etl_json_path="${3}"
    local job_dir="${4}"
    local tmp_dir="${5}"
    local uuid="${6}"

    echo cwltool --debug --rm-tmpdir --tmp-outdir-prefix ${cache_dir} --tmpdir-prefix ${tmp_dir} --enable-net --custom-net host --outdir ${job_dir} ${etl_cwl_path} ${etl_json_path}
    cwltool --debug --rm-tmpdir --tmp-outdir-prefix ${cache_dir} --tmpdir-prefix ${tmp_dir} --enable-net --custom-net host --outdir ${job_dir} ${etl_cwl_path} ${etl_json_path}
}

function main()
{
    local cache_dir=${CACHE_DIR}
    local cghub_id=${CGHUB_ID}
    local cwl_dir=${CWL_DIR}
    local db_table_name=${DB_TABLE_NAME}
    local etl_json_path=${ETL_JSON_PATH}
    local git_cwl_hash=${GIT_CWL_HASH}
    local git_cwl_repo=${GIT_CWL_REPO}
    local s3_load_bucket=${S3_LOAD_BUCKET}
    local scratch_dir=${SCRATCH_DIR}
    local tmp_dir=${TMP_DIR}
    local uuid=${UUID}
    local virtualenv_name=${VIRTUALENV_NAME}
    local workflow=${WORKFLOW}

    local bam_signpost_json=`cat ${etl_json_path} | python -c 'import json,sys;obj=json.load(sys.stdin);print(obj["bam_signpost_json"]["path"])'`
    local input_s3_url=`cat ${bam_signpost_json} | python -c 'import json,sys;obj=json.load(sys.stdin);print(obj["urls"][0])'`
    local bam_name=$(basename ${input_s3_url})
    local s3_out_object="${s3_load_bucket}/${uuid}/${bam_name}"
    local job_dir="${scratch_dir}/${db_table_name}/${uuid}"
    local etl_cwl_path="${cwl_dir}/${workflow}"

    mkdir -p ${cache_dir}
    mkdir -p ${job_dir}
    mkdir -p ${tmp_dir}

    activate_virtualenv "${virtualenv_name}"

    run_stress "${cache_dir}" "${etl_cwl_path}" "${etl_json_path}" "${job_dir}" "${tmp_dir}" "${uuid}"
    if [ $? -ne 0 ]
    then
        rm -rf /mnt/SCRATCH/cache
        rm -rf /mnt/SCRATCH/tmp
        exit 1
    else
        rm -rf /mnt/SCRATCH/cache
        rm -rf /mnt/SCRATCH/tmp
        exit 0
    fi
}

main "$@"
