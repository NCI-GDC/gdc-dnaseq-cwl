#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1

#BAM_URL_ARRAY_STRING

bam_url_array="$@"
echo ${bam_url_array}
KNOWN_INDEL_VCF="Homo_sapiens_assembly38.known_indels.vcf.gz"
KNOWN_SNP_VCF="dbsnp_144.hg38.vcf.gz"
REFERENCE_GENOME="GRCh38.d1.vd1"
THREAD_COUNT=8
COCLEAN_WORKFLOW_PATH="${HOME}/cocleaning-cwl/workflows/coclean/coclean_workflow.cwl.yaml"
BUILDBAMINDEX_TOOL_PATH="${HOME}/cocleaning-cwl/tools/picard_buildbamindex.cwl.yaml"
S3_INDEX_BUCKET="s3://bioinformatics_scratch/coclean"
S3_OUT_BUCKET="s3://tcga_exome_blca_coclean"
UUID="atestuuid"

function install_virtenv()
{
    export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128;
    pip install virtualenvwrapper --user
    echo "source ${HOME}/.local/bin/virtualenvwrapper.sh" >> ~/.bashrc
    source ${HOME}/.local/bin/virtualenvwrapper.sh
    mkvirtualenv --python /usr/bin/python2 p2
}

function install_cwltool()
{
    export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128;
    workon p2
    pip install cwltool
}


#make index dir
INDEX_DIR="/mnt/SCRATCH/coclean_index"
mkdir -p ${INDEX_DIR}
cd ${INDEX_DIR}


# get index files, if needed
s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${S3_INDEX_BUCKET}/${REFERENCE_GENOME}.dict
s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${S3_INDEX_BUCKET}/${REFERENCE_GENOME}.fa
s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${S3_INDEX_BUCKET}/${REFERENCE_GENOME}.fa.fai
s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${S3_INDEX_BUCKET}/${KNOWN_SNP_VCF}
s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${S3_INDEX_BUCKET}/${KNOWN_SNP_VCF}.tbi
s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${S3_INDEX_BUCKET}/${KNOWN_INDEL_VCF}
s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${S3_INDEX_BUCKET}/${KNOWN_INDEL_VCF}.tbi


#make BAM dir
NEW_UUID=$(cat /dev/urandom | tr -dc 'A-Z0-9' | fold -w 32 | head -n1)
DATA_DIR="/mnt/SCRATCH/data_"${NEW_UUID}
DATA_DIR="/mnt/SCRATCH/data_TDOUNHI5AWD473MMGES5H5F6JHJ6BJLA"
echo "DATA_DIR=${DATA_DIR}"
mkdir -p ${DATA_DIR}


# get BAM files
cd ${DATA_DIR}
for bam_url in ${bam_url_array}
do
    s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${bam_url}
done


# index BAM files
cd ${DATA_DIR}
for bam_url in ${bam_url_array}
do
    bam_name=$(basename ${bam_url})
    bam_path=${DATA_DIR}/${bam_name}
    CWL_COMMAND="--debug --leave-tmpdir --outdir ${DATA_DIR} ${BUILDBAMINDEX_TOOL_PATH} --uuid ${UUID} --input_bam ${bam_path}"
    ${HOME}/.virtualenvs/p2/bin/cwltool ${CWL_COMMAND}
done


# setup run dir
COCLEAN_DIR=${DATA_DIR}/coclean
mkdir -p ${COCLEAN_DIR}

# setup cwl command
CWL_COMMAND="--debug --leave-tmpdir --outdir ${COCLEAN_DIR} ${COCLEAN_WORKFLOW_PATH} --reference_fasta_path ${INDEX_DIR}/${REFERENCE_GENOME}.fa --uuid ${UUID} --known_indel_vcf_path ${INDEX_DIR}/${KNOWN_INDEL_VCF} --known_snp_vcf_path ${INDEX_DIR}/${KNOWN_SNP_VCF} --thread_count ${THREAD_COUNT}"
for bam_url in ${bam_url_array}
do
    bam_name=$(basename ${bam_url})
    bam_path=${DATA_DIR}/${bam_name}
    bam_paths="${bam_paths} --bam_path ${bam_path}"
done
CWL_COMMAND="${CWL_COMMAND} ${bam_paths}"

cd ${COCLEAN_DIR}

# run cwl
if [ ! -f ${HOME}/.virtualenvs/p2/bin/cwltool ]; then
    echo "install virtenv"
    install_virtenv
    echo "install cwltool"
    install_cwltool
fi
source ${HOME}/.virtualenvs/p2/bin/activate
echo "calling:
${HOME}/.virtualenvs/p2/bin/cwltool ${CWL_COMMAND}"
${HOME}/.virtualenvs/p2/bin/cwltool ${CWL_COMMAND}


# upload results
for bam_url in ${bam_url_array}
do
    gdc_id=$(basename $(dirname ${bam_url}))
    bam_file=$(basename ${bam_url})
    bam_path=${COCLEAN_DIR}/${bam_file}
    echo "uploading: s3cmd -c ~/.s3cfg.cleversafe put ${bam_path} ${S3_OUT_BUCKET}/${gdc_id}/"
    s3cmd -c ~/.s3cfg.cleversafe put ${bam_path} ${S3_OUT_BUCKET}/${gdc_id}/
done
