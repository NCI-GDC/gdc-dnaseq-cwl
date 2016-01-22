#!/usr/bin/env python

###SQL command###
#prod_bioinfo=> \o out.txt
#prod_bioinfo=> select * from harmonized_files where experimental_strategy = 'WXS' and project = 'BLCA'order by case_id;
#prod_bioinfo=> \q
###

import argparse
import os
import subprocess
import sys

from cdis_pipe_utils import pipe_util

def get_caseid_set(sql_file):
    caseid_set = set()
    with open(sql_file, 'r') as sql_file_open:
        for line in sql_file_open:
            if line.startswith('-') or line.startswith(' '):
                continue
            else:
                caseid_str = line.split('|')[2].strip()
                caseid_set.add(caseid_str)
    return caseid_set


def get_gdcid_set(caseid, sql_file):
    gdcid_set = set()
    with open(sql_file, 'r') as sql_file_open:
        for line in sql_file_open:
            if line.startswith('-') or line.startswith(' '):
                continue
            else:
                caseid_str = line.split('|')[2].strip()
                if caseid==caseid_str:
                    gdcid_str = line.split('|')[0].strip()
                    gdcid_set.add(gdcid_str)
    return gdcid_set


def get_bam_name(gdcid, s3_bucket):
    cmd = ['s3cmd','-c','~/.s3cfg.cleversafe', 'ls', s3_bucket+'/'+gdcid+'/', '>', 'out.s3']
    shell_cmd = ' '.join(cmd)
    pipe_util.do_shell_command(shell_cmd, logger)
    with open('out.s3', 'r') as s3_path_open:
        line = s3_path_open.readline()
        line_split = line.split(' ')
        line_path = line_split[-1]
        bam_name = os.path.basename(line_path)
    os.remove('out.s3')
    return bam_name

def write_case_file(caseid, bamurl_set, template_file):
    template_dir = os.path.dirname(template_file)
    out_dir = os.path.join(template_dir, 'slurm_sh')
    os.makedirs(out_dir, exist_ok=True)
    out_file = 'coclean_'+caseid+'.sh'
    out_path = os.path.join(out_dir, out_file)
    out_path_open = open(out_path, 'w')
    with open(template_file, 'r') as template_file_open:
        for line in template_file_open:
            if 'XX_BAM_URL_ARRAY_XX' in line:
                replace_str = ' '.join(sorted(list(bamurl_set)))
                newline = line.replace('XX_BAM_URL_ARRAY_XX', replace_str)
                out_path.write(newline)
            elif 'XX_CASE_ID_XX' in line:
                newline = line.replace('XX_CASE_ID_XX', caseid)
                out_path.write(newline)
            else:
                out_path_open.write(line)
    out_path_open.close()
    return

def main():
    s3_bucket = 's3://tcga_exome_alignment_2'
    parser = argparse.ArgumentParser('make slurm')
    parser.add_argument('--sql_file',
                        required = True,
                        help = 'pulled from harmonized_files'
    )
    parser.add_argument('--template_file',
                        required = True,
                        help = 'slurm template file',
    )

    args = parser.parse_args()
    sql_file = args.sql_file
    template_file = args.template_file
    uuid = 'a_uuid'
    tool_name = 'create_slurm_from_template'
    logger = pipe_util.setup_logging(tool_name, args, uuid)
    
    caseid_set=get_caseid_set(sql_file)

    for caseid in caseid_set:
        gdcid_set = get_gdcid_set(caseid, sql_file)
        bamurl_set = set()
        for gdcid in gdcid_set:
            bam_name = get_bam_name(gdcid, s3_bucket, logger)
            bam_url = s3_bucket+'/'+gdcid+'/'+bam_name
            bamurl_set.add(bam_url)
        write_case_file(caseid, bamurl_set, template_file)
if __name__=='__main__':
    main()
