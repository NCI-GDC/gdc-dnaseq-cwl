#set -e
cwltool --pack workflows/dnaseq/runner_wgs.cwl > runner_wgs_pack.cwl
docker_repos=($(grep dockerPull runner_wgs_pack.cwl | sort | uniq | awk '{print $2}' | sed -e 's/^"//' -e 's/"$//' | awk -F ":" '{print $1}' | grep ncigdc))
# for docker_repo in "${docker_repos[@]}"
# do
#     docker pull ${docker_repo}:latest
# done

for docker_repo in "${docker_repos[@]}"
do
    docker inspect ${docker_repo}:latest | grep "Id\":" | awk -F ":" '{print $3}' | sed -e 's/",$//'
done

rm runner_wgs_pack.cwl

for docker_repo in "${docker_repos[@]}"
do
    file_names=($(grep -lr ${docker_repo} *))
    for file_name in "${file_names[@]}"
    do
        echo ${file_name}
        did=$(docker inspect ${docker_repo}:latest | grep "Id\":" | awk -F ":" '{print $3}' | sed -e 's/",$//')
        grep ${docker_repo}:${did} ${file_name}
    done
done
