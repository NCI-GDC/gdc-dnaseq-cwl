#!/usr/bin/env python

import argparse
import logging
import math
import os
import sys
import uuid

NUM_CPU = 40

def read_header(header_line):
    header_split = header_line.strip().split(',')
    header_key_dict = dict()
    for i, header_column in enumerate(header_split):
        header_key_dict[header_column.strip()] = i
    return header_key_dict

def generate_runner(db_cred, db_table_name, input_gdc_id, repo_hash,
                    s3_load_bucket, slurm_core, json_template_path):
    job_json = input_gdc_id + '_bqsr_wgs.json'
    f_open = open(job_json, 'w')
    with open(json_template_path, 'r') as read_open:
        for line in read_open:
            if 'XX_DB_CRED_XX' in line:
                newline = line.replace('XX_DB_CRED_XX', db_cred)
                f_open.write(newline)
            elif 'XX_INPUT_GDC_ID_XX' in line:
                newline = line.replace('XX_INPUT_GDC_ID_XX', input_gdc_id)
                f_open.write(newline)
            elif 'XX_STATUS_TABLE_NAME_XX' in line:
                newline = line.replace('XX_STATUS_TABLE_NAME_XX', db_table_name)
                f_open.write(newline)
            elif 'XX_LOAD_BUCKET_XX' in line:
                newline = line.replace('XX_LOAD_BUCKET_XX', s3_load_bucket)
                f_open.write(newline)
            elif 'XX_REPO_HASH_XX' in line:
                newline = line.replace('XX_REPO_HASH_XX', repo_hash)
                f_open.write(newline)
            elif 'XX_RESOURCE_CORE_COUNT_XX' in line:
                newline = line.replace('XX_RESOURCE_CORE_COUNT_XX', str(slurm_core))
                f_open.write(newline)
            else:
                f_open.write(line)
    f_open.close()
    return

def generate_slurm(db_cred, db_table_name, input_gdc_id, node_json_dir,
                   repo_hash, scratch_dir, slurm_core, slurm_template_path):
    job_slurm = input_gdc_id + '_bqsr_wgs.sh'
    job_json = input_gdc_id + '_bqsr_wgs.json'
    f_open = open(job_slurm, 'w')
    with open(slurm_template_path, 'r') as read_open:
        for line in read_open:
            if 'XX_DB_CRED_XX' in line:
                newline = line.replace('XX_DB_CRED_XX', db_cred)
                f_open.write(newline)
            elif 'XX_DB_TABLE_NAME_XX' in line:
                newline = line.replace('XX_DB_TABLE_NAME_XX', db_table_name)
                f_open.write(newline)
            elif 'XX_INPUT_GDC_ID_XX' in line:
                newline = line.replace('XX_INPUT_GDC_ID_XX', input_gdc_id)
                f_open.write(newline)
            elif 'XX_JSON_PATH_XX' in line:
                json_path = os.path.join(node_json_dir, job_json)
                newline = line.replace('XX_JSON_PATH_XX', json_path)
                f_open.write(newline)
            elif 'XX_REPO_HASH_XX' in line:
                newline = line.replace('XX_REPO_HASH_XX', repo_hash)
                f_open.write(newline)
            elif 'XX_RESOURCE_CORE_COUNT_XX' in line:
                newline = line.replace('XX_RESOURCE_CORE_COUNT_XX', str(slurm_core))
                f_open.write(newline)
            elif 'XX_SCRATCH_DIR_XX' in line:
                newline = line.replace('XX_SCRATCH_DIR_XX', scratch_dir)
                f_open.write(newline)
            else:
                f_open.write(line)
    f_open.close()
    return

def setup_job(db_cred, db_table_name, input_gdc_id, node_json_dir, repo_hash,
              s3_load_bucket, scratch_dir, slurm_core,
              json_template_path, slurm_template_path):

    generate_runner(db_cred, db_table_name, input_gdc_id, repo_hash,
                    s3_load_bucket, slurm_core, json_template_path)
    generate_slurm(db_cred, db_table_name, input_gdc_id, node_json_dir,
                   repo_hash, scratch_dir, slurm_core, slurm_template_path)
    return

def main():
    parser = argparse.ArgumentParser('make slurm')
    # Logging flags.
    parser.add_argument('-d', '--debug',
        action = 'store_const',
        const = logging.DEBUG,
        dest = 'level',
        help = 'Enable debug logging.',
    )
    parser.set_defaults(level = logging.INFO)

    parser.add_argument('--db_cred',
                        required = True
    )
    parser.add_argument('--db_table_name',
                        required = True
    )
    parser.add_argument('--job_table_path',
                        required = True
    )    
    parser.add_argument('--json_template_path',
                        required = True
    )
    parser.add_argument('--node_json_dir',
                        required = True
    )
    parser.add_argument('--repo_hash',
                        required = True
    )
    parser.add_argument('--scratch_disk_bytes',
                        type = int,
                        required = True
    )
    parser.add_argument('--s3_load_bucket',
                        required = True
    )
    parser.add_argument('--scratch_dir',
                        required = True
    )
    parser.add_argument('--slurm_template_path',
                        required = True
    )

    args = parser.parse_args()

    db_cred = args.db_cred
    db_table_name = args.db_table_name
    job_table_path = args.job_table_path
    json_template_path = args.json_template_path
    node_json_dir = args.node_json_dir
    repo_hash = args.repo_hash
    s3_load_bucket = args.s3_load_bucket
    scratch_dir = args.scratch_dir
    scratch_disk_bytes = args.scratch_disk_bytes
    slurm_template_path = args.slurm_template_path

    with open(job_table_path, 'r') as job_table_open:
        for job_line in job_table_open:
            if job_line.startswith('aligned_gdc_id'):
                header_key_dict = read_header(job_line)
            else:
                job_split = job_line.strip().split(',')
                input_gdc_id = job_split[header_key_dict['aligned_gdc_id']]
                input_filesize = job_split[header_key_dict['aligned_filesize']]
                required_storage = 2 * int(input_filesize)
                fraction_of_resources = required_storage / scratch_disk_bytes
                slurm_core = math.ceil(fraction_of_resources * NUM_CPU)
                setup_job(db_cred, db_table_name, input_gdc_id, node_json_dir, repo_hash,
                          s3_load_bucket, scratch_dir, slurm_core,
                          json_template_path, slurm_template_path)
                

if __name__=='__main__':
    main()
