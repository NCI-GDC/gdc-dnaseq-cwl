#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=XX_SCRATCH_DIR_XX
#SBATCH --cpus-per-task=XX_RESOURCE_CORE_COUNT_XX
#SBATCH --mem=XX_RESOURCE_MEMORY_MEGABYTES_XX
#SBATCH --gres=SCRATCH:XX_RESOURCE_DISK_GIGABYTES_XX

##ENV VARIABLE
SCRATCH_DIR=XX_SCRATCH_DIR_XX
VIRTUALENV_NAME=XX_VIRTUALENV_NAME_XX

##JOB VARIABLE
CWL_JOB_PATH=XX_CWL_JOB_PATH_XX
CWL_RUNNER_PATH=XX_CWL_RUNNER_PATH_XX
INPUT_GDC_ID=XX_INPUT_GDC_ID_XX

function activate_virtualenv()
{
    local virtualenv_name=${1}

    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
    source ${HOME}/.virtualenvs/${virtualenv_name}/bin/activate
}

function runner()
{
    local cwl_job_path=${1}
    local cwl_runner_path=${2}
    local job_dir=${3}

    local cache_dir=${job_dir}/cache
    local tmp_dir=${job_dir}/job
    mkdir -p ${cache_dir}
    mkdir -p ${job_dir}
    mkdir -p ${tmp_dir}

    export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128;
    cwltool --debug --rm-tmpdir --rm-container --tmp-outdir-prefix ${cache_dir} --tmpdir-prefix ${tmp_dir} --custom-net bridge --outdir ${job_dir} ${cwl_runner_path} ${cwl_job_path}
}

function main()
{
    local cwl_job_path=${CWL_JOB_PATH}
    local cwl_runner_path=${CWL_RUNNER_PATH}
    local input_gdc_id=${INPUT_GDC_ID}
    local scratch_dir=${SCRATCH_DIR}
    local virtualenv_name=${VIRTUALENV_NAME}

    local job_dir=${scratch_dir}/${input_gdc_id}/

    activate_virtualenv ${virtualenv_name}
    runner ${cwl_job_path} ${cwl_runner_path} ${job_dir}
    if [ $? -ne 0 ]
    then
        echo FAIL_RUNNER
        rm -rf ${job_dir}
        exit 1
    fi
    rm -rf ${job_dir}
}

main "$@"
