cwltool --pack runner_wgs.cwl > runner_wgs_pack.cwl
docker_repos=($(grep dockerPull runner_wgs_pack.cwl | sort | uniq | awk '{print $2}' | sed -e 's/^"//' -e 's/"$//' | awk -F ":" '{print $1}' | grep ncigdc))
for docker_repo in "${docker_repos[@]}"
do
    docker pull ${docker_repo}:latest
done
