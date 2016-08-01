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


def generate_bam_extract(uuid, location, write_path):
    f_open = open(write_path,'w')
    f_open.write('{\n  "urls": [\n    "' + s3 + '"\n  ]\n}')
    f_open.close()
    return


def generate_etl(uuid, etl_json_template_path, alignment_last_step, s3_load_bucket, node_json_dir,
                 job_signpost_json, write_path):
    f_open = open(write_path, 'w')
    with open(etl_json_template_path, 'r') as read_open:
        for line in read_open:
            if 'XX_LAST_STEP_XX' in line:
                newline = line.replace('XX_LAST_STEP_XX', alignment_last_step)
                f_open.write(newline)
            elif 'XX_BAM_SIGNPOST_JSON_XX' in line:
                signpost_json_path = os.path.join(node_json_dir, job_signpost_json)
                newline = line.replace('XX_BAM_SIGNPOST_JSON_XX', signpost_json_path)
                f_open.write(newline)
            elif 'XX_LOAD_BUCKET_XX' in line:
                newline = line.replace('XX_LOAD_BUCKET_XX', s3_load_bucket)
                f_open.write(newline)
            elif 'XX_UUID_XX' in line:
                newline = line.replace('XX_UUID_XX', uuid)
                f_open.write(newline)
            else:
                f_open.write(line)
    f_open.close()
    return

def generate_slurm(uuid, slurm_template_path, db_cred_path, scratch_dir, git_cwl_hash, s3_load_bucket, job_etl_json, node_json_dir,
                   cghub_id, gdc_id, gdc_src_id, write_path):
    f_open = open(write_path, 'w')
    with open(slurm_template_path, 'r') as read_open:
        for line in read_open:
            if 'XX_DB_CRED_PATH_XX' in line:
                newline = line.replace('XX_DB_CRED_PATH_XX', db_cred_path)
                f_open.write(newline)
            elif 'XX_SCRATCH_DIR_XX' in line:
                newline = line.replace('XX_SCRATCH_DIR_XX', scratch_dir)
                f_open.write(newline)
            elif 'XX_GIT_CWL_HASH_XX' in line:
                newline = line.replace('XX_GIT_CWL_HASH_XX', git_cwl_hash)
                f_open.write(newline)
            elif 'XX_CGHUB_ID_XX' in line:
                newline = line.replace('XX_CGHUB_ID_XX', cghub_id)
                f_open.write(newline)
            elif 'XX_ETL_JSON_PATH_XX' in line:
                etl_json_path = os.path.join(node_json_dir, job_etl_json)
                newline = line.replace('XX_ETL_JSON_PATH_XX', etl_json_path)
                f_open.write(newline)
            elif 'XX_GDC_ID_XX' in line:
                newline = line.replace('XX_GDC_ID_XX', )
                f_open.write(newline)
            elif 'XX_GDC_SRC_ID_XX' in line:
                newline = line.replace('XX_GDC_SRC_ID_XX', gdc_src_id)
                f_open.write(newline)
            elif 'XX_S3_LOAD_BUCKET_XX' in line:
                newline = line.replace('XX_S3_LOAD_BUCKET_XX', s3_load_bucket)
                f_open.write(newline)
            elif 'XX_UUID_XX' in line:
                newline = line.replace('XX_UUID_XX', uuid)
                f_open.write(newline)
            else:
                f_open.write(line)
    f_open.close()
    return


def setup_job(db_cred_path, etl_json_template_path, git_cwl_hash, node_json_dir, s3_load_bucket, scratch_dir,
              slurm_template_path, thread_count, alignment_last_step, cghub_id, gdc_id, gdc_src_id, location):
    job_uuid = str(uuid.uuid4())

    job_etl_json = job_uuid + '_etl.json'
    job_signpost_json = job_uuid + '_signpost.json'
    job_slurm = job_uuid + '.sh'

    generate_bam_extract(uuid, location, job_signpost_json_path)
    generate_etl(uuid, slurm_template_path, etl_json_template_path, alignment_last_step, s3_load_bucket, node_json_dir,
                 job_signpost_json, job_etl_json_path)
    generate_slurm(uuid, slurm_template_path, db_cred_path, scratch_dir, git_cwl_hash, s3_load_bucket, job_etl_json, node_json_dir,
                   cghub_id, gdc_id, gdc_src_id, job_slurm)
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

    parser.add_argument('--db_cred_path',
                        required = True
    )
    parser.add_argument('--etl_json_template_path',
                        required = True
    )
    parser.add_argument('--git_cwl_hash',
                        required = True
    )
    parser.add_argument('--job_table_path',
                        required = True
    )
    parser.add_argument('--node_json_dir',
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
    parser.add_argument('--thread_count',
                        required = True
    )

    args = parser.parse_args()

    db_cred_path = args.db_cred_path
    etl_json_template_path = args.etl_json_template_path
    git_cwl_hash = args.git_cwl_hash
    job_table_path = args.job_table_path
    node_json_dir = args.node_json_dir
    s3_load_bucket = args.s3_load_bucket
    scratch_dir = args.scratch_dir
    slurm_template_path = args.slurm_template_path
    thread_count = args.thread_count

    with open(job_table_path, 'r') as job_table_open:
        for job_line in job_table_open:
            if job_line.startswith('program'):
                header_key_dict = read_header(job_line)
            else:
                job_split = job_line.strip().split('\t')
                alignment_last_step = job_split[header_key_dict['alignment_last_step']]
                cat = job_split[header_key_dict['cat']]
                cghub_id = job_split[header_key_dict['cghub_id']]
                gdc_id = job_split[header_key_dict['gdc_id']]
                gdc_src_id = job_split[header_key_dict['gdc_src_id']]
                location = job_split[header_key_dict['location']]
                if cat == 'mkdup_needed':
                    setup_job(db_cred_path, etl_json_template_path, git_cwl_hash, node_json_dir, s3_load_bucket, scratch_dir,
                              slurm_template_path, thread_count, alignment_last_step, cghub_id, gdc_id, gdc_src_id, location)
                

if __name__=='__main__':
    main()










