#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=${xx_scratch_dir_xx}
#SBATCH --cpus-per-task=${xx_slurm_resource_cores_xx}
#SBATCH --mem=${xx_slurm_resource_mem_megabytes_xx}
#SBATCH --gres=SCRATCH:${xx_slurm_resource_disk_gigabytes_xx}

##ENV VARIABLE
SCRATCH_DIR=${xx_scratch_dir_xx}
VIRTUALENV_NAME=${xx_virtualenv_name_xx}

##JOB VARIABLE
CWL_RUNNER_JOB_URL=${xx_cwl_runner_job_url_xx}
CWL_RUNNER_URL=${xx_cwl_runner_url_xx}
JOB_UUID=${xx_job_uuid_xx}

function activate_virtualenv()
{
    local virtualenv_name=${1}

    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
    source ${HOME}/.virtualenvs/${virtualenv_name}/bin/activate
}

function runner()
{
    local cwl_job_url=${1}
    local cwl_runner_url=${2}
    local job_dir=${3}

    local cache_dir=${job_dir}/cache
    local tmp_dir=${job_dir}/job
    mkdir -p ${cache_dir}
    mkdir -p ${job_dir}
    mkdir -p ${tmp_dir}

    export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128;
    cwltool --debug --rm-tmpdir --rm-container --tmp-outdir-prefix ${cache_dir} --tmpdir-prefix ${tmp_dir} --custom-net bridge --outdir ${job_dir} ${cwl_runner_url} ${cwl_job_url}
}

function main()
{
    local cwl_runner_job_url=${CWL_RUNNER_JOB_URL}
    local cwl_runner_url=${CWL_RUNNER_URL}
    local job_uuid=${JOB_UUID}
    local scratch_dir=${SCRATCH_DIR}
    local virtualenv_name=${VIRTUALENV_NAME}

    local job_dir=${scratch_dir}/${job_uuid}/

    activate_virtualenv ${virtualenv_name}
    runner ${cwl_runner_job_url} ${cwl_runner_url} ${job_dir}
    if [ $? -ne 0 ]
    then
        echo FAIL_RUNNER
        rm -rf ${job_dir}
        exit 1
    fi
    rm -rf ${job_dir}
}

main "$@"
