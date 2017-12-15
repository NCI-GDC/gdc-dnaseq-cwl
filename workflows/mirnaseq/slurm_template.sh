#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=${xx_scratch_dir_xx}
#SBATCH --cpus-per-task=${xx_slurm_resource_cores_xx}
#SBATCH --mem=${xx_slurm_resource_mem_megabytes_xx}
#SBATCH --gres=SCRATCH:${xx_slurm_resource_disk_gigabytes_xx}

CWL_WORKFLOW_GIT_REPO=${xx_cwl_workflow_git_repo_xx}
CWL_WORKFLOW_GIT_HASH=${xx_cwl_workflow_git_hash_xx}
CWL_WORKFLOW_REL_PATH=${xx_cwl_workflow_rel_path_xx}
CWL_TASK_GIT_REPO=${xx_cwl_task_git_repo_xx}
CWL_TASK_GIT_HASH=${xx_cwl_task_git_hash_xx}
CWL_TASK_REL_PATH=${xx_cwl_task_rel_path_xx}
SCRATCH_DIR=${xx_scratch_dir_xx}
TASK_UUID=${xx_task_uuid_xx}
VIRTUALENV_NAME=${xx_virtualenv_name_xx}
TASK_DIR=repo/task
WORKFLOW_DIR=repo/workflow

function activate_virtualenv()
{
    local virtualenv_name=${1}

    source /usr/local/bin/virtualenvwrapper.sh
    source ${HOME}/.virtualenvs/${virtualenv_name}/bin/activate
}

function git_fetch_commit()
{
    local clone_dir=${1}
    local git_commit=${2}
    local git_repo=${3}

    IFS=':' read -ra git_repo_array <<< ${git_repo}
    local proj_repo=${git_repo_array[-1]}
    local repo=$(basename ${proj_repo})
    local repo_dir=${clone_dir}/${repo}
    local prev_dir=$(pwd)

    echo clone_dir=${clone_dir}
    echo git_commit=${git_commit}
    echo git_repo=${git_repo}
    echo proj_repo=${proj_repo}
    echo repo=${repo}
    echo repo_dir=${repo_dir}
    echo prev_dir=${prev_dir}

    mkdir -p ${repo_dir}
    cd ${repo_dir}
    echo git init
    git init
    echo git remote add origin ${git_repo}
    git remote add origin ${git_repo}
    echo eval "$(ssh-agent -s)" && ssh-add ${HOME}/.ssh/slurm_id_rsa && git fetch --depth 1 origin ${git_commit}
    eval "$(ssh-agent -s)" && ssh-add ${HOME}/.ssh/slurm_id_rsa && git fetch --depth 1 origin ${git_commit}
    echo git checkout FETCH_HEAD
    git checkout FETCH_HEAD
    cd ${prev_dir}
}

function runner()
{
    local task_path=${1}
    local workflow_path=${2}
    local work_dir=${3}

    local cache_dir=${work_dir}/cache
    local tmp_dir=${work_dir}/tmp

    echo mkdir ${cache_dir}
    mkdir ${cache_dir}
    echo mkdir ${tmp_dir}
    mkdir ${tmp_dir}

    echo cwltool --debug --rm-tmpdir --rm-container --no-read-only --no-match-user --tmp-outdir-prefix ${cache_dir}/ --tmpdir-prefix ${tmp_dir}/ --custom-net bridge --outdir ${work_dir} ${workflow_path} ${task_path}
    cwltool --debug --rm-tmpdir --rm-container --no-read-only --no-match-user --tmp-outdir-prefix ${cache_dir}/ --tmpdir-prefix ${tmp_dir}/ --custom-net bridge --outdir ${work_dir} ${workflow_path} ${task_path}
}

function main()
{
    local cwl_workflow_git_repo=${CWL_WORKFLOW_GIT_REPO}
    local cwl_workflow_git_hash=${CWL_WORKFLOW_GIT_HASH}
    local cwl_workflow_rel_path=${CWL_WORKFLOW_REL_PATH}
    local cwl_task_git_repo=${CWL_TASK_GIT_REPO}
    local cwl_task_git_hash=${CWL_TASK_GIT_HASH}
    local cwl_task_rel_path=${CWL_TASK_REL_PATH}
    local task_uuid=${TASK_UUID}
    local scratch_dir=${SCRATCH_DIR}
    local virtualenv_name=${VIRTUALENV_NAME}

    local work_dir=${scratch_dir}/${task_uuid}
    local workflow_dir=${work_dir}/${WORKFLOW_DIR}
    local workflow_path=${workflow_dir}/${cwl_workflow_rel_path}
    local task_dir=${work_dir}/${TASK_DIR}
    local task_path=${task_dir}/${cwl_task_rel_path}

    mkdir -p ${workflow_dir}
    mkdir -p ${task_dir}

    git_fetch_commit ${workflow_dir} ${cwl_workflow_git_hash} ${cwl_workflow_git_repo}
    git_fetch_commit ${task_dir} ${cwl_task_git_hash} ${cwl_task_git_repo}
    sed -i "s/${cwl_task_git_hash}/${xx_cwl_task_git_hash_xx}/" ${task_path}
    activate_virtualenv ${virtualenv_name}
    runner ${task_path} ${workflow_path} ${work_dir}
    if [ $? -ne 0 ]
    then
        echo FAIL_RUNNER
        sudo rm -rf ${work_dir}
        exit 1
    fi
    sudo rm -rf ${work_dir}
}

main "$@"
