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

#stage
salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'docker rmi -f $(docker images -q)'
salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'rm -rf /mnt/SCRATCH/cache /mnt/SCRATCH/tmp'
salt -G 'cluster_name:DEADPOOL' cmd.run 'apt-get update &&  apt-get install python-dev libffi-dev libssl-dev htop s3cmd -y && apt-get clean'
salt -G 'cluster_name:DEADPOOL' cmd.run 'echo "172.17.29.16 signpost.service.consul" >> /etc/hosts'
salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'sed -i "s/\/usr\/local\/bin\/virtualenvwrapper.sh/\/usr\/share\/virtualenvwrapper\/virtualenvwrapper.sh/g" /home/ubuntu/.bashrc'
salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'bash -c "export http_proxy=http://cloud-proxy:3128 && export https_proxy=http://cloud-proxy:3128 && source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && mkvirtualenv --python /usr/bin/python2 cwl && pip install --upgrade pip && pip install 'requests[security]' && pip install cwltool --no-cache-dir"'

#2016-09-01
#hack fix of clevesafe write
$ sinfo -Nh | awk '{print $1}' > nodes.list
while read line ; do echo "salt '${line}' cmd.run runas=ubuntu 'sed -i "s/gdc-accessors.osdc.io/10.64.80.110/g" /home/ubuntu/jhsavage_endpoint.json'" ; done < nodes.list

salt 'compute-slurm-deadpool-slurm-worker-0' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.110/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-1' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.110/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-2' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.110/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-3' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.110/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-4' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.110/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-5' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.110/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-6' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.110/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-7' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.110/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-8' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.111/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-9' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.111/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-10' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.111/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-11' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.111/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-13' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.111/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-14' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.111/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-15' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.111/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-16' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.111/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-17' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.112/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-18' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.112/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-19' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.112/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-20' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.112/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-21' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.112/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-22' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.112/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-23' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.112/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-24' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.112/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-25' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.123/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-26' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.123/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-27' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.123/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-28' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.123/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-29' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.123/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-30' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.123/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-31' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.123/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-32' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.123/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-33' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.124/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-34' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.124/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-35' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.124/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-36' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.124/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-37' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.124/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-38' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.124/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-39' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.124/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-40' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.124/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-41' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.125/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-42' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.125/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-43' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.125/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-44' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.125/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-45' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.125/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-46' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.125/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-47' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.125/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-48' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.125/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-49' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.136/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-50' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.136/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-51' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.136/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-52' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.136/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-53' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.136/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-54' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.136/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-55' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.136/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-56' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.136/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-57' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.137/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-58' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.137/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-59' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.137/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-60' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.137/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-61' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.137/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-62' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.137/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-63' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.137/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-64' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.137/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-65' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.138/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-66' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.138/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-67' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.138/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-68' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.138/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-69' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.138/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-70' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.138/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-71' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.138/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-72' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.138/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-73' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.148/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-74' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.148/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-76' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.148/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-77' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.148/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-78' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.148/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-80' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.148/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-81' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.148/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-83' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.148/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-84' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.149/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-85' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.149/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-89' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.149/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-90' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.149/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-92' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.149/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-93' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.149/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-94' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.149/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-95' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.149/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-97' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.150/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-98' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.150/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-99' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.150/g /home/ubuntu/jhsavage_endpoint.json'
salt 'compute-slurm-deadpool-slurm-worker-100' cmd.run runas=ubuntu 'sed -i s/gdc-accessors.osdc.io/10.64.80.150/g /home/ubuntu/jhsavage_endpoint.json'

salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'sed -i "s/ceph/cleversafe/g" /home/ubuntu/md_json/*_etl.json'
compute-slurm-deadpool-slurm-worker-0
compute-slurm-deadpool-slurm-worker-1
...

dig +short gdc-accessors.osdc.io | shuf -n1

$ dig +short gdc-accessors.osdc.io | sort
10.64.80.110
10.64.80.111
...

##2016-09-02
salt -G 'cluster_name:DEADPOOL' cmd.run 'sed -i "s/172.17.29.16/172.17.52.27/g" /etc/hosts'
salt -G 'cluster_name:WOLVERINE' cmd.run 'sed -i "s/172.17.29.16/172.17.52.27/g" /etc/hosts'
salt -G 'cluster_name:CLAIRE' cmd.run 'sed -i "s/172.17.29.16/172.17.52.27/g" /etc/hosts'
