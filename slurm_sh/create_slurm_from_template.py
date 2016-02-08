#!/usr/bin/env python

###SQL command###
#prod_bioinfo=> \o out.txt
#prod_bioinfo=> select * from harmonized_files where experimental_strategy = 'WXS' and project = 'BLCA'order by case_id;
#prod_bioinfo=> \q
###

import argparse
import logging
import os
import sys

#from cdis_pipe_utils import pipe_util


def get_gdcid_set(caseid, sql_file):
    gdcid_set = set()
    with open(sql_file, 'r') as sql_file_open:
        for line in sql_file_open:
            if line.startswith('-') or line.startswith('    ') or line.startswith('(') or line.startswith('\n'):
                continue
            else:
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
                

def write_case_file(template_file, caseid, qcpass_case_bamurl_dict, scratch_dir, thread_count):
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
    version_gdcid_dict = dict()
    for gdcid in sorted(list(gdc_bamdocker_dict.keys())):
        bamname_str = gdc_bamdocker_dict[gdcid][0]
        if bamname == bamname_str:
            version_str = gdc_bamdocker_dict[gdcid][1]
            version = int(version_str)
            if version in version_gdcid_dict.keys():
                sys.exit('version: %s for bamname: %s is present more than once' %(str(version), bamname))
            else:
                version_gdcid_dict[version]=gdcid
    if len(version_gdcid_dict.keys()) < 1:
        sys.exit('bamname: %s does not have a version' % (bamname))
    max_version = str(max(version_gdcid_dict.keys()))
    max_gdcid = version_gdcid_dict[int(max_version)]
    return max_version, max_gdcid
    

def get_latest_url(gdc_bamdocker_dict, latest_gdcid):
    bamurl = gdc_bamdocker_dict[latest_gdcid][2]
    return bamurl

def get_all_bamurl(case_bamurl_dict):
    all_set = set()
    for caseid in sorted(list(case_bamurl_dict.keys())):
        for bamurl in sorted(list(case_bamurl_dict[caseid])):
            all_set.add(bamurl)
    return all_set

def get_keep_bamurl_set(case_bamurl_dict, sql_file):
    gdc_bamdocker_dict = dict()
    bamname_set = set()
    bamurl_set = get_all_bamurl(case_bamurl_dict)
    for bamurl in sorted(list(bamurl_set)):
        print('bamurl=%s' % bamurl)
        bamname = os.path.basename(bamurl)
        gdcid = os.path.basename(os.path.dirname(bamurl))
        docker_version = get_docker_version(gdcid, sql_file)
        gdc_bamdocker_dict[gdcid] = [bamname, docker_version, bamurl]
        bamname_set.add(bamname)
    bamurl_set = set()
    for bamname in sorted(list(bamname_set)):
        latest_version, latest_gdcid = get_latest_docker_version(bamname, gdc_bamdocker_dict)
        url_from_latest_version = get_latest_url(gdc_bamdocker_dict, latest_gdcid)
        bamurl_set.add(url_from_latest_version)
    return bamurl_set

def get_case_bamurl_dict(sql_file):
    case_bamurl_dict = dict()
    with open(sql_file, 'r') as sql_file_open:
        for line in sql_file_open:
            if line.startswith('-') or line.startswith('    ') or line.startswith('(') or line.startswith('\n'):
                continue
            else:
                line_split = line.split('|')
                caseid = line_split[2].strip()
                bamurl = line_split[18].strip()
                bamurl = bamurl.replace('cleversafe.service.consul/', '')
                if caseid in case_bamurl_dict.keys():
                    case_bamurl_dict[caseid].add(bamurl)
                else:
                    case_bamurl_dict[caseid] = set()
                    case_bamurl_dict[caseid].add(bamurl)
    return case_bamurl_dict

def get_qcfail_set(sql_file):
    fail_set = set()
    with open(sql_file, 'r') as sql_file_open:
        for line in sql_file_open:
            if line.startswith('-') or line.startswith('    ') or line.startswith('(') or line.startswith('\n'):
                continue
            else:
                line_split = line.split('|')
                fail_qc = line_split[17].strip()
                case_id = line_split[2].strip()
                if 't' in fail_qc:
                    case_id = line_split[2].strip()
                    fail_set.add(case_id)
    return fail_set


def reduce_case_set(case_bamurl_dict, keep_bamurl_set):
    reduced_dict = dict()
    for caseid in sorted(list(case_bamurl_dict.keys())):
        original_bamurl_set = case_bamurl_dict[caseid]
        for original_bamurl in original_bamurl_set:
            if original_bamurl in keep_bamurl_set:
                if caseid in reduced_dict:
                    reduced_dict[caseid].add(original_bamurl)
                else:
                    reduced_dict[caseid] = set()
                    reduced_dict[caseid].add(original_bamurl)
    return reduced_dict


def subtract_fail_set(case_bamurl_dict, fail_caseid_set):
    qcpass_case_bamurl_dict = dict()
    for caseid in sorted(list(case_bamurl_dict.keys())):
        if caseid not in fail_caseid_set:
            qcpass_case_bamurl_dict[caseid] = case_bamurl_dict[caseid]
    return qcpass_case_bamurl_dict

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

    args = parser.parse_args()
    sql_file = args.sql_file
    template_file = args.template_file
    scratch_dir = args.scratch_dir
    thread_count = args.thread_count
    db_username = args.db_username
    db_password = args.db_password
    #uuid = 'a_uuid'
    #tool_name = 'create_slurm_from_template'
    #logger = pipe_util.setup_logging(tool_name, args, uuid)

    case_bamurl_dict = get_case_bamurl_dict(sql_file) # gets all BAM files/case, even those with dup
    keep_bamurl_set = get_keep_bamurl_set(case_bamurl_dict, sql_file) # gets the latest version of each BAM
    reduced_case_bamurl_dict = reduce_case_set(case_bamurl_dict, keep_bamurl_set) # uses the latest version to reduce dict
    
    fail_caseid_set = get_qcfail_set(sql_file) # cases where any BAM has qcfail

    qcpass_case_bamurl_dict = subtract_fail_set(reduced_case_bamurl_dict, fail_caseid_set)
    
    for caseid in sorted(list(qcpass_case_bamurl_dict.keys())):
        gdcid_set = get_gdcid_set(caseid, sql_file)
        print('\ngdcid_set=%s' % gdcid_set)
        write_case_file(template_file, caseid, qcpass_case_bamurl_dict, scratch_dir, thread_count, db_username, db_password)
if __name__=='__main__':
    main()
