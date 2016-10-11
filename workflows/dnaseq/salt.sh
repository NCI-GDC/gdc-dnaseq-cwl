# fix nodes
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu "sed -i 's/kh11-9.osdc.io/gdc-cephb-objstore.osdc.io/g' /home/ubuntu/.s3cfg.ceph"

# on workstation, prep cwl, slurm and json job files
workon p3
head -n1 wgs753.txt > wgs753_dp.txt && grep dp_ wgs753.txt | sed 's/dp_//g' >> wgs753_dp.txt
grep -v dp_ wgs753.txt | grep -v too_big > wgs753_cl.txt

#cl
mkdir wgs_753_cl
mkdir wgs_753_cl_slurm
mkdir wgs_753_cl_json
cd wgs_753_cl
python ~/code/cocleaning-cwl/workflows/dnaseq/create_jobs_from_templates.py --db_table_name wgs_753_status --job_table_path ~/wgs753_cl.txt --json_template_path ~/code/cocleaning-cwl/workflows/dnaseq/runner_template.json --node_json_dir /home/ubuntu/wgs_753_cl_json --repo_hash 7988e210888eed2edd17a05b838bfcf845dbf18b --resource_core_count 40 --resource_disk_bytes 1539316278886 --resource_memory_bytes 42949672960  --s3_load_bucket s3://tcga_wgs_alignment_4 --scratch_dir /mnt/SCRATCH --slurm_template_path ~/code/cocleaning-cwl/workflows/dnaseq/slurm_template.sh
mv *.json ../wgs_753_cl_json
mv *.sh ../wgs_753_cl_slurm
cd ../
rmdir wgs_753_cl

#dp
mkdir wgs_753_dp
mkdir wgs_753_dp_slurm
mkdir wgs_753_dp_json
cd wgs_753_dp
python ~/code/cocleaning-cwl/workflows/dnaseq/create_jobs_from_templates.py --db_table_name wgs_753_status --job_table_path ~/wgs753_dp.txt --json_template_path ~/code/cocleaning-cwl/workflows/dnaseq/runner_template.json --node_json_dir /home/ubuntu/wgs_753_dp_json --repo_hash 7988e210888eed2edd17a05b838bfcf845dbf18b --resource_core_count 40 --resource_disk_bytes 1539316278886 --resource_memory_bytes 42949672960  --s3_load_bucket s3://tcga_wgs_alignment_4 --scratch_dir /mnt/SCRATCH --slurm_template_path ~/code/cocleaning-cwl/workflows/dnaseq/slurm_template.sh
mv *.json ../wgs_753_dp_json
mv *.sh ../wgs_753_dp_slurm
cd ../
rmdir wgs_753_dp


rsync -av --progress wgs_753_* jer:/mnt/SCRATCH/
cp -arf ~/code/cocleaning-cwl ~/
cd ~/cocleaning-cwl/
rm -rf .git
cd  ~/
rsync -av --progress ~/cocleaning-cwl jer:/mnt/SCRATCH/


#push cocleaning-cwl to any node, and place on object store
ssh jer
cd /mnt/SCRATCH/cocleaning-cwl
s3cmd -c ~/.s3cfg.ceph --recursive put cocleaning-cwl s3://bioinformatics_scratch/jhsavage_salt/

#push json to object store
s3cmd -c ~/.s3cfg.ceph --recursive put wgs_753_cl_json s3://bioinformatics_scratch/jhsavage_salt/
s3cmd -c ~/.s3cfg.ceph --recursive put wgs_753_dp_json s3://bioinformatics_scratch/jhsavage_salt/

#put cwltool to object store
wget https://github.com/jeremiahsavage/cwltool/archive/1.0_gdc_e.tar.gz
s3cmd -c ~/.s3cfg.ceph put 1.0_gdc_e.tar.gz s3://bioinformatics_scratch/jhsavage_salt/


salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'rm -rf /mnt/SCRATCH/*'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'rm -rf /home/ubuntu/cocleaning-cwl'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'rm -rf /home/ubuntu/wgs_753*'
#http://unix.stackexchange.com/questions/138751/unattended-upgrades-and-modified-configuration-files
salt -G 'cluster_name:WOLVERINE' cmd.run 'echo "Dpkg::Options {
   "--force-confdef";
   "--force-confold";
};
" >> /etc/apt/apt.conf.d/50unattended-upgrades'
salt -G 'cluster_name:WOLVERINE' cmd.run 'apt-get update &&  apt-get install python-dev libffi-dev libssl-dev htop s3cmd -y && apt-get clean'
salt -G 'cluster_name:WOLVERINE' cmd.run 'echo "172.17.12.36 signpost.service.consul" >> /etc/hosts'


salt -G 'cluster_name:WOLVERINE' cmd.run 'apt-get update &&  apt-get upgrade -y && apt-get autoremove'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'docker rmi -f $(docker images -q)'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'rm -rf /home/ubuntu/.virtualenvs /home/ubuntu/1.0_gdc_e.tar.gz'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'bash -c "export http_proxy=http://cloud-proxy:3128 && export https_proxy=http://cloud-proxy:3128 && source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && mkvirtualenv --python /usr/bin/python2 jhs_cwl && pip install --upgrade pip && pip install --upgrade ndg-httpsclient && pip install --upgrade requests[security]"'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'cd /home/ubuntu && s3cmd -c ~/.s3cfg.ceph get s3://bioinformatics_scratch/jhsavage_salt/1.0_gdc_e.tar.gz'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'bash -c "export http_proxy=http://cloud-proxy:3128 && export https_proxy=http://cloud-proxy:3128 && source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && workon jhs_cwl && pip install /home/ubuntu/1.0_gdc_e.tar.gz --no-cache-dir && rm /home/ubuntu/1.0_gdc_e.tar.gz"'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 's3cmd --skip-existing --recursive -c ~/.s3cfg.ceph get s3://bioinformatics_scratch/jhsavage_salt/'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'mv jhsavage_endpoint.json endpoint.json'



####DEADPOOL####
salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu "sed -i 's/kh11-9.osdc.io/gdc-cephb-objstore.osdc.io/g' /home/ubuntu/.s3cfg.ceph"

####
salt -G 'cluster_name:DEADPOOL' cmd.run 'echo "Dpkg::Options {
   "--force-confdef";
   "--force-confold";
};
" >> /etc/apt/apt.conf.d/50unattended-upgrades'
salt -G 'cluster_name:DEADPOOL' cmd.run 'apt-get update &&  apt-get install python-dev libffi-dev libssl-dev htop s3cmd virtualenvwrapper -y && apt-get clean'
salt -G 'cluster_name:DEADPOOL' cmd.run 'echo "172.17.12.36 signpost.service.consul" >> /etc/hosts'
salt -G 'cluster_name:DEADPOOL' cmd.run 'apt-get update &&  apt-get upgrade -y && apt-get autoremove'
salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'docker rmi -f $(docker images -q)'
salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'rm -rf /home/ubuntu/.virtualenvs'
salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'bash -c "export http_proxy=http://cloud-proxy:3128 && export https_proxy=http://cloud-proxy:3128 && source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && mkvirtualenv --python /usr/bin/python2 jhs_cwl && pip install --upgrade pip && pip install --upgrade ndg-httpsclient && pip install --upgrade requests[security]"'
salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'bash -c "export http_proxy=http://cloud-proxy:3128 && export https_proxy=http://cloud-proxy:3128 && source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && workon jhs_cwl && pip install --upgrade awscli"'
salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'cd /home/ubuntu && s3cmd -c ~/.s3cfg.ceph get --force s3://bioinformatics_scratch/jhsavage_salt/1.0_gdc_e.tar.gz'
salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'bash -c "export http_proxy=http://cloud-proxy:3128 && export https_proxy=http://cloud-proxy:3128 && source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && workon jhs_cwl && pip install /home/ubuntu/1.0_gdc_e.tar.gz --no-cache-dir && rm /home/ubuntu/1.0_gdc_e.tar.gz"'
salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 's3cmd --skip-existing --recursive -c ~/.s3cfg.ceph get s3://bioinformatics_scratch/jhsavage_salt/'
