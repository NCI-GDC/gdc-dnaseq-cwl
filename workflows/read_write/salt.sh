salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'docker rmi -f $(docker images -q)'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'rm -rf /mnt/SCRATCH/cache /mnt/SCRATCH/tmp /home/ubuntu/.virtualenvs/'
salt -G 'cluster_name:WOLVERINE' cmd.run 'apt-get update &&  apt-get install virtualenvwrapper python-dev libffi-dev libssl-dev htop s3cmd -y && apt-get clean'
salt -G 'cluster_name:WOLVERINE' cmd.run 'echo "172.17.29.16 signpost.service.consul" >> /etc/hosts'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'sed -i "s/\/usr\/local\/bin\/virtualenvwrapper.sh/\/usr\/share\/virtualenvwrapper\/virtualenvwrapper.sh/g" /home/ubuntu/.bashrc'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'bash -c "export http_proxy=http://cloud-proxy:3128 && export https_proxy=http://cloud-proxy:3128 && source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && mkvirtualenv --python /usr/bin/python2 cwl && pip install --upgrade pip && pip install 'requests[security]' && s3cmd -c ~/.s3cfg.ceph get --skip-existing s3://bioinformatics_scratch/1.0_gdc_c.tar.gz && pip install 1.0_gdc_c.tar.gz --no-cache-dir"'


#check
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'bash -c "source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && workon cwl && cwltool --version"'


#install
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'rm -rf /home/ubuntu/cocleaning-cwl /home/ubuntu/rw_json'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'rm /mnt/SCRATCH/slurm-*'

salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 's3cmd --skip-existing --recursive -c ~/.s3cfg.ceph get s3://bioinformatics_scratch/read_write/'
