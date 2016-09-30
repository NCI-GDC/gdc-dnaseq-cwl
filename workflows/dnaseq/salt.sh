# on workstation, prep cwl, slurm and json job files
workon p3
mkdir wgs_330
mkdir wgs_330_slurm
mkdir wgs_330_json
cd wgs_330
python ~/code/cocleaning-cwl/workflows/dnaseq/create_jobs_from_templates.py --db_table_name wgs_330_status --job_table_path ~/qcfail_realign_table.txt --json_template_path ~/code/cocleaning-cwl/workflows/dnaseq/runner_template.json --node_json_dir /home/ubuntu/runner_json --repo_hash 69b25ff0ee0221ea0694afbd5f570d4e353d641c --s3_load_bucket tcga_wgs_alignment_4 --scratch_dir /mnt/SCRATCH --slurm_template_path ~/code/cocleaning-cwl/workflows/dnaseq/slurm_template.sh
mv *.json ../wgs_330_json
mv *.sh ../wgs_330_slurm
cd ../
rmdir wgs_330
rsync -av --progress wgs_330* jer:
rsync -av --progress ~/code/cocleaning-cwl jer:/mnt/SCRATCH/


#push cocleaning-cwl to any node, and place on object store
ssh jer
cd /mnt/SCRATCH/cocleaning-cwl
rm -rf .git
cd ../
s3cmd -c ~/.s3cfg.ceph --recursive put cocleaning-cwl s3://bioinformatics_scratch/jhsavage_salt/

#push json cwl inpout to any node, and place on object store
s3cmd -c ~/.s3cfg.ceph --recursive put runner_json s3://bioinformatics_scratch/jhsavage_salt/

salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'rm -rf /mnt/SCRATCH/wgs_330 /mnt/SCRATCH/read_write /mnt/SCRATCH/somaticmafpon /mnt/SCRATCH/cache /mnt/SCRATCH/tmp /mnt/SCRATCH/reference /mnt/SCRATCH/slurm*.out'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'rm -rf /home/ubuntu/.virtualenvs /home/ubuntu/*'
salt -G 'cluster_name:WOLVERINE' cmd.run 'apt-get update &&  apt-get install python-dev libffi-dev libssl-dev htop s3cmd -y && apt-get clean'
salt -G 'cluster_name:WOLVERINE' cmd.run 'apt-get update &&  apt-get upgrade -y'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'docker rmi -f $(docker images -q)'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 'bash -c "export http_proxy=http://cloud-proxy:3128 && export https_proxy=http://cloud-proxy:3128 && source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && mkvirtualenv --python /usr/bin/python2 cwl && pip install --upgrade pip && pip install 'requests[security]' && pip install https://github.com/jeremiahsavage/cwltool/archive/1.0_gdc_e.tar.gz --no-cache-dir"'
salt -G 'cluster_name:WOLVERINE' cmd.run runas=ubuntu 's3cmd --skip-existing --recursive -c ~/.s3cfg.ceph get s3://bioinformatics_scratch/jhsavage_markduplicates_salt/'
