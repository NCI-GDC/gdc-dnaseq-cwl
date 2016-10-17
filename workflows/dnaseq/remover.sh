#!/usr/bin/env bash

while read line
do
    gdc_src_uuid=`echo ${line} | awk -F "|" '{print $3}' | tr -d '[[:space:]]'`
    echo ${gdc_src_uuid}
    bash_path=../${gdc_src_uuid}.sh
    echo rm ${bash_path}
    rm ${bash_path}
done < ../complete_input_uuid.txt
