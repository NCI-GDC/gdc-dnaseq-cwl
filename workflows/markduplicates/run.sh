#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=XX_SCRATCH_DIR_XX
#SBATCH --cpus-per-task=XX_THREAD_COUNT_XX
#SBATCH --mem=18000

##ENV VARIABLE
DB_CRED_PATH="XX_DB_CRED_PATH_XX"
SCRATCH_DIR="/mnt/SCRATCH"
CACHE_DIR="${SCRATCH_DIR}/cache"
TMP_DIR="${SCRATCH_DIR}/tmp/tmp"
VIRTUALENV_NAME="cwl"

##WORKFLOW
GIT_CWL_REPO="git@github.com:NCI-GDC/cocleaning-cwl.git"
GIT_CWL_HASH="XX_GIT_CWL_HASH_XX"
CWL_DIR="${HOME}/cocleaning-cwl"
QUEUE_STATUS_TOOL="tools/queue_status.cwl.yaml"
WORKFLOW="workflows/markduplicates/md_workflow.cwl.yaml"


##JOB VARIABLES
DB_TABLE_NAME="markduplicates_wgs_status"
ETL_JSON="XX_ETL_JSON_XX"
#"s3://ceph_markduplicates_wgs" "s3://bioinformatics_scratch/maydeletetest/"
S3_LOAD_BUCKET="XX_S3_LOAD_BUCKET_XX"
UUID="XX_UUID_XX"


function activate_virtualenv()
{
    local virtualenv_name="${1}"

    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
    source ${HOME}/.virtualenvs/${virtualenv_name}/bin/activate
}

function queue_status_update()
{
    local bam_name="${1}"
    local cache_dir="${2}"
    local cwl_dir="${3}"
    local cwl_tool="${4}"
    local db_cred_path="${5}"
    local db_table_name="${13}"
    local git_cwl_hash="${6}"
    local git_cwl_repo="${7}"
    local job_dir="${8}"
    local s3_load_bucket="${11}"
    local status="${12}"
    local uuid="${14}"
    
    local cwl_tool_path=${cwl_dir}/${cwl_tool}


    #local this_virtenv_dir="${HOME}/.virtualenvs/cwl"
    #local cwlrunner_path="${this_virtenv_dir}/bin/cwltool"
    local cwl_base_command="cwltool --debug --cachedir ${cache_dir} --tmpdir-prefix ${tmp_dir} --enable-net --custom-net host --outdir ${job_dir} ${cwl_tool_path} "
    if [[ "${status}" == "COMPLETE" ]]
    then
        local job_file="${job_dir}/${uuid}.out"
        local output_json=`tac ${job_file} | sed '/^{/q' | tac`
        local load_sha1=`echo ${output_json} | python -c 'import json,sys;obj=json.load(sys.stdin);print(obj["dnaseq_workflow_output_sqlite"]["checksum"])'`
        local load_size=`echo ${output_json} | python -c 'import json,sys;obj=json.load(sys.stdin);print(obj["dnaseq_workflow_output_sqlite"]["size"])'`
        local s3_url=${s3_load_bucket}/${uuid}/${bam_name}
        local cwl_command="${cwl_base_command} --cwl_sha1 ${load_sha1} --cwl_size ${load_size} --repo ${git_cwl_repo}  --repo_hash ${git_cwl_hash} --s3_url ${s3_url} --status ${status} --table_name ${db_table_name} --uuid ${uuid}"
    else
        local cwl_command="${cwl_base_command} --repo ${git_cwl_repo}  --repo_hash ${git_cwl_hash} --status ${status} --table_name ${db_table_name} --uuid ${uuid}"
    fi
    echo "${cwlrunner_path} ${cwl_command}"
    ${cwl_command}
done
}


function run_md()
{
    local cache_dir="${1}"
    local etl_cwl_path="${2}"
    local etl_json_path="${3}"
    local job_dir="${4}"
    local tmp_dir="${5}"
    local uuid="${6}"

    local cwl_command="cwltool --debug --cachedir ${cache_dir} --tmpdir-prefix ${tmp_dir} --enable-net --custom-net host --outdir ${job_dir} ${etl_cwl_path} ${etwl_json_path} > ${job_dir}/${uuid}.out"
    ${cwl_command}
}

function main()
{
    local cache_dir=${CACHE_DIR}
    local cwl_dir=${CWL_DIR}
    local db_cred_path=${DB_CRED_PATH}
    local db_table_name=${DB_TABLE_NAME}
    local etl_json_path=${ETL_JSON_PATH}
    local git_cwl_hash=${GIT_CWL_HASH}
    local git_cwl_repo=${GIT_CWL_REPO}
    local queue_status_tool=${QUEUE_STATUS_TOOL}
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
    
    mkdir -p ${cache_dir}
    mkdir -p ${job_dir}
    mkdir -p ${tmp_dir}

    activate_virtualenv "${virtualenv_name}"

    local status="RUNNING"
    queue_status_update "${bam_name}" "${cache_dir}" "${cwl_dir}" "${queue_status_tool}" "${db_cred_path}" "${db_table_name}" \
                        "${git_cwl_hash}" "${git_cwl_repo}" "${job_dir}" "${s3_load_bucket}" "${status}" "${uuid}"

    exit_status=run_md "${cache_dir}" "${etl_json_path}" "${job_dir}" "${tmp_dir}" "${uuid}"
    if [ ${exit_status} -ne 0]
    then
        local status="FAIL"
        queue_status_update "${bam_name}" "${cache_dir}" "${cwl_dir}" "${queue_status_tool}" "${db_cred_path}" "${db_table_name}" \
                            "${git_cwl_hash}" "${git_cwl_repo}" "${job_dir}" "${s3_load_bucket}" "${status}" "${uuid}"
    else
        local status="COMPLETE"
        queue_status_update "${bam_name}" "${cache_dir}" "${cwl_dir}" "${queue_status_tool}" "${db_cred_path}" "${db_table_name}" \
                            "${git_cwl_hash}" "${git_cwl_repo}" "${job_dir}" "${s3_load_bucket}" "${status}" "${uuid}"
    fi

}

main "$@"
