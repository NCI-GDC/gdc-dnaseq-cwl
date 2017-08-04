#!/usr/bin/env bash

#aws s3 ls --recursive --profile cleversafe --endpoint-url http://gdc-accessors.osdc.io/  s3://tcga_wgs_alignment_logs | awk '{print $4}' > tcga_wgs_alignment_logs.ls

infile=${1}
SCRIPT=$(realpath ${0})
SCRIPTDIR=$(dirname ${SCRIPT})

while read p
do
    if [[ ${p} == *.db ]]
    then
        id_name=${p%.*}
        echo "aws s3 cp --quiet --profile cleversafe --endpoint-url http://gdc-accessors.osdc.io/ s3://tcga_wgs_alignment_logs/${p} . && sync && sync && sync && python ${SCRIPTDIR}/import_from_sqlite.py --input_sqlite ${p} --gdc_id ${id_name} && rm ${p}"
    fi
done < ${infile} | parallel -j 24
