#!/usr/bin/env python

###SQL command###
#prod_bioinfo=> \o out.txt
#prod_bioinfo=> select * from harmonized_files where experimental_strategy = 'WXS' and project = 'BLCA' and docker_tag = 'pipeline:gdc0.513' order by case_id, filename;
#prod_bioinfo=> select * from harmonized_files where experimental_strategy = 'WXS' and project = 'BLCA' order by case_id, filename;
#prod_bioinfo=> \q
###

import argparse
import csv
import logging
import os
import sys

#from cdis_pipe_utils import pipe_util

                

def write_case_file(template_file, caseid, qcpass_case_bamurl_dict, scratch_dir, thread_count, cwl_git_hash):
    template_dir = os.path.dirname(template_file)
    out_dir = os.path.join(template_dir, 'case_slurm_sh')
    os.makedirs(out_dir, exist_ok=True)
    out_file = 'coclean_'+caseid+'.sh'
    out_path = os.path.join(out_dir, out_file)
    print('out_path=%s' % out_path)
    out_path_open = open(out_path, 'w')
    with open(template_file, 'r') as template_file_open:
        for line in template_file_open:
            if 'XX_BAM_URL_ARRAY_XX' in line:
                replace_str = ' '.join(sorted(list(qcpass_case_bamurl_dict[caseid])))
                newline = line.replace('XX_BAM_URL_ARRAY_XX', replace_str)
                out_path_open.write(newline)
            elif 'XX_CASE_ID_XX' in line:
                newline = line.replace('XX_CASE_ID_XX', caseid)
                out_path_open.write(newline)
            elif 'XX_SCRATCH_DIR_XX' in line:
                newline = line.replace('XX_SCRATCH_DIR_XX', scratch_dir)
                out_path_open.write(newline)
            elif 'XX_THREAD_COUNT_XX' in line:
                newline = line.replace('XX_THREAD_COUNT_XX', thread_count)
                out_path_open.write(newline)
            elif 'XX_POSTGRES_USERNAME_XX' in line:
                newline = line.replace('XX_POSTGRES_USERNAME_XX', db_username)
                out_path_open.write(newline)
            elif 'XX_POSTGRES_PASSWORD_XX' in line:
                newline = line.replace('XX_POSTGRES_PASSWORD_XX', db_password)
                out_path_open.write(newline)
            elif 'XX_CWL_GIT_HASH_XX' in line:
                newline = line.replace('XX_CWL_GIT_HASH_XX', cwl_git_hash)
                out_path_open.write(newline)
            else:
                out_path_open.write(line)
    out_path_open.close()
    return

                

def get_case_gdcid_dict(zhenyu_file, zhenyu_program, zhenyu_project):
    case_gdcid_dict = dict()
    f_open = open(zhenyu_file, 'rt')
    reader = csv.reader(f_open, quotechar='"', delimiter=',',quoting=csv.QUOTE_ALL, skipinitialspace=True)
    for line_split in reader:
        program_id = line_split[0]
        project_id = line_split[1]
        case_id = line_split[2]
        gdc_ids = line_split[3]
        good_case = line_split[4]
        if program_id == 'program':
            continue
        else:
            if zhenyu_program == program_id and zhenyu_project == project_id and good_case == 'TRUE':
                gdcid_list = gdc_ids.split(',').strip()
                case_gdcid_dict[case_id] = sorted(gdcid_list)
    return case_gdcid_dict

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

    parser.add_argument('--sql_file',
                        required = True,
                        help = 'pulled from harmonized_files'
    )
    parser.add_argument('--zhenyu_file',
                        required = True
    )
    parser.add_argument('--zhenyu_program',
                        required = True
    )
    parser.add_argument('--zhenyu_project',
                        required = True
    )
    parser.add_argument('--template_file',
                        required = True,
                        help = 'slurm template file',
    )
    parser.add_argument('--scratch_dir',
                        required = True
    )
    parser.add_argument('--thread_count',
                        required = True
    )
    parser.add_argument('--db_username',
                        required = True
    )
    parser.add_argument('--db_password',
                        required = True
    )
    parser.add_argument('--cwl_git_hash',
                        required = True
    )

    args = parser.parse_args()
    sql_file = args.sql_file
    zhenyu_file = args.zhenyu_file
    zhenyu_program = args.zhenyu_program
    zhenyu_project = args.zhenyu_project
    template_file = args.template_file
    scratch_dir = args.scratch_dir
    thread_count = args.thread_count
    db_username = args.db_username
    db_password = args.db_password
    cwl_git_hash = args.cwl_git_hash
    #uuid = 'a_uuid'
    #tool_name = 'create_slurm_from_template'
    #logger = pipe_util.setup_logging(tool_name, args, uuid)

    case_gdcid_dict = get_case_gdcid_dict(zhenyu_file, zhenyu_program, zhenyu_project)    
    gdcid_bamurl_dict = get_gdcid_bamurl_dict(sql_file)
    case_bamurl_dict = join_case_bamurl(case_bamurl_dict, keep_bamurl_set)
    
    for caseid in sorted(list(case_bamurl_dict.keys())):
        write_case_file(template_file, caseid, qcpass_case_bamurl_dict, scratch_dir, thread_count, db_username, db_password, cwl_git_hash)
if __name__=='__main__':
    main()
