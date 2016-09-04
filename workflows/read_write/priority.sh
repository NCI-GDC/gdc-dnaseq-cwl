s3cmd --recur -c ~/.s3cfg.ceph ls s3://ceph_qcpass_target_exome_coclean/ | grep bam$ > qcpass.lst
sort -k3 -h qcpass.lst > qcpass_sort.lst
head -n -1 qcpass_sort.lst > stress.lst
