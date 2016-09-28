#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=XX_SCRATCH_DIR_XX
#SBATCH --cpus-per-task=XX_THREAD_COUNT_XX
#SBATCH --mem=18000

##ENV VARIABLE
SCRATCH_DIR=XX_SCRATCH_DIR_XX
CACHE_DIR=${SCRATCH_DIR}/cache/cache
TMP_DIR=${SCRATCH_DIR}/tmp/tmp
VIRTUALENV_NAME=jhs_cwl

##JOB VARIABLE
CWL_PATH=${HOME}/cocleaning-cwl/workflows/dnaseq/runner.cwl
JSON_PATH=${HOME}/runner_json/ex_runner.json
UUID=XX_UUID_XX

function activate_virtualenv()
{
    local virtualenv_name=${1}

    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
    source ${HOME}/.virtualenvs/${virtualenv_name}/bin/activate
}

function runner()
{
    local cache_dir=${1}
    local cwl_path=${2}
    local job_dir=${3}
    local json_path=${4}
    local tmp_dir=${5}

    echo cwltool --debug --cachedir ${cache_dir} --tmpdir-prefix ${tmp_dir} --enable-net --custom-net host --outdir ${job_dir} ${cwl_path} ${json_path}
    cwltool --debug --cachedir ${cache_dir} --tmpdir-prefix ${tmp_dir} --enable-net --custom-net host --outdir ${job_dir} ${cwl_path} ${json_path}
}

function main()
{
    local cwl_path=${CWL_PATH}
    local json_path=${JSON_PATH}
    local scratch_dir=${SCRATCH_DIR}
    local uuid=${UUID}
    local virtualenv_name=${VIRTUALENV_NAME}
    local cache_dir=${scratch_dir}/${uuid}/cache
    local job_dir=${scratch_dir}/${uuid}/
    local tmp_dir=${scratch_dir}/${uuid}/tmp

    mkdir -p ${cache_dir}
    mkdir -p ${job_dir}
    mkdir -p ${tmp_dir}

    activate_virtualenv ${virtualenv_name}

    runner ${cache_dir} ${cwl_path} ${job_dir} ${json_path} ${tmp_dir}
    if [ $? -ne 0 ]
    then
        echo FAIL
    fi

    #rm -rf ${job_dir}
}

main "$@"
