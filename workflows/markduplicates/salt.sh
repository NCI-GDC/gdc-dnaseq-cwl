s3cmd -c ~/.s3cfg.ceph --recursive put md_json s3://bioinformatics_scratch/jhsavage_markduplicates_salt/
s3cmd -c ~/.s3cfg.ceph --recursive put cocleaning-cwl s3://bioinformatics_scratch/jhsavage_markduplicates_salt/
s3cmd -c ~/.s3cfg.ceph --recursive put connect_jhsavage.ini s3://bioinformatics_scratch/jhsavage_markduplicates_salt/
s3cmd -c ~/.s3cfg.ceph put jhsavage_endpoint.json s3://bioinformatics_scratch/jhsavage_markduplicates_salt/

salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 's3cmd --skip-existing --recursive -c ~/.s3cfg.ceph get s3://bioinformatics_scratch/jhsavage_markduplicates_salt/'

salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'rm -rf /home/ubuntu/.virtualenvs'

salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'sed -i "s/\/usr\/local\/bin\/virtualenvwrapper.sh/\/usr\/share\/virtualenvwrapper\/virtualenvwrapper.sh/g" /home/ubuntu/.bashrc'

salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'bash -c "export http_proxy=http://cloud-proxy:3128 && export https_proxy=http://cloud-proxy:3128 && source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && mkvirtualenv --python /usr/bin/python2 cwl && pip install https://github.com/jeremiahsavage/cwltool/archive/1.0b.tar.gz"'

salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'bash -c "export http_proxy=http://cloud-proxy:3128 && export https_proxy=http://cloud-proxy:3128 && source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && mkvirtualenv --python /usr/bin/python2 cwl && pip install --upgrade pip && pip install 'requests[security]' && pip install cwltool --no-cache-dir"'

salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'rm -rf /mnt/SCRATCH/cache /mnt/SCRATCH/tmp'

salt -G 'cluster_name:DEADPOOL' cmd.run 'echo "172.17.29.16 signpost.service.consul" >> /etc/hosts'

salt -G 'cluster_name:DEADPOOL' cmd.run 'apt-get update &&  apt-get install python-dev libffi-dev libssl-dev htop s3cmd -y && apt-get clean'

salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'rm -rf /home/ubuntu/cocleaning-cwl /home/ubuntu/md_json /mnt/SCRATCH/cache /mnt/SCRATCH/tmp'

salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'docker rmi -f $(docker images -q)'
