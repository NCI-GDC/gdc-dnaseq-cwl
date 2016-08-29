cat qcfail_realign_table.txt | grep mkdup_needed > mkdup_needed.txt
sort -k14V -t$'\t'  mkdup_needed.txt > mkdup_needed_sort.txt

tail -n 96 mkdup_needed_sort.txt | awk '{print $3}' > deadpool.lst
while read line ; do grep -l ${line} md_slurm/* ; done < deadpool.lst  > sbatch_deadpool.sh
sed -i 's/^/sbatch /' sbatch_deadpool.sh


head -n 759 mkdup_needed_sort.txt | awk '{print $3}' > deadpool.lst
while read line ; do grep -l ${line} md_slurm/* ; done < deadpool.lst  > sbatch_deadpool.sh
sed -i 's/^/sbatch /' sbatch_deadpool.sh


##rerun - push to cleversafe, not ceph
squeue -o "%.18i %.9P %.45j %.8u %.8T %.10M %.9l %.6D %R" > current.queue
squeue -o "%.18i %.9P %.45j %.8u %.8T %.10M %.9l %.6D %R" | grep PENDING | awk '{print $1}' > cancel.list

grep PENDING current.queue | awk '{print $3}' > rerun.list
while read line ; do sed -i 's/s3:\/\/ceph_markduplicates_wgs/s3:\/\/cleversafe_markduplicates_wgs_4/g' ${line} ; done < rerun.list

# salt
salt -G 'cluster_name:DEADPOOL' cmd.run runas=ubuntu 'sed -i "s/s3:\/\/ceph_markduplicates_wgs/s3:\/\/cleversafe_markduplicates_wgs_4/g" /home/ubuntu/md_json/*.json'

sed -i 's/^/sbatch /g' rerun.list
