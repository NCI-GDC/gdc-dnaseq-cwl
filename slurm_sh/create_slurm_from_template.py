#!/usr/bin/env python

###SQL command###
#prod_bioinfo=> \o out.txt
#prod_bioinfo=> select * from harmonized_files where experimental_strategy = 'WXS' and project = 'BLCA'order by case_id;
#prod_bioinfo=> \q
###

import argparse
import logging
import os
import subprocess
import sys

from cdis_pipe_utils import pipe_util

def get_caseid_set(sql_file):
    caseid_set = set()
    with open(sql_file, 'r') as sql_file_open:
        for line in sql_file_open:
            #print('line=%s' % line)
            if line.startswith('-') or line.startswith('    ') or line.startswith('(') or line.startswith('\n'):
                continue
            else:
                line_split = line.split('|')
                print('line_split=%s' % line_split)
                caseid_str = line_split[2].strip()
                print('caseid_str=%s' % caseid_str)
                caseid_set.add(caseid_str)
    print('caseid_set=%s' % caseid_set)
    return caseid_set


def get_gdcid_set(caseid, sql_file):
    gdcid_set = set()
    with open(sql_file, 'r') as sql_file_open:
        for line in sql_file_open:
            if line.startswith('-') or line.startswith('    ') or line.startswith('(') or line.startswith('\n'):
                continue
            else:
                #print('line=%s' % line)
                caseid_str = line.split('|')[2].strip()
                if caseid==caseid_str:
                    gdcid_str = line.split('|')[0].strip()
                    gdcid_set.add(gdcid_str)
    return gdcid_set


def get_bam_name(gdcid, sql_file):
    with open(sql_file, 'r') as sql_file_open:
        for line in sql_file_open:
            if line.startswith('-') or line.startswith('    ') or line.startswith('(') or line.startswith('\n'):
                continue
            else:
                line_split = line.split('|')
                this_gdcid = line_split[0].strip()
                if gdcid == this_gdcid:
                    bamname = line_split[15].strip()
                    return bamname
    sys.exit('could not find bamname for gdcid: %s' % gdcid)
    return 
                

def get_bam_name_from_s3(gdcid, s3_bucket, logger):
    cmd = ['s3cmd','-c','~/.s3cfg.cleversafe', 'ls', s3_bucket+'/'+gdcid+'/', '>', 'out.s3']
    shell_cmd = ' '.join(cmd)
    pipe_util.do_shell_command(shell_cmd, logger)
    with open('out.s3', 'r') as s3_path_open:
        line = s3_path_open.readline()
        line_split = line.split(' ')
        line_path = line_split[-1].strip()
        bam_name = os.path.basename(line_path)
    os.remove('out.s3')
    return bam_name

def write_case_file(template_file, caseid, bamurl_set, scratch_dir, thread_count):
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
                replace_str = ' '.join(sorted(list(bamurl_set)))
                newline = line.replace('XX_BAM_URL_ARRAY_XX', replace_str)
                out_path_open.write(newline)
            elif 'XX_CASE_ID_XX' in line:
                newline = line.replace('XX_CASE_ID_XX', caseid)
                out_path_open.write(newline)
            elif 'XX_SCRATCH_DIR_XX' in line:
                newline = line.replace('XX_SCRATCH_DIR_XX', scratch_dir)
                out_path_open.write(newline)
            elif 'XX' in line:
                newline = line.replace('XX_THREAD_COUNT_XX', thread_count)
                out_path_open.write(newline)
            else:
                out_path_open.write(line)
    out_path_open.close()
    return


def get_docker_version(gdcid, sql_file):
    with open(sql_file, 'r') as sql_file_open:
        for line in sql_file_open:
            if line.startswith('-') or line.startswith('    ') or line.startswith('(') or line.startswith('\n'):
                continue
            else:
                gdcid_str = line.split('|')[0].strip()
                if gdcid == gdcid_str:
                    docker_tag = line.split('|')[5].strip()
                    version = docker_tag.split(':')[1].split('.')[1]
                    return version
    sys.exit('should not be here')
    return
                

def get_latest_docker_version(bamname, gdc_bamdocker_dict):
    version_set = set()
    for gdcid in sorted(list(gdc_bamdocker_dict.keys())):
        print('gdcid=%s' % gdcid)
        bamname_str = gdc_bamdocker_dict[gdcid][0]
        if bamname == bamname_str:
            version_str = gdc_bamdocker_dict[gdcid][1]
            version = int(version_str)
            if version in version_set:
                sys.exit('version: %s for bamname: %s is present more than once' %(str(version), bamname))
            else:
                version_set.add(version)
    if len(version_set) < 1:
        sys.exit('bamname: %s does not have a version' % (bamname))
    max_version = str(max(version_set))
    return max_version
    
def get_url_from_bamname_version(bamname, latest_version, gdc_bamdocker_dict):
    for gdcid in sorted(list(gdc_bamdocker_dict.keys())):
        this_bamname = gdc_bamdocker_dict[gdcid][0]
        this_docker_version = gdc_bamdocker_dict[gdcid][1]
        if bamname == this_bamname and latest_version == this_docker_version:
            url = 's3://tcga_exome_alignment_2/' + gdcid + '/' + bamname
            return url
    sys.exit('error: couldn\'t find bamname: %s' % bamname)
    return

def remove_duplicate_bam_from_set(bamurl_set, sql_file):
    gdc_bamdocker_dict = dict()
    bamname_list = list()
    for bamurl in bamurl_set:
        bamname = os.path.basename(bamurl)
        gdcid = os.path.basename(os.path.dirname(bamurl))
        docker_version = get_docker_version(gdcid, sql_file)
        bamname_list.append(bamname)
        gdc_bamdocker_dict[gdcid] = [bamname, docker_version]
        bamname_list.append(bamname)
    bamurl_set = set()
    print('bamname_list=%s' % bamname_list)
    for bamname in bamname_list:
        print('bamname=%s' % bamname)
        latest_version=get_latest_docker_version(bamname, gdc_bamdocker_dict)
        url_from_bamname_version=get_url_from_bamname_version(bamname, latest_version, gdc_bamdocker_dict)
        bamurl_set.add(url_from_bamname_version)
    return bamurl_set

def main():
    s3_bucket = 's3://tcga_exome_alignment_2'
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

    args = parser.parse_args()
    sql_file = args.sql_file
    template_file = args.template_file
    scratch_dir = args.scratch_dir
    thread_count = args.thread_count
    uuid = 'a_uuid'
    tool_name = 'create_slurm_from_template'
    logger = pipe_util.setup_logging(tool_name, args, uuid)
    
    caseid_set=get_caseid_set(sql_file)

    for caseid in caseid_set:
        gdcid_set = get_gdcid_set(caseid, sql_file)
        bamurl_set = set()
        for gdcid in gdcid_set:
            bam_name = get_bam_name(gdcid, sql_file)
            bam_url = s3_bucket+'/'+gdcid+'/'+bam_name
            bamurl_set.add(bam_url)
        fixed_bamurl_set=remove_duplicate_bam_from_set(bamurl_set, sql_file)
        write_case_file(template_file, caseid, fixed_bamurl_set, scratch_dir, thread_count)
if __name__=='__main__':
    main()
