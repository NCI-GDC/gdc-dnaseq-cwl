#!/usr/bin/env python

import argparse
import logging
import math
import os
import sys
import uuid

def read_header(header_line):
    header_split = header_line.strip().split(',')
    header_key_dict = dict()
    for i, header_column in enumerate(header_split):
        header_key_dict[header_column.strip()] = i
    return header_key_dict

def generate_runner(db_cred, db_table_name, input_gdc_id, job_creation_uuid, job_json,
                    json_path, json_template_path, runner_cwl_path, runner_repo_hash,
                    s3_load_bucket, slurm_core, slurm_disk_gibibytes, slurm_mem_mebibytes):

    f_open = open(job_json, 'w')
    with open(json_template_path, 'r') as read_open:
        for line in read_open:
            if 'XX_DB_CRED_XX' in line:
                newline = line.replace('XX_DB_CRED_XX', db_cred)
                f_open.write(newline)
            elif 'XX_INPUT_GDC_ID_XX' in line:
                newline = line.replace('XX_INPUT_GDC_ID_XX', input_gdc_id)
                f_open.write(newline)
            elif 'XX_JOB_PATH_XX' in line:
                newline = line.replace('XX_JOB_PATH_XX', json_path)
                f_open.write(newline)
            elif 'XX_LOAD_BUCKET_XX' in line:
                newline = line.replace('XX_LOAD_BUCKET_XX', s3_load_bucket)
                f_open.write(newline)
            elif 'XX_NUM_THREADS_XX' in line:
                newline = line.replace('XX_NUM_THREADS_XX', str(slurm_core*2))
                f_open.write(newline)
            elif 'XX_SLURM_RESOURCE_CORE_COUNT_XX' in line:
                newline = line.replace('XX_RESOURCE_CORE_COUNT_XX', str(slurm_core))
                f_open.write(newline)
            elif 'XX_SLURM_RESOURCE_DISK_GIBIBYTES_XX' in line:
                newline = line.replace('XX_RESOURCE_DISK_GIBIBYTES_XX', str(slurm_disk_gibibytes))
                f_open.write(newline)
            elif 'XX_SLURM_RESOURCE_MEM_MEBIBYTES_XX' in line:
                newline = line.replace('XX_RESOURCE_MEM_MEBIBYTES_XX', str(slurm_mem_mebibytes))
                f_open.write(newline)
            elif 'XX_RUNNER_CWL_PATH_XX' in line:
                newline = line.replace('XX_RUNNER_CWL_PATH_XX', runner_cwl_path)
                f_open.write(newline)
            elif 'XX_RUNNER_REPO_HASH_XX' in line:
                newline = line.replace('XX_RUNNER_REPO_HASH_XX', runner_repo_hash)
                f_open.write(newline)
            elif 'XX_STATUS_TABLE_NAME_XX' in line:
                newline = line.replace('XX_STATUS_TABLE_NAME_XX', db_table_name)
                f_open.write(newline)
            else:
                f_open.write(line)
    f_open.close()
    return

def generate_slurm(input_gdc_id, job_slurm, json_path, scratch_dir, slurm_core,
                   slurm_disk_gibibytes, slurm_mem_mebibytes, slurm_template_path):
    f_open = open(job_slurm, 'w')
    with open(slurm_template_path, 'r') as read_open:
        for line in read_open:
            if 'XX_INPUT_GDC_ID_XX' in line:
                newline = line.replace('XX_INPUT_GDC_ID_XX', input_gdc_id)
                f_open.write(newline)
            elif 'XX_JSON_PATH_XX' in line:
                newline = line.replace('XX_JSON_PATH_XX', json_path)
                f_open.write(newline)
            elif 'XX_RESOURCE_CORE_COUNT_XX' in line:
                newline = line.replace('XX_RESOURCE_CORE_COUNT_XX', str(slurm_core))
                f_open.write(newline)
            elif 'XX_RESOURCE_DISK_GIBIBYTES_XX' in line:
                newline = line.replace('XX_RESOURCE_DISK_GIBIBYTES_XX', str(slurm_disk_gibibytes))
                f_open.write(newline)
            elif 'XX_RESOURCE_MEM_MEBIBYTES_XX' in line:
                newline = line.replace('XX_RESOURCE_MEM_MEBIBYTES_XX', str(slurm_mem_mebibytes))
                f_open.write(newline)
            elif 'XX_SCRATCH_DIR_XX' in line:
                newline = line.replace('XX_SCRATCH_DIR_XX', scratch_dir)
                f_open.write(newline)
            else:
                f_open.write(line)
    f_open.close()
    return

def setup_job(db_cred, db_table_name, http_json_base_url,
              input_gdc_id, job_table_path, job_creation_uuid,
              json_template_path, runner_cwl_path, runner_repo_hash, s3_load_bucket,
              scratch_dir, slurm_core, slurm_disk_gibibytes, slurm_mem_mebibytes,
              slurm_template_path):

    job_json = '/'.join(job_creation_uuid, 'cwl', input_gdc_id + '_bqsr_wgs.json')
    job_slurm = '/'.join(job_creation_uuid, 'slurm', input_gdc_id + '_bqsr_wgs.sh')
    json_path = '/'.join(http_json_base_url,job_creation_uuid,job_json)

    generate_runner(db_cred, db_table_name, input_gdc_id, job_creation_uuid, job_json,
                    json_path, json_template_path, runner_cwl_path, runner_repo_hash,
                    s3_load_bucket, slurm_core)
    generate_slurm(input_gdc_id, job_slurm, json_path, scratch_dir, slurm_core
                   slurm_disk_gibibytes, slurm_mem_mebibytes, slurm_template_path)
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
                        required=True
    )
    parser.add_argument('--db_table_name',
                        required=True
    )
    parser.add_argument('--http_json_base_url',
                        required=True
    )        
    parser.add_argument('--job_table_path',
                        required=True
    )    
    parser.add_argument('--json_template_path',
                        required = True
    )
    parser.add_argument('--num_cores',
                        type=int,
                        required=True)
    parser.add_argument('--runner_cwl_path',
                        required=True
    )
    parser.add_argument('--runner_repo_hash',
                        required=True
    )
    parser.add_argument('--s3_load_bucket',
                        required=True
    )
    parser.add_argument('--scratch_dir',
                        required=True
    )
    parser.add_argument('--slurm_disk_gibibytes',
                        type=int,
                        required=True
    )
    parser.add_argument('--slurm_mem_mebibytes',
                        type=int,
                        required=True
    )
    parser.add_argument('--slurm_template_path',
                        required=True
    )

    args = parser.parse_args()

    job_table_path = args.job_table_path
    json_template_path = args.json_template_path
    num_cores = args.num_cores
    http_json_base_url = args.http_json_base_url
    runner_cwl_hash = args.runner_cwl_hash
    runner_repo_hash = args.runner_repo_hash
    scratch_dir = args.scratch_dir
    slurm_disk_gibibytes = args.slurm_disk_gibibytes
    slurm_mem_mebibytes = args.slurm_mem_mebibytes
    slurm_template_path = args.slurm_template_path

    job_creation_uuid = str(uuid.uuid4())

    cwl_dir = '/'.join(job_creation_uuid,'cwl')
    slurm_dir = '/'.join(job_creation_uuid, 'slurm')

    if not os.path.exists(job_creation_uuid):
        os.makedirs(job_creation_uuid)
        os.makedirs(cwl_dir)
        os.makedirs(slurm_dir)
    else:
        sys.exit(job_creation_uuid + ' exists. Exiting.')

    with open(job_table_path, 'r') as job_table_open:
        for job_line in job_table_open:
            if job_line.startswith('aligned_gdc_id'):
                header_key_dict = read_header(job_line)
            else:
                job_split = job_line.strip().split(',')
                input_gdc_id = job_split[header_key_dict['aligned_gdc_id']]
                input_filesize = int(job_split[header_key_dict['aligned_filesize']])
                slurm_storage_gibibytes = math.ceil(2 * (input_filesize / (1024**3)))
                if slurm_storage_gibibytes > slurm_disk_gibibytes:
                    sys.exit(1)
                fraction_of_resources = slurm_storage_gibibytes / slurm_disk_gibibytes
                slurm_core = math.ceil(fraction_of_resources * num_cores)
                setup_job(db_cred, db_table_name, http_json_base_url,
                          input_gdc_id, job_table_path, job_creation_uuid,
                          json_template_path, runner_cwl_path, runner_repo_hash, s3_load_bucket,
                          scratch_dir, slurm_core, slurm_disk_gibibytes, slurm_mem_mebibytes,
                          slurm_template_path)


if __name__=='__main__':
    main()
