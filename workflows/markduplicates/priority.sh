cat qcfail_realign_table.txt | grep mkdup_needed > mkdup_needed.txt
sort -k14V -t$'\t'  mkdup_needed.txt > mkdup_needed_sort.txt
