#!/usr/bin/env python




import argparse
import glob
import logging
import os
import sys

from cdis_pipe_utils import pipe_util


def get_slurm_script_list(slurm_script_dir):
    coclean_slurm_list = glob.glob(os.path.join(slurm_script_dir, 'coclean_*.sh'))
    return coclean_slurm_list


def get_caseid_from_slurm(slurm_script_path):
    with open(slurm_script_path, 'r') as f_open:
        for line in f_open:
            if line.startswith('CASE_ID'):
                line_split = line.split('=')
                case_id = line_split[1].strip('"')
                return case_id
    sys.exit('Could not find CASE_ID for %s' % slurm_script_path)
    return

def get_gdc_bam_dict_from_slurm(slurm_script_path):
    with open(slurm_script_path, 'r') as f_open:
        for line in f_open:
            if line.startswith('BAM_URL_ARRAY='):
                bam_url_array = line.split('=')[1].strip('"').split(' ')
                gdc_bam_dict = dict()
                for bam_url in bam_url_array:
                    bamname = os.path.basename(bam_url)
                    gdc_id = os.path.basename(os.path.dirname(bam_url))
                    gdc_bam_dict[gdc_id] = bamname
                return gdc_bam_dict
    sys.exit('Could not find BAM_URL_ARRAY for %s' % slurm_script_path)
    return


def main():
    parser = argparse.ArgumentParser('insert rows into table based on slurm scripts')
    # Logging flags.
    parser.add_argument('-d', '--debug',
        action = 'store_const',
        const = logging.DEBUG,
        dest = 'level',
        help = 'Enable debug logging.',
    )
    parser.set_defaults(level = logging.INFO)

    parser.add_argument('--slurm_script_dir',
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
    parser.add_argument('--psql_tablename',
                        required = True
    )
    parser.add_argument('--uuid',
                        required = True
    )

    args = parser.parse_args()
    slurm_script_dir = args.slurm_script_dir
    psql_username = args.psql_username
    psql_password = args.psql_password
    psql_host = args.psql_host
    psql_port = args.psql_port
    psql_db = args.psql_db
    uuid = args.uuid

    tool_name = 'insert_casegdc_from_slurm'
    logger = pipe_util.setup_logging(tool_name, args, uuid)

    engine = pipe_util.setup_db_with_postgres(uuid, username=psql_username, password = psql_password,
                                              host = psql_host, port = psql_port, db = psql_db)

    
    slurm_script_list = get_slurm_script_list(slurm_script_dir)
    for slurm_script_path in slurm_script_list:
        case_id = get_caseid_from_slurm(slurm_script_path)
        gdc_bam_dict = get_gdc_bam_dict_from_slurm(slurm_script_path)
    
if __name__=='__main__':
    main()
