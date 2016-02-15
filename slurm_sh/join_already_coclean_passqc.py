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

def get_harmonized_gdcid(harmonized_file):
    gdcid_set = set()
    f_open = open(harmonized_file, 'rt')
    reader = csv.reader(f_open, quotechar='"', delimiter='|',quoting=csv.QUOTE_ALL, skipinitialspace=True)
    for line_split in reader:
        gdc_id = line_split[3].strip()
        gdcid_set.add(gdc_id)
    return gdcid_set

def get_passqc_gdcid(passqc_file):
    gdcid_set = set()
    f_open = open(passqc_file, 'rt')
    reader = csv.reader(f_open, quotechar='"', delimiter='|',quoting=csv.QUOTE_ALL, skipinitialspace=True)
    for line_split in reader:
        gdc_id = line_split[4].strip()
        gdcid_set.add(gdc_id)
    return gdcid_set

def join_two_sets(seta, setb):
    joined_set = set()
    for seta_item in sorted(list(seta)):
        if seta_item in setb:
            joined_set.add(seta_item)
    return joined_set

def main():
    parser = argparse.ArgumentParser('join two tables')
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
    parser.add_argument('--passqc_file',
                        required = True
    )

    args = parser.parse_args()
    harmonized_file = args.harmonized_file
    passqc_file = args.passqc_file

    passqc_gdcid_set = get_passqc_gdcid(passqc_file)    
    harmonized_gdcid_set = get_harmonized_gdcid(harmonized_file)
    harmo_pass_gdcid_set = join_two_sets(passqc_gdcid_set, harmonized_gdcid_set)
    f_open = open('qcpass_harmonized_gdcid.txt','w')
    for gdcid in sorted(list(harmo_pass_gdcid_set)):
        f_open.write(gdcid+'\n')
    f_open.close()
    return

if __name__=='__main__':
    main()
