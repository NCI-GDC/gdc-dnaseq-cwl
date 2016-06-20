#!/usr/bin/env python


import argparse
import logging
import os
import sys

from cdis_pipe_utils import pipe_util

import psycopg2 

def get_complete_case_list(case_log_bucket, logger):
    home_dir = os.path.expanduser('~')
    complete_case_out_path = os.path.join(home_dir, 'complete_case.out')
    cmd = ['s3cmd', '-c', os.path.join(home_dir, '.s3cfg.cleversafe'), 'ls',
           case_log_bucket+'/', '>', complete_case_out_path]
    shell_cmd = ' '.join(cmd)
    pipe_util.do_shell_command(shell_cmd, logger)
    complete_case_set = set()
    with open(complete_case_out_path, 'r') as f_open:
        for line in f_open:
            line_split = line.split()
            s3_url = line_split[-1].strip()
            db_file = os.path.basename(s3_url)
            case_id, db_ext = os.path.splitext(db_file)
            complete_case_set.add(case_id)
    os.remove(complete_case_out_path)
    return sorted(list(complete_case_set))

def get_bam_url(s3_url, logger):
    home_dir = os.path.expanduser('~')
    out_path = os.path.join(home_dir, 'sample.out')

    cmd = ['s3cmd', '-c', os.path.join(home_dir, '.s3cfg.cleversafe'), 'ls',
           s3_url, '>', out_path]
    shell_cmd = ' '.join(cmd)
    pipe_util.do_shell_command(shell_cmd, logger)
    with open(out_path, 'r') as f_open:
        for line in f_open:
            line_split = line.split()
            s3_url = line_split[-1].strip()
            if s3_url.endswith('.bam'):
                return s3_url
    return None

def get_complete_gdc_url_dict(sample_bam_bucket, logger):
    home_dir = os.path.expanduser('~')
    complete_sample_out_path = os.path.join(home_dir, 'complete_sample.out')
    cmd = ['s3cmd', '-c', os.path.join(home_dir, '.s3cfg.cleversafe'), 'ls',
           sample_bam_bucket+'/', '>', complete_sample_out_path]
    shell_cmd = ' '.join(cmd)
    pipe_util.do_shell_command(shell_cmd, logger)
    complete_gdc_url_dict = dict()
    with open(complete_sample_out_path, 'r') as f_open:
        for line in f_open:
            line_split = line.split()
            s3_url = line_split[-1].strip()
            s3_bam_url = get_bam_url(s3_url, logger)
            gdc_id = os.path.basename(os.path.dirname(s3_url))
            complete_gdc_url_dict[gdc_id] = s3_bam_url
    os.remove(complete_sample_out_path)
    return complete_gdc_url_dict
    


def main():
    parser = argparse.ArgumentParser('update coclean status of complete')
    # Logging flags.
    parser.add_argument('-d', '--debug',
        action = 'store_const',
        const = logging.DEBUG,
        dest = 'level',
        help = 'Enable debug logging.',
    )
    parser.set_defaults(level = logging.INFO)

    parser.add_argument('--sample_bam_bucket',
                        required = True
    )
    parser.add_argument('--case_log_bucket',
                        required = True
    )
    parser.add_argument('--psql_username',
                        required = True
    )
    parser.add_argument('--psql_password',
                        required = True
    )
    parser.add_argument('--psql_host',
                        required = True
    )
    parser.add_argument('--psql_port',
                        required = True
    )
    parser.add_argument('--psql_db',
                        required = True
    )
    parser.add_argument('--table_name',
                        required = True
    )
    parser.add_argument('--uuid',
                        required = True
    )

    args = parser.parse_args()
    case_log_bucket = args.case_log_bucket
    sample_bam_bucket = args.sample_bam_bucket
    psql_username = args.psql_username
    psql_password = args.psql_password
    psql_host = args.psql_host
    psql_port = args.psql_port
    psql_db = args.psql_db
    table_name = args.table_name
    uuid = args.uuid

    tool_name = 'update_casegdc_status'
    logger = pipe_util.setup_logging(tool_name, args, uuid)

    #engine = pipe_util.setup_db(uuid, username=psql_username, password = psql_password,
    #                            host = psql_host, port = psql_port, db = psql_db)

    
    complete_case_list = sorted(get_complete_case_list(case_log_bucket, logger))
    complete_gdc_url_dict = get_complete_gdc_url_dict(sample_bam_bucket, logger)

    try:
        conn = psycopg2.connect(database=psql_db, host=psql_host, password=psql_password,
                                port=psql_port, user=psql_username)
    except Exception as e:
        print('e:{e}'.format(e))
        sys.exit(1)

    cur = conn.cursor()
    case_sql_string = """SELECT case_id, gdc_id FROM %s""" % table_name
    cur.execute(case_sql_string)
    rows = cur.fetchall()
    #print('rows={0}'.format(rows))
    i = 0
    for row in rows:
        case_id = row[0]
        gdc_id = row[1]
        if case_id in complete_case_list and gdc_id in sorted(list(complete_gdc_url_dict.keys())):
            s3_url = complete_gdc_url_dict[gdc_id]
            if s3_url is not None:
                update_string = """ UPDATE %s SET status = 'COMPLETE', output_location = '%s' WHERE case_id = uuid('%s') AND gdc_id = uuid('%s');""" % (table_name, s3_url, case_id, gdc_id)
                print(update_string)
                cur.execute(update_string)
    conn.commit()
    cur.close()
    conn.close()
    print(len(complete_case_list))
    print(len(complete_gdc_url_dict))
    print('i=%s' % i)
if __name__=='__main__':
    main()
