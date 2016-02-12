#!/usr/bin/env python

###SQL command###
#prod_bioinfo=> \o harmonized_files.out
#prod_bioinfo=> select * from harmonized_files where experimental_strategy = 'WXS' and project = 'BLCA' order by case_id, gdc_id;
#prod_bioinfo=> \o wxs_coclean.out
#prod_bioinfo=> select * from wxs_coclean_participantid_gdcid where study = 'TCGA' and disease = 'BLCA' order by case_id, gdc_id;
#prod_bioinfo=> \q
###

import argparse
import csv
import logging
import os
import sys

#from cdis_pipe_utils import pipe_util

                

def write_case_file(template_file, caseid, case_bamurl_dict, scratch_dir, thread_count, git_cwl_hash,
                    db_cred_url, s3_cfg_path):
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
                replace_str = ' '.join(sorted(list(case_bamurl_dict[caseid])))
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
            elif 'XX_DB_CRED_URL_XX' in line:
                newline = line.replace('XX_DB_CRED_URL_XX', db_cred_url)
                out_path_open.write(newline)
            elif 'XX_S3_CFG_PATH_XX' in line:
                newline = line.replace('XX_S3_CFG_PATH_XX', s3_cfg_path)
                out_path_open.write(newline)
            elif 'XX_GIT_CWL_HASH_XX' in line:
                newline = line.replace('XX_GIT_CWL_HASH_XX', git_cwl_hash)
                out_path_open.write(newline)
            else:
                out_path_open.write(line)
    out_path_open.close()
    return

def get_gdcid_bamurl_dict(harmonized_file):
    gdcid_bamurl_dict = dict()
    f_open = open(harmonized_file, 'rt')
    reader = csv.reader(f_open, quotechar='"', delimiter='|',quoting=csv.QUOTE_ALL, skipinitialspace=True)
    for line_split in reader:
        gdc_id = line_split[0]
        s3_location = line_split[18]
        gdcid_bamurl_dict[gdc_id] = s3_location
    return gdcid_bamurl_dict

def get_caseid_gdcid_dict(zhenyu_file):
    caseid_gdcid_dict = dict()
    f_open = open(zhenyu_file, 'rt')
    reader = csv.reader(f_open, quotechar='"', delimiter='|',quoting=csv.QUOTE_ALL, skipinitialspace=True)
    for line_split in reader:
        study = line_split[0]
        disease = line_split[1]
        case_id = line_split[2]
        participant_id = line_split[3]
        gdc_id = line_split[4]
        sample_type = line_split[5]
        if case_id in caseid_gdcid_dict.keys():
            caseid_gdcid_dict[case_id].add(gdc_id)
        else:
            caseid_gdcid_dict[case_id]=set()
            caseid_gdcid_dict[case_id].add(gdc_id)
    return caseid_gdcid_dict

def join_caseid_bamurl(caseid_gdcid_dict, gdcid_bamurl_dict):
    caseid_bamurl_dict = dict()
    for caseid in sorted(list(caseid_gdcid_dict.keys())):
        gdcid_list = sorted(list(caseid_gdcid_dict[caseid]))
        for gdcid in gdcid_list:
            bamurl = gdcid_bamurl_dict[gdcid]
            if caseid in caseid_bamurl_dict.keys():
                caseid_bamurl_dict[caseid].add(bamurl)
            else:
                caseid_bamurl_dict[caseid] = set()
                caseid_bamurl_dict[caseid].add(bamurl)
    return case_bamurl_dict

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

    parser.add_argument('--harmonized_file',
                        required = True,
                        help = 'pulled from harmonized_files'
    )
    parser.add_argument('--zhenyu_file',
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
    parser.add_argument('--db_cred_url',
                        required = True
    )
    parser.add_argument('--s3_cfg_path',
                        required = True
    )
    parser.add_argument('--git_cwl_hash',
                        required = True
    )

    args = parser.parse_args()
    harmonized_file = args.harmonized_file
    zhenyu_file = args.zhenyu_file
    template_file = args.template_file
    scratch_dir = args.scratch_dir
    thread_count = args.thread_count
    db_cred_url = args.db_cred_url
    s3_cfg_path = args.s3_cfg_path
    git_cwl_hash = args.git_cwl_hash
    #uuid = 'a_uuid'
    #tool_name = 'create_slurm_from_template'
    #logger = pipe_util.setup_logging(tool_name, args, uuid)

    caseid_gdcid_dict = get_caseid_gdcid_dict(zhenyu_file)    
    gdcid_bamurl_dict = get_gdcid_bamurl_dict(harmonized_file)
    caseid_bamurl_dict = join_caseid_bamurl(caseid_gdcid_dict, gdcid_bamurl_dict)
    
    for caseid in sorted(list(case_bamurl_dict.keys())):
        write_case_file(template_file, caseid, caseid_bamurl_dict, scratch_dir, thread_count, git_cwl_hash, db_cred_url, s3_cfg_path)
if __name__=='__main__':
    main()
