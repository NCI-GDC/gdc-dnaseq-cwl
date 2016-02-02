#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --workdir=/mnt/scratch/

SCRATCH_DIR="/mnt/scratch"
BAM_URL_ARRAY="XX_BAM_URL_ARRAY_XX"
CASE_ID="XX_CASE_ID_XX"
THREAD_COUNT=XX_THREAD_COUNT_XX
S3_CFG=${HOME}/.s3cfg.cleversafe
GIT_CWL_SERVER="github.com"
GIT_CWL_SERVER_FINGERPRINT="16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48"
GIT_CWL_DEPLOY_KEY="s3://bioinformatics_scratch/deploy_key/coclean_cwl_deploy_rsa"
GIT_CWL_REPO=" -b slurm_script git@github.com:NCI-GDC/cocleaning-cwl.git"
EXPORT_PROXY_STR="export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128;"

#bam_url_array="$@"
bam_url_array=${BAM_URL_ARRAY}
echo ${bam_url_array}

#index file names
KNOWN_INDEL_VCF="Homo_sapiens_assembly38.known_indels.vcf.gz"
KNOWN_SNP_VCF="dbsnp_144.hg38.vcf.gz"
REFERENCE_GENOME="GRCh38.d1.vd1"
S3_INDEX_BUCKET="s3://bioinformatics_scratch/coclean"
S3_OUT_BUCKET="s3://tcga_exome_blca_coclean"
S3_LOG_BUCKET="s3://tcga_exome_blca_coclean_log"

DATA_DIR="${SCRATCH_DIR}/data_"${CASE_ID}
INDEX_DIR="${DATA_DIR}/index"
COCLEAN_DIR="${DATA_DIR}/coclean"
COCLEAN_WORKFLOW_PATH="${COCLEAN_DIR}/cocleaning-cwl/workflows/coclean/coclean_workflow.cwl.yaml"
BUILDBAMINDEX_TOOL_PATH="${COCLEAN_DIR}/cocleaning-cwl/tools/picard_buildbamindex.cwl.yaml"
CWL_RUNNER=${HOME}/.virtualenvs/p2_${CASE_ID}/bin/cwltool
CWL_RUNNER_TMPDIR_PREFIX="XX_TMPDIR_PREFIX_XX"
THIS_VIRTENV_DIR=${HOME}/.virtualenvs/p2_${CASE_ID}

function install_virtenv()
{
    uuid=$1
    export_proxy_str=$2
    eval ${export_proxy_str}
    pip install virtualenvwrapper --user
    source ${HOME}/.local/bin/virtualenvwrapper.sh
    mkvirtualenv --python /usr/bin/python2 p2_${uuid}
    this_virtenv_dir=${HOME}/.virtualenvs/p2_${uuid}
    source ${this_virtenv_dir}/bin/activate
    pip install --upgrade pip
}

function pip_install_requirements()
{
    requirements_path=$1
    export_proxy_str=$2
    eval ${export_proxy_str}
    pip install -r ${requirements_path}
}

function setup_deploy_key()
{
    s3_cfg_path=$1
    s3_deploy_key_url=$2
    store_dir=$3
    prev_wd=`pwd`
    key_name=$(basename ${s3_deploy_key_url})
    cd ${store_dir}
    eval `ssh-agent`
    s3cmd -c ${s3_cfg_path} get ${s3_deploy_key_url}
    ssh-add ${key_name}
    cd ${prev_wd}
}

function clone_git_repo()
{
    git_server=$1
    git_server_fingerprint=$2
    git_repo=$3
    export_proxy_str=$4
    clone_dir=$5
    prev_wd=`pwd`
    eval ${export_proxy_str}
    cd ${clone_dir}
    #check if key is in known hosts
    ssh-keygen -H -F ${git_server} | grep "Host ${git_server} found: line 1 type RSA" -
    if [ $? -q 0 ]
    then
        git clone ${git_repo}
    else # if not known, get key, check it, then add it
        ssh-keyscan ${git_server} > ${git_server}_gitkey
        echo `ssh-keygen -lf gitkey` | grep ${git_server_fingerprint}
        if [ $? -q 0 ]
        then
            cat ${git_server}_gitkey >> ${HOME}/.ssh/known_hosts
            git clone ${git_repo}
        else
            echo "git server fingerprint is not ${git_server_fingerprint}, but instead:  `ssh-keygen -lf ${git_server}_gitkey`"
            exit 1
        fi
    fi
    cd ${prev_wd}
}

echo "setup deploy key"
setup_deploy_key ${S3_CFG_PATH} ${S3_DEPLOY_KEY_URL} ${DATA_DIR}
echo "get cwl"
clone_git_repo ${GIT_SERVER} ${GIT_SERVER_FINGERPRINT} ${GIT_CWL_REPO} ${EXPORT_PROXY_STR} ${DATA_DIR}

#always install virtenv on every job, remove at cleanup
echo "install virtenv"
install_virtenv ${CASE_ID} ${EXPORT_PROXY}
echo "install cwltool"
pip_install_requirments ${


#make index dir
mkdir -p ${INDEX_DIR}
cd ${INDEX_DIR}


# get index files, if needed
s3cmd -c ${S3_CFG} --skip-existing get ${S3_INDEX_BUCKET}/${REFERENCE_GENOME}.dict
s3cmd -c ${S3_CFG} --skip-existing get ${S3_INDEX_BUCKET}/${REFERENCE_GENOME}.fa
s3cmd -c ${S3_CFG} --skip-existing get ${S3_INDEX_BUCKET}/${REFERENCE_GENOME}.fa.fai
s3cmd -c ${S3_CFG} --skip-existing get ${S3_INDEX_BUCKET}/${KNOWN_SNP_VCF}
s3cmd -c ${S3_CFG} --skip-existing get ${S3_INDEX_BUCKET}/${KNOWN_SNP_VCF}.tbi
s3cmd -c ${S3_CFG} --skip-existing get ${S3_INDEX_BUCKET}/${KNOWN_INDEL_VCF}
s3cmd -c ${S3_CFG} --skip-existing get ${S3_INDEX_BUCKET}/${KNOWN_INDEL_VCF}.tbi


#make BAM dir
mkdir -p ${DATA_DIR}


# get BAM files
cd ${DATA_DIR}
for bam_url in ${bam_url_array}
do
    s3cmd -c ${S3_CFG} --force get ${bam_url}
done


# index BAM files. remove `--leave-tmpdir` on production
cd ${DATA_DIR}
for bam_url in ${bam_url_array}
do
    bam_name=$(basename ${bam_url})
    bam_path=${DATA_DIR}/${bam_name}
    CWL_COMMAND="--debug --outdir ${DATA_DIR} ${BUILDBAMINDEX_TOOL_PATH} --uuid ${CASE_ID} --input_bam ${bam_path}"
    ${CWL_RUNNER} ${CWL_COMMAND}
done


# setup run dir
mkdir -p ${COCLEAN_DIR}


# setup cwl command removed  --leave-tmpdir
CWL_COMMAND="--debug --outdir ${COCLEAN_DIR} ${COCLEAN_WORKFLOW_PATH} --reference_fasta_path ${INDEX_DIR}/${REFERENCE_GENOME}.fa --uuid ${CASE_ID} --known_indel_vcf_path ${INDEX_DIR}/${KNOWN_INDEL_VCF} --known_snp_vcf_path ${INDEX_DIR}/${KNOWN_SNP_VCF} --thread_count ${THREAD_COUNT}"
for bam_url in ${bam_url_array}
do
    bam_name=$(basename ${bam_url})
    bam_path=${DATA_DIR}/${bam_name}
    bam_paths="${bam_paths} --bam_path ${bam_path}"
done
CWL_COMMAND="${CWL_COMMAND} ${bam_paths}"



# run cwl
cd ${COCLEAN_DIR}
echo "calling:
${HOME}/.virtualenvs/p2/bin/cwltool ${CWL_COMMAND}"
${HOME}/.virtualenvs/p2/bin/cwltool ${CWL_COMMAND}


# upload results
for bam_url in ${bam_url_array}
do
    gdc_id=$(basename $(dirname ${bam_url}))
    bam_file=$(basename ${bam_url})
    bam_base="${bam_file%.*}"
    bai_file="${bam_base}.bai"
    bam_path=${COCLEAN_DIR}/${bam_file}
    bai_path=${COCLEAN_DIR}/${bai_file}
    echo "uploading: s3cmd -c ${S3_CFG} put ${bai_path} ${S3_OUT_BUCKET}/${gdc_id}/"
    s3cmd -c ${S3_CFG} put ${bai_path} ${S3_OUT_BUCKET}/${gdc_id}/
    echo "uploading: s3cmd -c ${S3_CFG} put ${bam_path} ${S3_OUT_BUCKET}/${gdc_id}/"
    s3cmd -c ${S3_CFG} put ${bam_path} ${S3_OUT_BUCKET}/${gdc_id}/
done
s3cmd -c ${S3_CFG} put ${COCLEAN_DIR}/${CASE_ID}.db ${S3_LOG_BUCKET}/

#cleanup
rm -rf ${DATA_DIR}
rm -rf ${THIS_VIRTENV_DIR}
