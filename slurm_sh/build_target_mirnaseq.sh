#!/bin/bash

function to_db()
{
    local s3_url="${1}"
    echo "s3_url=${s3_url}"
    local zip_file=$(basename ${s3_url})
    local uuid=$(echo "${s3_url}" | cut -d "/" -f1)
    aws --endpoint-url http://gdc-accessor1.osdc.io s3 cp s3://target_mirnaseq_alignment_meta_3/${s3_url} .
    cwltool ~/cocleaning-cwl/tools/fastqc_db.cwl.yaml --fastqc_zip_path ${zip_file} --uuid ${uuid}
    rm ${zip_file}
}


function main()
{
    aws --endpoint-url http://gdc-accessor1.osdc.io s3 ls s3://target_mirnaseq_alignment_meta_3/ > target_mirnaseq_ids.txt
    rnaseq_ids=(`cat target_mirnaseq_ids.txt | awk '{ print $2}'`)
    for i in "${rnaseq_ids[@]}"
    do
        aws_zip=`aws --recursive --endpoint-url http://gdc-accessor1.osdc.io s3 ls s3://target_mirnaseq_alignment_meta_3/${i} | grep -i fastq | grep -i zip`
        for line in "${aws_zip[@]}"
        do
            for result in ${line}
            do
                echo ${result} | grep zip
                if [ $? -eq 0 ]
                then
                    to_db "${result}"
                fi
            done
        done
        aws --endpoint-url http://kh13-9.osdc.io --profile ceph s3 cp ${i::-1}_fastqc_db.db s3://target_mirnaseq_fastq_db/${i}
        rm *.db *.log
    done
}

main "$@"
