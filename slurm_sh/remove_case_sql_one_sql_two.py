#!/usr/bin/env python

###SQL command###
#prod_bioinfo=> \o blca_513.txt
#prod_bioinfo=> select * from harmonized_files where experimental_strategy = 'WXS' and project = 'BLCA' and docker_tag = 'pipeline:gdc0.513' order by case_id, filename;
#prod_bioinfo=> \o blca.txt
#prod_bioinfo=> select * from harmonized_files where experimental_strategy = 'WXS' and project = 'BLCA' order by case_id, filename;
#prod_bioinfo=> \q
###

import argparse
import logging
import os
import sys


def get_case_bamname_dict(sql_file):
    case_bamname_dict = dict()
    with open(sql_file, 'r') as sql_file_open:
        for line in sql_file_open:
            if line.startswith('-') or line.startswith('    ') or line.startswith('(') or line.startswith('\n'):
                continue
            else:
                line_split = line.split('|')
                caseid = line_split[2].strip()
                bamname = line_split[15].strip()
                if caseid in case_bamname_dict.keys():
                    case_bamname_dict[caseid].add(bamname)
                else:
                    case_bamname_dict[caseid] = set()
                    case_bamname_dict[caseid].add(bamname)
    return case_bamname_dict


def reduce_case_set(total_case_bam_dict, subset_case_bam_dict):
    case_set = set()
    for caseid in sorted(list(subset_case_bam_dict.keys())):
        if len(total_case_bam_dict[caseid]) == len(subset_case_bam_dict[caseid]):
            case_set.add(caseid)
        else:
            print('removing case: %s' % caseid)
    return case_set

def write_new_sql_subset(case_set, sql_file):
    new_file = sql_file + '.subset'
    outfile_open = open(new_file, 'w')
    with open(sql_file, 'r') as f_open:
        for line in f_open:
            if line.startswith('-') or line.startswith('    ') or line.startswith('(') or line.startswith('\n'):
                continue
            else:
                line_split = line.split('|')
                caseid = line_split[2].strip()
                if caseid in case_set:
                    outfile_open.write(line)
    outfile_open.close()
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

    parser.add_argument('--sql_file_total',
                        required = True
    )
    parser.add_argument('--sql_file_subset',
                        required = True
    )

    args = parser.parse_args()
    sql_file_total = args.sql_file_total
    sql_file_subset = args.sql_file_subset
    #uuid = 'a_uuid'
    #tool_name = 'create_slurm_from_template'
    #logger = pipe_util.setup_logging(tool_name, args, uuid)

    total_case_bam_dict = get_case_bamname_dict(sql_file_subset)
    subset_case_bam_dict = get_case_bamname_dict(sql_file_subset)
    case_set = reduce_case_set(total_case_bam_dict, subset_case_bam_dict) # uses the latest version to reduce dict
    write_new_sql_subset(case_set, sql_file_subset)
if __name__=='__main__':
    main()
