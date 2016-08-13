cat qcfail_realign_table.txt | grep mkdup_needed > mkdup_needed.txt
sort -k14V -t$'\t'  mkdup_needed.txt > mkdup_needed_sort.txt

tail -n 96 mkdup_needed_sort.txt | awk '{print $3}' > deadpool.lst
while read line ; do grep -l ${line} md_slurm/* ; done < deadpool.lst  > sbatch_deadpool.sh
sed -i 's/^/sbatch /' sbatch_deadpool.sh


