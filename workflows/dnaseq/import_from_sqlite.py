#!/usr/bin/env python3

import argparse
import sqlite3
import json
import logging
import os
import sys
from collections import defaultdict

def get_readgroup_length_dict(conn, fq_suffix, is_pe):
    readgroup_dict = defaultdict(dict)
    c = conn.cursor()
    test_query = 'SELECT count(*) FROM sqlite_master WHERE type="table" AND name="fastqc_data"'
    result = c.execute(test_query).fetchone()[0]
    if result == 1:
        query = 'select fastq_name, "Sequence length" from fastqc_data'
        for row in c.execute(query):
            fastq_name = row[0]
            sequence_length = int(row[1])
            if fastq_name.endswith(fq_suffix):
                readgroup_name = '_'.join(fastq_name.split('_')[:-1])
                readgroup_dict[readgroup_name]['read_length'] = sequence_length
                if is_pe:
                    readgroup_dict[readgroup_name]['is_paired_end'] = 'true'
                else:
                    readgroup_dict[readgroup_name]['is_paired_end'] = 'false'
        #conn.close()
        return readgroup_dict
    test_query = 'SELECT count(*) FROM sqlite_master WHERE type="table" AND name="fastqc_data_Basic_Statistics"'
    result = c.execute(test_query).fetchone()[0]
    if result == 1:
        query = 'select fastq_path, Value from fastqc_data_Basic_Statistics where "Measure" = "Sequence length"'
        for row in c.execute(query):
            fastq_path = row[0]
            sequence_length = row[1]
            fastq_name = os.path.basename(fastq_path)
            if fastq_name.endswith(fq_suffix):
                readgroup_name = '_'.join(fastq_name.split('_')[:-1])
                readgroup_dict[readgroup_name]['read_length'] = sequence_length
                if is_pe:
                    readgroup_dict[readgroup_name]['is_paired_end'] = 'true'
                else:
                    readgroup_dict[readgroup_name]['is_paired_end'] = 'false'
        #conn.close()
        return readgroup_dict
    sys.exit('no recognized test query')
    return
            

def get_readgroup_info_dict(readgroup_dict, conn):
    c = conn.cursor()
    for readgroup in sorted(list(readgroup_dict)):
        query = 'select key, value from readgroups where "ID" = "' + readgroup + '"'
        for row in c.execute(query):
            key = row[0]
            value = row[1]
            readgroup_dict[readgroup][key] = value
    #conn.close()
    return readgroup_dict

def get_normalize_readgroup_list(readgroup_dict):
    readgroup_list = list()
    #print(json.dumps(readgroup_dict, indent=4, sort_keys=True))
    for readgroup in sorted(list(readgroup_dict)):
        if readgroup == 'default':
            continue
        norm_readgroup_dict = dict()
        norm_readgroup_dict['read_group_name'] = readgroup
        norm_readgroup_dict['library_name'] = readgroup_dict[readgroup]['LB']
        norm_readgroup_dict['is_paired_end'] = readgroup_dict[readgroup]['is_paired_end']
        norm_readgroup_dict['submitter_id'] = False #readgroup_dict[readgroup]['']
        norm_readgroup_dict['read_length'] = readgroup_dict[readgroup]['read_length']
        norm_readgroup_dict['platform'] = 'Illumina'
        norm_readgroup_dict['library_strategy'] = 'WGS'
        norm_readgroup_dict['type'] = 'read_group'
        norm_readgroup_dict['experiment_name'] = False # readgroup_dict[readgroup]['']
        if 'CN' in readgroup_dict[readgroup]:
            norm_readgroup_dict['sequencing_center'] = readgroup_dict[readgroup]['CN']
            prev_CN = readgroup_dict[readgroup]['CN']
        else:
            norm_readgroup_dict['sequencing_center'] = prev_CN
        norm_readgroup_dict['aliquots'] = {'submitter_id': ''}
        readgroup_list.append(norm_readgroup_dict)
    return readgroup_list

def get_readgroups(conn):
    pe_readgroup_dict = get_readgroup_length_dict(conn, ('_1.fq', '_1.fq.gz'), True)
    se_readgroup_dict = get_readgroup_length_dict(conn, ('_s.fq', '_s.fq.gz'), False)
    pe_readgroup_dict = get_readgroup_info_dict(pe_readgroup_dict, conn)
    se_readgroup_dict = get_readgroup_info_dict(se_readgroup_dict, conn)
    pe_normalize_list = get_normalize_readgroup_list(pe_readgroup_dict)
    se_normalize_list = get_normalize_readgroup_list(se_readgroup_dict)
    return pe_normalize_list + se_normalize_list

def write_json_list(normalize_list, gdc_id):
    with open(gdc_id+'.json', 'w') as f_open:
        json.dump(normalize_list, f_open, indent=4, sort_keys=True)
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
        conn.close()
        write_json_list(normalize_list, gdc_id)
        

    return


if __name__=='__main__':
    main()
