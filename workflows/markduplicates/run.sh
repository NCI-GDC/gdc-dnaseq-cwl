#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=XX_SCRATCH_DIR_XX
#SBATCH --cpus-per-task=XX_THREAD_COUNT_XX
#SBATCH --mem=18000


UUID=
BAM_NAME=
#output buckets
S3_OUT_BUCKET="s3://ceph_qcpass_tcga_exome_blca_coclean"
S3_LOG_BUCKET="s3://ceph_qcpass_tcga_exome_blca_coclean_log"



function queue_status_update()
{
    echo ""
    echo "queue_status_update()"

    local data_dir="${1}"
    local cwl_tool="${2}"
    local git_cwl_repo="${3}"
    local git_cwl_hash="${4}"
    local case_id="${5}"
    local bam_url_array="${6}"
    local status="${7}"
    local table_name="${8}"
    local s3cfg_path="${9}"
    local db_cred_s3url="${10}"
    local s3_out_bucket="${11}"

    echo "status=${status}"
    echo "table_name=${table_name}"
    
    get_git_name "${git_cwl_repo}"
    echo "git_name=${git_name}"
    local cwl_dir=${data_dir}/${git_name}
    local cwl_tool_path=${cwl_dir}/${cwl_tool}


    local this_virtenv_dir="${HOME}/.virtualenvs/cwl"
    local cwlrunner_path="${this_virtenv_dir}/bin/cwltool"
    for bam_url in ${bam_url_array}
    do
        local gdc_id=$(basename $(dirname ${bam_url}))

        if [ ${db_cred_s3url} == "XX_DB_CRED_S3URL_XX" ]
        then
            local cwl_command="--debug --cachedir /mnt/SCRATCH/cache/ --tmpdir-prefix /mnt/SCRATCH/tmp/tmp/ --enable-net --custom-net host --outdir ${data_dir} ${cwl_tool_path} --uuid ${uuid} --repo ${git_cwl_repo} --repo_hash ${git_cwl_hash} --table_name ${table_name} --status ${status}"
        elif [[ "${status}" == "COMPLETE" ]]
        then
            local bam_file=$(basename ${bam_url})
            local s3_url=${s3_out_bucket}/${gdc_id}/${bam_file}
            local cwl_command="--debug --outdir ${data_dir} ${cwl_tool_path} --case_id ${case_id} --db_cred_s3url ${db_cred_s3url} --gdc_id ${gdc_id} --repo ${git_cwl_repo} --repo_hash ${git_cwl_hash} --s3cfg_path ${s3cfg_path} --table_name ${table_name} --status ${status} --s3_url ${s3_url}"
        else
            local cwl_command="--debug --outdir ${data_dir} ${cwl_tool_path} --case_id ${case_id} --db_cred_s3url ${db_cred_s3url} --gdc_id ${gdc_id} --repo ${git_cwl_repo} --repo_hash ${git_cwl_hash} --s3cfg_path ${s3cfg_path} --table_name ${table_name} --status ${status}"
        fi
        echo "${cwlrunner_path} ${cwl_command}"
        ${cwlrunner_path} ${cwl_command}
    done
}


function main()
{
    activate_virtualenv
    queue_status_update "${data_dir}" "${QUEUE_STATUS_TOOL}" "${GIT_CWL_REPO}" "${GIT_CWL_HASH}" "${CASE_ID}" "${BAM_URL_ARRAY}" "RUNNING" "coclean_caseid_queue" "${S3_CFG_PULL_PATH}" "${DB_CRED_URL}" "${S3_OUT_BUCKET}"

    
    queue_status_update "${data_dir}" "${QUEUE_STATUS_TOOL}" "${GIT_CWL_REPO}" "${GIT_CWL_HASH}" "${CASE_ID}" "${BAM_URL_ARRAY}" "COMPLETE" "coclean_caseid_queue" "${S3_CFG_PULL_PATH}" "${DB_CRED_URL}" "${S3_OUT_BUCKET}"

}

main "$@"
