#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=${xx_scratch_dir_xx}
#SBATCH --cpus-per-task=${xx_slurm_reseource_cores_xx}
#SBATCH --mem=${xx_slurm_resource_mem_megabytes_xx}
#SBATCH --gres=SCRATCH:${xx_slurm_resource_disk_gigabytes_xx}

##ENV VARIABLE
SCRATCH_DIR=${xx_scratch_dir_xx}
VIRTUALENV_NAME=${xx_virtualenv_name_xx}

##JOB VARIABLE
CWL_JOB_PATH=${xx_runner_job_cwl_uri_xx}
CWL_RUNNER_PATH=${xx_runner_cwl_uri_xx}
INPUT_GDC_ID=${xx_input_bam_gdc_id_xx}

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
