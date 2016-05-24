#!/usr/bin/env python3

import os
import subprocess


def main():
    # cmd = ['s3cmd', '-c', '/home/ubuntu/.s3cfg.ceph', 'ls', 's3://target_rnaseq_fastq_db/']
    # output = subprocess.check_output(cmd)
    # output_split= output.decode().split('\n')
    # outfile = 'target_uuid_length.tsv'
    # outfile_open = open(outfile, 'w')
    # for line in output_split:
    #     print('line=%s' % line.strip())
    #     if len(line) > 1:
    #         uuid = line.split()[-1].strip().split('/')[-2]
    #         s3_url = 's3://target_rnaseq_fastq_db/' + uuid + '/' + uuid + '_fastqc_db.db'
    #         cmd = ['s3cmd', '--force', '-c', '/home/ubuntu/.s3cfg.ceph', 'get', s3_url]
    #         print('cmd=%s' % cmd)
    #         subprocess.check_output(cmd)
    #         db_file = uuid + '_fastqc_db.db'
    #         cmd = [ 'sqlite3', db_file, "select max(Value) from fastqc_data_Basic_Statistics where Measure='Sequence length';"]
    #         max_value = int(subprocess.check_output(cmd).decode().strip())
    #         outfile_open.write(uuid + '\t' + str(max_value) + '\n')
    #         os.remove(db_file)
    # outfile_open.close()


    cmd = ['s3cmd', '-c', '/home/ubuntu/.s3cfg.ceph', 'ls', 's3://tcga_rnaseq_fastq_db/']
    output = subprocess.check_output(cmd)
    output_split= output.decode().split('\n')
    outfile = 'tcga_uuid_length.tsv'
    outfile_open = open(outfile, 'w')
    for line in output_split:
        print('line=%s' % line.strip())
        if len(line) > 1:
            uuid = line.split()[-1].strip().split('/')[-2]
            s3_url = 's3://tcga_rnaseq_fastq_db/' + uuid + '/' + uuid + '_fastqc_db.db'
            cmd = ['s3cmd', '--force', '-c', '/home/ubuntu/.s3cfg.ceph', 'get', s3_url]
            print('cmd=%s' % cmd)
            subprocess.check_output(cmd)
            db_file = uuid + '_fastqc_db.db'
            cmd = [ 'sqlite3', db_file, "select max(Value) from fastqc_data_Basic_Statistics where Measure='Sequence length';"]
            str_value = subprocess.check_output(cmd).decode().strip()
            try:
                max_value = int(str_value)
            except ValueError:
                print('ValueError: %s' % str_value)
                max_value = int(str_value.split('-')[-1])
            outfile_open.write(uuid + '\t' + str(max_value) + '\n')
            os.remove(db_file)
    outfile_open.close()

if __name__ == '__main__':
    main()
