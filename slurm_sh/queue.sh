
local repo="${}"
local repo_hash="${}"
local s3cfg_path="${}"
local s3_url="${}"
local status="QUEUED"
local table_name="coclean_caseid_queue"
local gdc_id="${}"
local case_id="${}"
local db_cred_s3url="${}"
docker run -i quay.io/jeremiahsavage/queue_status --debug --outdir --case_id ${case_id} --db_cred_s3url ${db_cred_s3url} --gdc_id ${gdc_id} --repo ${git_cwl_repo} --repo_hash ${git_cwl_hash} --s3cfg_path ${s3cfg_path} --table_name ${table_name} --status ${status}
