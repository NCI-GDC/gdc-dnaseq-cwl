#!/bin/bash

function to_db()
{
    local s3_url="${1}"
    local zip_file=$(basename ${s3_url})
    local uuid=$(echo "$s3_url" | cut -d "/" -f2)
    aws --recursive --endpoint-url http://gdc-accessor1.osdc.io s3 cp ${s3_url} .
    cwltool ~/cocleaning-cwl/tools/fastqc_db.cwl.yaml --fastqc_zip_path ${zip_file} --uuid ${uuid}
    rm ${zip_file}
}


function main()
{
    aws --endpoint-url http://gdc-accessor1.osdc.io s3 ls s3://tcga_rnaseq_alignment_meta_3/ > rnaseq_ids.txt
    rnaseq_ids=(`cat rnaseq_ids.txt | awk '{ print $2}'`)
    for i in "${rnaseq_ids[@]}"
    do
        aws_zip=`aws --recursive --endpoint-url http://gdc-accessor1.osdc.io s3 ls s3://tcga_rnaseq_alignment_meta_3/${i} | grep -i fastq | grep -i zip`
        for result in "${aws_zip[@]}"
        do
            grep zip ${result}
            if [$? -eq 0]
            then
                to_db() "${result}"
            fi
        done
    done
}

main "$@"
