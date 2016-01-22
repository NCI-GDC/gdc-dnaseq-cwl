#!/usr/bin/env python


import argparse
import os
import sys

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

    


if __name__=='__main__':
    main()
