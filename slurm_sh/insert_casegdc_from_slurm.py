#!/usr/bin/env python




import argparse
import glob
import logging
import os
import sys

from cdis_pipe_utils import pipe_util


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

    slurm_script_list = get_slurm_script_list(slurm_script_dir)
    tool_name = 'insert_casegdc_from_slurm'
    logger = pipe_util.setup_logging(tool_name, args, uuid)

    engine = pipe_util.setup_db_with_postgres(uuid, username=psql_username, password = psql_password,
                                              host = psql_host, port = psql_port, db = psql_db)


if __name__=='__main__':
    main()
