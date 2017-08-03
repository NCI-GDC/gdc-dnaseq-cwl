#!/usr/bin/env python3

import argparse
import sqlite3
import json
import logging
import os
import sys
from collections import defaultdict

def get_readgroup_length_dict(conn, fq_suffix, is_pe):
    query = 'select fastq_name, "Sequence length" from fastqc_data'
    c = conn.cursor()
    readgroup_dict = defaultdict(dict)
    for row in c.execute(query):
        fastq_name = row[0]
        sequence_length = row[1]
        if fastq_name.endswith(fq_suffix):
            readgroup_name = fastq_name.rstrip(fq_suffix)
            readgroup_dict[readgroup_name]['read_length'] = int(sequence_length)
            if is_pe:
                readgroup_dict[readgroup_name]['is_paired_end'] = 'true'
            else:
                readgroup_dict[readgroup_name]['is_paired_end'] = 'false'
    #conn.close()
    return readgroup_dict

def get_readgroup_info_dict(readgroup_dict, conn):
    c = conn.cursor()
    for readgroup in sorted(list(readgroup_dict)):
        query = 'select key, value from readgroups where ID == ' + readgroup
        for row in c.execute(query):
            key = row[0]
            value = row[1]
            readgroup_dict[readgroup][key] = value
    #conn.close()
    return readgroup_dict

def get_normalize_readgroup_list(readgroup_dict):
    readgroup_list = list()
    for readgroup in sorted(list(readgroup_dict)):
        norm_readgroup_dict = dict()
        norm_readgroup_dict['read_group_name'] = readgroup
        norm_readgroup_dict['library_name'] = readgroup_dict[readgroup]['LB']
        norm_readgroup_dict['is_paired_end'] = readgroup_dict[readgroup]['is_paired_end']
        norm_readgroup_dict['submitter_id'] = readgroup_dict[readgroup]['']
        norm_readgroup_dict['read_length'] = readgroup_dict[readgroup]['read_length']
        norm_readgroup_dict['platform'] = 'Illumina'
        norm_readgroup_dict['library_strategy'] = 'WGS'
        norm_readgroup_dict['type'] = 'read_group'
        norm_readgroup_dict['experiment_name'] = readgroup_dict[readgroup]['']
        norm_readgroup_dict['sequencing_center'] = readgroup_dict[readgroup]['CN']
        norm_readgroup_dict['aliquots'] = {'submitter_id': ''}
        readgroup_list.append(norm_readgroup_dict)
    return readgroup_list

def get_readgroups(conn):
    pe_readgroup_dict = get_readgroup_length_dict(conn, '_1.fq', True)
    se_readgroup_dict = get_readgroup_length_dict(conn, '_s.fq', False)
    pe_readgroup_dict = get_readgroup_info_dict(pe_readgroup_dict, conn)
    se_readgroup_dict = get_readgroup_info_dict(se_readgroup_dict, conn)
    pe_normalize_list = get_normalize_readgroup_list(pe_readgroup_dict)
    se_normalize_list = get_normalize_readgroup_list(se_readgroup_dict)
    return pe_normalize_list + se_normalize_list

def write_json_list(normalize_list, gdc_id):
    with open(gdc_id+'.json', 'w') as f_open:
        json.dump(normalize_list, f_open)
    return

def main():
    parser = argparse.ArgumentParser('create json import from sqlite')
    # Logging flags.
    parser.add_argument('-d', '--debug',
        action = 'store_const',
        const = logging.DEBUG,
        dest = 'level',
        help = 'Enable debug logging.',
    )
    parser.set_defaults(level = logging.INFO)

    parser.add_argument('--input_sqlite',
                        required=True
    )
    parser.add_argument('--gdc_id',
                        required=True
    )

    args = parser.parse_args()
    input_sqlite = args.input_sqlite
    gdc_id = args.gdc_id


    with open(input_sqlite, 'r') as f:
        conn = sqlite3.connect(input_sqlite)
        normalize_list = get_readgroups(conn)
        write_json_list(normalize_list, gdc_id)
        

    return


if __name__=='__main__':
    main()
