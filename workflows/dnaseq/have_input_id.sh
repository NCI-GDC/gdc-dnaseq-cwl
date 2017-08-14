#!/usr/bin/env bash

infile=${1}

while read p
do
    uuid1=$(echo ${p} | awk -F',' '{print $1}')
    uuid2=$(echo ${p} | awk -F',' '{print $2}')
    printf "uuid: ${uuid1}\n"
    list="$(find tcga_wgs_alignment_* -iname "*${uuid1}*" | egrep '.*')"
    if [ $? -eq 1 ]
    then
        list="$(find tcga_wgs_alignment_* -iname "*${uuid2}*" | egrep '.*')"
        if [ $? -eq 1 ]
        then
            printf "\t\t\tDO NOT HAVE ${uuid2} for ${uuid1}\n"
        else
            #continue
            printf "\t\tuuid2 HAS ${uuid2} for ${uuid1}\n"
        fi
    else
        #continue
        printf "\t uuid1 HAS ${uuid1}\n"
    fi
done < ${infile}
