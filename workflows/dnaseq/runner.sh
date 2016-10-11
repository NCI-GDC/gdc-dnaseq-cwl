#!/usr/bin/env bash

while read line
do
    gdc_src_id=`echo ${line} | awk '{print $1}'`
    if [ gdc_src_id == 'imported_gdc_id' ]
    then
        continue
    fi
    #echo ${gdc_src_id}
    sbatch_file=`grep -l ${gdc_src_id} *`
    echo sbatch ${sbatch_file}
done < ../wgs753_wv.txt
