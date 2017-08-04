#!/usr/bin/env bash

#0
#aws s3 ls --recursive --profile cleversafe --endpoint-url http://gdc-accessors.osdc.io/ s3://tcga_wgs_alignment_logs | awk '{print $4}' | grep "\.db$" > tcga_wgs_alignment_logs.ls

#1
#aws s3 ls --recursive --profile cleversafe --endpoint-url http://gdc-accessors.osdc.io/ s3://tcga_wgs_alignment_4/ | awk '{print $4}' | grep "\.db$" > tcga_wgs_alignment_4.ls

#2
#aws s3 ls --recursive --profile cleversafe --endpoint-url http://gdc-accessors.osdc.io/ s3://tcga_wgs_alignment_5/ | awk '{print $4}' | grep "\.db$" > tcga_wgs_alignment_5.ls


infile=${1}
SCRIPT=$(realpath ${0})
SCRIPTDIR=$(dirname ${SCRIPT})

# #0
# while read p
# do
#     if [[ ${p} == *.db ]]
#     then
#         id_name=${p%.*}
#         echo "aws s3 cp --quiet --profile cleversafe --endpoint-url http://gdc-accessors.osdc.io/ s3://tcga_wgs_alignment_logs/${p} . && sync && sync && sync && python ${SCRIPTDIR}/import_from_sqlite.py --input_sqlite ${p} --gdc_id ${id_name} && rm ${p}"
#     fi
# done < ${infile} | parallel -j 24

# #1
# while read p
# do
#     if [[ ${p} == *.db ]]
#     then
#         pbasename=$(basename ${p})
#         id_name=${pbasename%.*}
#         echo "aws s3 cp --quiet --profile cleversafe --endpoint-url http://gdc-accessors.osdc.io/ s3://tcga_wgs_alignment_4/${p} . && sync && sync && sync && python ${SCRIPTDIR}/import_from_sqlite.py --input_sqlite ${pbasename} --gdc_id ${id_name} && rm ${pbasename}"
#     fi
# done < ${infile} | parallel -j 24

#2
while read p
do
    if [[ ${p} == *.db ]]
    then
        pbasename=$(basename ${p})
        id_name=${pbasename%.*}
        echo "aws s3 cp --quiet --profile cleversafe --endpoint-url http://gdc-accessors.osdc.io/ s3://tcga_wgs_alignment_5/${p} . && sync && sync && sync && python ${SCRIPTDIR}/import_from_sqlite.py --input_sqlite ${pbasename} --gdc_id ${id_name} && rm ${pbasename}"
    fi
done < ${infile} | parallel -j 24
