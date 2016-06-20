#!/bin/bash

#server environment
S3_CFG_PATH="${HOME}/.s3cfg.cleversafe"
EXPORT_PROXY_STR="export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128;"
DB_CRED_URL="s3://bioinformatics_scratch/deploy_key/connect_jhsavage.ini"
QUAY_PULL_KEY_URL="s3://bioinformatics_scratch/deploy_key/.dockercfg"

#private cwl
GIT_CWL_SERVER="github.com"
GIT_CWL_SERVER_FINGERPRINT="2048 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48"
GIT_CWL_DEPLOY_KEY_S3_URL="s3://bioinformatics_scratch/deploy_key/coclean_cwl_deploy_rsa"
GIT_CWL_REPO="git@github.com:NCI-GDC/cocleaning-cwl.git"
GIT_CWL_HASH="703c650c19ff40f4899c85597b08b541150eade2"
COCLEAN_WORKFLOW="workflows/coclean/coclean_workflow.cwl.yaml"
BUILDBAMINDEX_TOOL="tools/picard_buildbamindex.cwl.yaml"
QUEUE_STATUS_TOOL="tools/queue_status.cwl.yaml"

#cwl runner
CWLTOOL_REQUIREMENTS_PATH="slurm_sh/requirements.txt"
CWLTOOL_URL="https://github.com/chapmanb/cwltool.git"
CWLTOOL_HASH="221cf2395b2745ae1c3899c691d94edf3152327d"

function queue_status_update()
{
    echo ""
    echo "queue_status_update()"

    local data_dir="$1"
    local cwl_tool="$2"
    local s3cfg_path="$3"
    local db_cred_s3url="$4"
    local git_cwl_repo="$5"
    local git_cwl_hash="$6"
    local case_id="$7"
    local bam_url_array="$8"
    local status="$9"
    local table_name="${10}"
    local s3_out_bucket="${11}"

    echo "status=${status}"
    echo "table_name=${table_name}"
    
    get_git_name "${git_cwl_repo}"
    echo "git_name=${git_name}"
    local cwl_dir=${data_dir}/${git_name}
    local cwl_tool_path=${cwl_dir}/${cwl_tool}


    local this_virtenv_dir=${HOME}/.virtualenvs/p2_${case_id}
    local cwlrunner_path=${this_virtenv_dir}/bin/cwltool
    for bam_url in ${bam_url_array}
    do
        local gdc_id=$(basename $(dirname ${bam_url}))
        local cwl_command="--debug --outdir ${data_dir} ${cwl_tool_path} --case_id ${case_id} --db_cred_s3url ${db_cred_s3url} --gdc_id ${gdc_id} --repo ${git_cwl_repo} --repo_hash ${git_cwl_hash} --s3cfg_path ${s3cfg_path} --table_name ${table_name} --status ${status}"
        echo "${cwlrunner_path} ${cwl_command}"
        ${cwlrunner_path} ${cwl_command}
    done
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
    local git_cwl_hash="$6"

    get_git_name "${git_repo}"
    echo "git_name=${git_name}"

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
        cd ${git_name}
        echo "git checkout ${git_cwl_hash}"
        git checkout ${git_cwl_hash}
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
            cd ${git_name}
            echo "git checkout ${git_cwl_hash}"
            git checskout ${git_cwl_hash}
        else
            echo "git server fingerprint is not '${git_server_fingerprint} ${git_server} (RSA)', but instead:  `ssh-keygen -lf ${git_server}_gitkey`"
            cd ${prev_wd}
            exit 1
        fi
    fi
    cd ${prev_wd}
}

function install_unique_virtenv()
{
    echo ""
    echo "install_unique_virtenv()"
    
    local uuid="$1"
    local export_proxy_str="$2"
    
    eval ${export_proxy_str}
    echo "deactivate"
    deactivate
    echo "pip install virtualenvwrapper --user --ignore-installed"
    pip install virtualenvwrapper --user --ignore-installed
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

function queue_status_update()
{
    echo ""
    echo "queue_status_update()"

    local data_dir="$1"
    local cwl_tool="$2"
    local s3cfg_path="$3"
    local db_cred_s3url="$4"
    local git_cwl_repo="$5"
    local git_cwl_hash="$6"
    local case_id="$7"
    local bam_url_array="$8"
    local status="$9"
    local table_name="${10}"
    local s3_out_bucket="${11}"

    echo "status=${status}"
    echo "table_name=${table_name}"
    
    get_git_name "${git_cwl_repo}"
    echo "git_name=${git_name}"
    local cwl_dir=${data_dir}/${git_name}
    local cwl_tool_path=${cwl_dir}/${cwl_tool}


    local this_virtenv_dir=${HOME}/.virtualenvs/p2_${case_id}
    local cwlrunner_path=${this_virtenv_dir}/bin/cwltool
    for bam_url in ${bam_url_array}
    do
        local gdc_id=$(basename $(dirname ${bam_url}))
        local cwl_command="--debug --outdir ${data_dir} ${cwl_tool_path} --case_id ${case_id} --db_cred_s3url ${db_cred_s3url} --gdc_id ${gdc_id} --repo ${git_cwl_repo} --repo_hash ${git_cwl_hash} --s3cfg_path ${s3cfg_path} --table_name ${table_name} --status ${status}"
        echo "${cwlrunner_path} ${cwl_command}"
        ${cwlrunner_path} ${cwl_command}
    done
}


function get_case_id()
{
    echo ""
    echo "get_case_id()"

    coclean_script="${1}"

    local case_id_line=`grep "CASE_ID=" ${coclean_script}`
    local case_id_string=`echo ${case_id_line} | sed 's/CASE_ID=//'` # | sed 's/"//g'
    case_id=${case_id_string}
}

function get_bam_url_array()
{
    echo ""
    echo "get_bam_url_array()"

    coclean_script="${1}"

    local bam_url_array_line=`grep "BAM_URL_ARRAY=" ${coclean_script}`
    local bam_url_array_string=`echo ${bam_url_array_line} | sed 's/CASE_ID=//'` #  | sed 's/"//g'
    bam_url_array=${bam_url_array_string}
}

function main()
{
    local repo="${}"
    local repo_hash="${}"
    local s3cfg_path="${}"
    local s3_url="${}"
    local status="QUEUED"
    local table_name="coclean_caseid_queue"
    local db_cred_s3url="${}"

    
    local uuid=$(uuidgen)
    if [ $? -ne 0 ]
    then
        print('`uuidgen` is not present')
        exit 1
    fi
    
    local data_dir="${HOME}/queue_${uuid}"
    mkdir -p ${data_dir}
    
   
    setup_deploy_key "${S3_CFG_PATH}" "${GIT_CWL_DEPLOY_KEY_S3_URL}" "${data_dir}"
    clone_git_repo "${GIT_CWL_SERVER}" "${GIT_CWL_SERVER_FINGERPRINT}" "${GIT_CWL_REPO}" "${EXPORT_PROXY_STR}" "${data_dir}" "${GIT_CWL_HASH}"
    install_unique_virtenv "${uuid}" "${EXPORT_PROXY_STR}"
    pip_install_requirements "${GIT_CWL_REPO}" "${CWLTOOL_REQUIREMENTS_PATH}" "${EXPORT_PROXY_STR}" "${data_dir}" "${uuid}"
    clone_pip_git_hash "${uuid}" "${CWLTOOL_URL}" "${CWLTOOL_HASH}" "${data_dir}" "${EXPORT_PROXY_STR}"

    
    for f in script_dir/coclean_*.sh
    do
        get_case_id "${f}"
        get_bam_url_array "${f}"
        echo ""
        echo "case_id=${case_id}"
        echo "bam_url_array=${bam_url_array}"
        queue_status_update "${data_dir}" "${QUEUE_STATUS_TOOL}" "${S3_CFG_PATH}" "${DB_CRED_URL}" "${GIT_CWL_REPO}" "${GIT_CWL_HASH}" "${case_id}" "${bam_url_array}" "QUEUED" "test_coclean_caseid_queue_test"
        sbatch ${f}
    done
    remove_data ${data_dir} ${uuid}

}


main "$@"
