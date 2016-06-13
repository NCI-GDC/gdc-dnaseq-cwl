#!/usr/bin/env python

import os
import subprocess

def has_fastqc_data_Basic_Statistics(db_file):
    print('has_fastqc_data_Basic_Statistics()')
    cmd = ['sqlite3', db_file, "'.tables'"]
    shell_cmd = ' '.join(cmd)
    print('shell_cmd=%s' % shell_cmd)
    output = subprocess.check_output(shell_cmd, shell=True)
    output_split = output.decode().split('\n')
    print('output_split=%s' % output_split)
    for table in output_split:
        if 'fastqc_data_Basic_Statistics' in table.encode('ascii').strip():
            print('db_file %s has fastqc_data_Basic_Statistic')
            return True
    print('db_file %s Does Not have fastqc_data_Basic_Statistic')
    return False

def to_postgres(db_file):
    print('to_postgres()')
    print('\tdb_file=%s' % db_file)
    cmd = ['cwltool', '--debug', '--enable-net', '--custom-net', 'host',
           '/home/ubuntu/cocleaning-cwl/tools/sqlite_to_postgres_hirate.cwl.yaml', '--source_sqlite_path', db_file,
           '--postgres_creds_path', '/home/ubuntu/connect_jhsavage_test.ini', '--ini_section', 'test', '--uuid', 'stop']
    print('cmd=\n%s' % cmd)
    output = subprocess.check_output(cmd)
    print('db_file:\t%s' % db_file)
    print('output=\n%s\n\n\n' % output.decode().format())
    return

def write_data(db_file):
    if has_fastqc_data_Basic_Statistics(db_file):
        to_postgres(db_file)
    return

def main():
    cmd = ['s3cmd', '-c', '/home/ubuntu/.s3cfg.cleversafe', 'ls', 's3://tcga_exome_alignment_logs/']
    output = subprocess.check_output(cmd)
    output_split = output.decode().split('\n')
    s3_list = list()
    for result in output_split:
        if len(result) < 2:
            continue
        print('result=%s' % result)
        file_name = result.split()[-1]
        if file_name.endswith('.db'):
            print('\tfile_name=%s' % file_name)
            s3_list.append(file_name)

    for s3_url in s3_list:
        print('s3_url=%s' % s3_url)
        cmd = ['s3cmd', '--force', '-c', '/home/ubuntu/.s3cfg.cleversafe', 'get', s3_url.encode('ascii')]
        print('cmd=%s' % cmd)
        output = subprocess.check_output(cmd)
        db_file = s3_url.split('/')[-1]
        print('db_file=%s' % db_file)
        write_data(db_file)
                       

if __name__ == '__main__':
    main()
