#!/usr/bin/env python

###SQL command###
#prod_bioinfo=> \o out.txt
#prod_bioinfo=> select * from harmonized_files where experimental_strategy = 'WXS' and project = 'BLCA'order by case_id;
#prod_bioinfo=> \q
###

import argparse
import os
import sys

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

def main():
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

    
    caseid_set=get_caseid_set(sql_file)

if __name__=='__main__':
    main()
