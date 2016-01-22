#!/bin/bash
###SBATCH --nodes=1
###SBATCH --ntasks=1

bam_url_array=("$@")
echo ${bam_url_array}
KNOWN_INDEL_VCF="Homo_sapiens_assembly38.known_indels.vcf"
KNOWN_SNP_VCF="Homo_sapiens_assembly38.dbsnp138.vcf"
REFERENCE_GENOME="GRCh38.d1.vd1"
THREAD_COUNT=8
CWL_PATH="${HOME}/cocleaning-cwl/workflows/coclean/coclean_workflow.cwl.yaml"
S3_INDEX_BUCKET="s3://bioinformatics_scratch/coclean"

cd ${HOME}

#make index dir
INDEX_DIR="/mnt/SCRATCH/coclean_index"
mkdir -p ${INDEX_DIR}
cd ${INDEX_DIR}


# get index files, if needed
s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${S3_INDEX_BUCKET}/${REFERENCE_GENOME}.dict
s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${S3_INDEX_BUCKET}/${REFERENCE_GENOME}.fa
s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${S3_INDEX_BUCKET}/${REFERENCE_GENOME}.fa.fai
s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${S3_INDEX_BUCKET}/${KNOWN_SNP_VCF}
s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${S3_INDEX_BUCKET}/${KNOWN_SNP_VCF}.idx
s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${S3_INDEX_BUCKET}/${KNOWN_INDEL_VCF}
s3cmd -c ~/.s3cfg.cleversafe --skip-existing get ${S3_INDEX_BUCKET}/${KNOWN_INDEL_VCF}.idx


#make BAM dir
NEW_UUID=$(cat /dev/urandom | tr -dc 'A-Z0-9' | fold -w 32 | head -n1)
DATA_DIR="/mnt/SCRATCH/data_"${NEW_UUID}
echo "DATA_DIR=${DATA_DIR}"
mkdir -p ${DATA_DIR}


# get BAM files
cd ${DATA_DIR}
for bam_url in ${bam_url_array}
do
    s3cmd -c ~/.s3cfg.cleversafe get ${bam_url}
done


# setup run dir
COCLEAN_DIR=${DATA_DIR}/coclean
mkdir -p ${COCLEAN_DIR}


# setup cwl command
CWL_COMMAND="cwltool --debug --leave-tmpdir --outdir ${COCLEAN_DIR} ${CWL_PATH} --reference_fasta_path ${INDEX_DIR}/${REFERENCE_GENOME}.fa --uuid ${UUID} --known_indel_vcf_path ${INDEX_DIR}/${KNOWN_INDEL_VCF} --known_snp_vcf_path ${INDEX_DIR}/${KNOWN_SNP_VCF}  --thread_count ${THREAD_COUNT}"
for bam_url in ${bam_url_array}
do
    bam_name=$(basename ${bam_url})
    bam_path=${DATA_DIR}/${bam_name}
    CWL_COMMAND="${CWL_COMMAND} --bam_path ${bam_path}"
done

cd ${HOME}

# run cwl
workon p2
echo "cwltool ${CWL_COMMAND}"


# upload results
#TODO
