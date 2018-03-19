#!/usr/bin/env bash

input_workflow_path=${1}
input_workflow_name=$(basename "${input_workflow_path}")
workflow_prefix="${input_workflow_name%.*}"
fileext="${input_workflow_name##*.}"

output_name=${workflow_prefix}_pack.${fileext}

echo "input_workflow_path: ${input_workflow_path}"
echo "packed workflow: ${output_name}"

#set -e
cwltool --pack ${input_workflow_path} > ${output_name}
docker_repos=($(grep dockerPull ${output_name} | sort | uniq | awk '{print $2}' | sed -e 's/^"//' -e 's/"$//' | awk -F ":" '{print $1}' | grep ncigdc))
rm ${output_name}
for docker_repo in "${docker_repos[@]}"
do
    docker pull ${docker_repo}:latest
done


for docker_repo in "${docker_repos[@]}"
do
    file_names=($(grep -lr ${docker_repo} *))
    for file_name in "${file_names[@]}"
    do
        echo ${file_name}
        did=$(docker inspect ${docker_repo}:latest | grep "Id\":" | awk -F ":" '{print $3}' | sed -e 's/",$//')
        grep ${docker_repo}:${did} ${file_name}
        if [ $? -ne 0 ]
        then
            echo ${file_name} needs fixin ${docker_repo}
            sed -i "s|${docker_repo}:.*|${docker_repo}:${did}|" ${file_name}
        fi
        docker tag ${docker_repo}:latest ${docker_repo}:${did}
        docker push ${docker_repo}:${did}       
    done
done
