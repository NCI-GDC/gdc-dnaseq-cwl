#!/bin/bash

aws --endpoint-url http://gdc-accessor1.osdc.io s3 ls s3://tcga_rnaseq_alignment_meta_3/ > rnaseq_ids.txt
rnaseq_ids=(`cat rnaseq_ids.txt | awk '{ print $2}'`)
for i in "${rnaseq_ids[@]}"
do
    echo ${i}
done
