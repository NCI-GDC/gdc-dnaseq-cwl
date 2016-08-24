salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'docker rmi -f $(docker images -q)'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'rm -rf /mnt/SCRATCH/cache /mnt/SCRATCH/tmp /home/ubuntu/.virtualenvs/'
salt -G 'cluster_name:WOLVERINE' cmd.run 'apt-get update &&  apt-get install virtualenvwrapper python-dev libffi-dev libssl-dev htop s3cmd -y && apt-get clean'
salt -G 'cluster_name:WOLVERINE' cmd.run 'echo "172.17.29.16 signpost.service.consul" >> /etc/hosts'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'sed -i "s/\/usr\/local\/bin\/virtualenvwrapper.sh/\/usr\/share\/virtualenvwrapper\/virtualenvwrapper.sh/g" /home/ubuntu/.bashrc'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'bash -c "export http_proxy=http://cloud-proxy:3128 && export https_proxy=http://cloud-proxy:3128 && source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && mkvirtualenv --python /usr/bin/python2 cwl && pip install --upgrade pip && pip install 'requests[security]' && pip install cwltool --no-cache-dir"'


#check
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'bash -c "source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && workon cwl && cwltool --version"'
