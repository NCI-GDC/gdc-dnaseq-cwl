#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=${xx_scratch_dir_xx}
#SBATCH --cpus-per-task=${xx_slurm_resource_cores_xx}
#SBATCH --mem=${xx_slurm_resource_mem_megabytes_xx}
#SBATCH --gres=SCRATCH:${xx_slurm_resource_disk_gigabytes_xx}

##ENV VARIABLE
SCRATCH_DIR=${xx_scratch_dir_xx}

##JOB VARIABLE
JOB_UUID=${xx_job_uuid_xx}
CWL_WORKFLOW_GIT_REPO=${xx_cwl_workflow_git_repo_xx}
CWL_WORKFLOW_GIT_HASH=${xx_cwl_workflow_git_hash_xx}
CWL_WORKFLOW_REL_PATH=${xx_cwl_workflow_rel_path_xx}
CWL_JOB_GIT_REPO=${xx_cwl_job_git_repo_xx}
CWL_JOB_GIT_BRANCH=${xx_cwl_workflow_git_branch_xx}
CWL_JOB_REL_PATH=${xx_cwl_job_rel_path_xx}
CLONE_JOB_DIR=repos/job
CLONE_WORKFLOW_DIR=repos/workflow


function activate_virtualenv()
{
    local virtualenv_name=${1}

    source /usr/local/bin/virtualenvwrapper.sh
    source ${HOME}/.virtualenvs/${virtualenv_name}/bin/activate
}

function git_clone()
{
    local clone_dir=${1}
    local git_branch=${2}
    local git_repo=${3}

    local repo=$(basename ${git_repo})
    local repo_dir=${clone_dir}/"${repo%.*}"
    local prev_dir=$(pwd)

    cd ${clone_dir}
    git clone ${git_repo}
    cd ${repo_dir}
    git checkout ${git_branch}
    cd ${prev_dir}
}

function runner()
{
    local job_path=${1}
    local workflow_path=${2}

    java -jar rabix-cli-1.0.1/lib/rabix-cli.jar ${workflow_path} ${job_path}
}

function main()
{
    local cwl_workflow_git_repo=${CWL_WORKFLOW_GIT_REPO}
    local cwl_workflow_git_hash=${CWL_WORKFLOW_GIT_HASH}
    local cwl_workflow_rel_path=${CWL_WORKFLOW_REL_PATH}
    local cwl_job_git_repo=${CWL_JOB_GIT_REPO}
    local cwl_job_git_branch=${CWL_JOB_GIT_BRANCH}
    local cwl_job_rel_path=${CWL_JOB_REL_PATH}
    local job_uuid=${JOB_UUID}
    local scratch_dir=${SCRATCH_DIR}

    local job_dir=${scratch_dir}/${job_uuid}/
    local clone_job_dir=${job_dir}/${CLONE_JOB_DIR}
    local clone_workflow_dir=${job_dir}/${CLONE_WORKFLOW_DIR}
    local job_path=${clone_job_dir}/${cwl_job_rel_path}
    local workflow_path=${clone_workflow_dir}/${cwl_workflow_rel_path}

    git_clone ${clone_workflow_dir}  ${cwl_workflow_git_repo} ${cwl_workflow_git_hash}
    get_job ${clone_job_dir} ${cwl_job_git_repo} ${cwl_job_git_branch}
    runner ${job_dir} ${job_path} ${workflow_path}
    if [ $? -ne 0 ]
    then
        echo FAIL_RUNNER
        rm -rf ${job_dir}
        exit 1
    fi
    rm -rf ${job_dir}
    
}

main "$@"
