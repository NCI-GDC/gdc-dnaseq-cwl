#!/usr/bin/env python

import argparse
import logging
import os
import sys
import uuid


def read_header(header_line):
    header_split = header_line.strip().split('\t')
    header_key_dict = dict()
    for i, header_column in enumerate(header_split):
        header_key_dict[header_column] = i
    return header_key_dict

def get_parameter_from_file_name(file_name, parameter):
    import json
    import requests
    import uuid
    endpoint = 'https://gdc-api.nci.nih.gov/legacy/files'
    filter = {
        "op": "in",
        "content": {
            "field": "file_name",
            "value": [
                file_name
            ]
        }
    }
    parameters = {'filters':json.dumps(filter)}
    response = requests.get(endpoint, params = parameters)
    if response.status_code == 200:
        response_data = response.json()['data']
        count = response_data['pagination']['count']
        if count == 0:
            return None
        if count > 1:
            print('file_name: %s' % file_name)
            print('response_data:%s' % response_data)
            print('count > 1: %s' % count)
            sys.exit(1)
        else:
            parameter_value = response_data['hits'][0][parameter]
            return parameter_value
    sys.exit(1)
    return

def generate_runner(bam_file_name, db_table_name, gdc_src_id, job_uuid, repo_hash,
                    resource_core_count, resource_disk_bytes, resource_memory_bytes,
                    s3_load_bucket, json_template_path):
    job_json = job_uuid + '.json'
    f_open = open(job_json, 'w')
    with open(json_template_path, 'r') as read_open:
        for line in read_open:
            if 'XX_BAM_SIGNPOST_ID_XX' in line:
                bam_signpost_id = get_parameter_from_file_name(bam_file_name, 'file_id')
                if bam_signpost_id is None:
                    bam_signpost_id = gdc_src_id
                elif bam_signpost_id != gdc_src_id:
                    print('bam_signpost_id: %s' % bam_signpost_id)
                    print('gdc_src_id: %s' % gdc_src_id)
                    print('bam_file_name: %s' % bam_file_name)
                    sys.exit(1)
                newline = line.replace('XX_BAM_SIGNPOST_ID_XX', bam_signpost_id)
                f_open.write(newline)
            elif 'XX_DB_TABLE_NAME_XX' in line:
                newline = line.replace('XX_DB_TABLE_NAME_XX', db_table_name)
                f_open.write(newline)
            elif 'XX_LOAD_BUCKET_XX' in line:
                newline = line.replace('XX_LOAD_BUCKET_XX', s3_load_bucket)
                f_open.write(newline)
            elif 'XX_REPO_HASH_XX' in line:
                newline = line.replace('XX_REPO_HASH_XX', repo_hash)
                f_open.write(newline)
            elif 'XX_RESOURCE_CORE_COUNT_XX' in line:
                newline = line.replace('XX_RESOURCE_CORE_COUNT_XX', resource_core_count)
                f_open.write(newline)
            elif 'XX_UUID_XX' in line:
                newline = line.replace('XX_UUID_XX', job_uuid)
                f_open.write(newline)
            else:
                f_open.write(line)
    f_open.close()
    return

def generate_slurm(bam_file_name, db_table_name, gdc_src_id, job_uuid, node_json_dir,
                   resource_core_count, resource_disk_bytes, resource_memory_bytes,
                   repo_hash, scratch_dir, slurm_template_path):
    job_slurm = job_uuid + '.sh'
    f_open = open(job_slurm, 'w')
    with open(slurm_template_path, 'r') as read_open:
        for line in read_open:
            if 'XX_BAM_SIGNPOST_ID_XX' in line:
                bam_signpost_id = get_parameter_from_file_name(bam_file_name, 'file_id')
                if bam_signpost_id is None:
                    bam_signpost_id = gdc_src_id
                elif bam_signpost_id != gdc_src_id:
                    print('bam_signpost_id: %s' % bam_signpost_id)
                    print('gdc_src_id: %s' % gdc_src_id)
                    print('bam_file_name: %s' % bam_file_name)
                    sys.exit(1)
                newline = line.replace('XX_BAM_SIGNPOST_ID_XX', bam_signpost_id)
                f_open.write(newline)
            elif 'XX_DB_TABLE_NAME_XX' in line:
                newline = line.replace('XX_DB_TABLE_NAME_XX', db_table_name)
                f_open.write(newline)
            elif 'XX_JSON_PATH_XX' in line:
                json_path = os.path.join(node_json_dir, job_uuid + ".json")
                newline = line.replace('XX_JSON_PATH_XX', json_path)
                f_open.write(newline)
            elif 'XX_REPO_HASH_XX' in line:
                newline = line.replace('XX_REPO_HASH_XX', repo_hash)
                f_open.write(newline)
            elif 'XX_RESOURCE_CORE_COUNT_XX' in line:
                newline = line.replace('XX_RESOURCE_CORE_COUNT_XX', resource_core_count)
                f_open.write(newline)
            elif 'XX_RESOURCE_MEMORY_MEBIBYTES_XX' in line:
                memory_mebibytes = resource_memory_bytes / 1024 / 1024
                newline = line.replace('XX_RESOURCE_MEMORY_MEBIBYTES_XX', memory_mebibytes)
                f_open.write(newline)
            elif 'XX_RESOURCE_DISK_MEBIBYTES_XX' in line:
                disk_mebibytes = resource_disk_bytes / 1024 / 1024
                newline = line.replace('XX_RESOURCE_DISK_MEBIBYTES_XX', disk_mebibytes)
                f_open.write(newline)
            elif 'XX_SCRATCH_DIR_XX' in line:
                newline = line.replace('XX_SCRATCH_DIR_XX', scratch_dir)
                f_open.write(newline)
            elif 'XX_UUID_XX' in line:
                newline = line.replace('XX_UUID_XX', job_uuid)
                f_open.write(newline)
            else:
                f_open.write(line)
    f_open.close()
    return

def setup_job(bam_file_name, db_table_name, gdc_src_id, node_json_dir, repo_hash,
              resource_core_count, resource_disk_bytes, resource_memory_bytes,
              s3_load_bucket, scratch_dir, json_template_path, slurm_template_path):
    job_uuid = str(uuid.uuid4())

    generate_runner(bam_file_name, db_table_name, gdc_src_id, job_uuid, repo_hash, s3_load_bucket,
                    json_template_path)
    generate_slurm(bam_file_name, db_table_name, gdc_src_id, job_uuid, node_json_dir, repo_hash, scratch_dir, 
                   slurm_template_path)
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
    parser.add_argument('--resource_core_count',
                        type = int,
                        required = True
    )
    parser.add_argument('--resource_disk_bytes',
                        type = int,
                        required = True
    )
    parser.add_argument('--resource_memory_bytes',
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

    db_table_name = args.db_table_name
    job_table_path = args.job_table_path
    json_template_path = args.json_template_path
    node_json_dir = args.node_json_dir
    repo_hash = args.repo_hash
    resource_core_count = args.resource_core_count
    resource_disk_bytes = args.resource_disk_bytes
    resource_memory_bytes = args.resource_memory_bytes
    s3_load_bucket = args.s3_load_bucket
    scratch_dir = args.scratch_dir
    slurm_template_path = args.slurm_template_path

    with open(job_table_path, 'r') as job_table_open:
        for job_line in job_table_open:
            if job_line.startswith('program'):
                header_key_dict = read_header(job_line)
            else:
                job_split = job_line.strip().split('\t')
                cat = job_split[header_key_dict['cat']]
                gdc_src_id = job_split[header_key_dict['gdc_src_id']]
                s3_location = job_split[header_key_dict['location']]
                gdc_realign_file_name = os.path.basename(s3_location)
                bam_file_name = gdc_realign_file_name.replace('_gdc_realn','')
                if cat == 'realign_needed':
                    setup_job(bam_file_name, db_table_name, gdc_src_id, node_json_dir, repo_hash,
                              resource_core_count, resource_disk_bytes, resource_memory_bytes,
                              s3_load_bucket, scratch_dir, json_template_path, slurm_template_path)
                

if __name__=='__main__':
    main()
