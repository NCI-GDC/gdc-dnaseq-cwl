#!/usr/bin/env python3

import argparse
import ast
import json
import logging
import math
import os
import sys
import urllib
import urllib.request
import uuid

#from types import SimpleNamespace

SCRATCH_DIR = '/mnt/SCRATCH'
SLURM_CORE = 8
SLURM_MEM = 50000

def fetch_text(url):
    split = urllib.parse.urlsplit(url)
    scheme, path = split.scheme, split.path
    if scheme in ['http', 'https']:# and self.session is not None:
        try:
            resp = urllib.request.urlopen(url)
            if resp.status == 200:
                read = resp.read()
                if hasattr(read, "decode"):
                    return read.decode("utf-8")
                else:
                    return read
            else:
                sys.exit('bad response: %s' %url)    
        except Exception as e:
            raise RuntimeError(url, e)
    elif scheme == 'file':
        try:
            with open(urllib.request.url2pathname(str(path))) as fp:
                read = fp.read()
            if hasattr(read, "decode"):
                return read.decode("utf-8")
            else:
                return read
        except (OSError, IOError) as e:
            if e.filename == path:
                raise RuntimeError(unicode(e))
            else:
                raise RuntimeError('Error reading %s: %s' % (url, e))
    else:
        raise ValueError('Unsupported scheme in url: %s' % url)
    return


def generate_runner(job_json_file, queue_data, runner_text):
    for attr, value in queue_data.items():
        runner_text = runner_text.replace('${'+attr+'}', value)
    runner_text = runner_text.replace('${thread_count}', str(8))
    runner_dict = ast.literal_eval(runner_text)
    with open(job_json_file, 'w') as f_open:
        json.dump(runner_dict, f_open, sort_keys=True, indent=4)
    return


def generate_slurm(job_slurm_file, queue_data, slurm_template_text):
    for attr, value in queue_data.items():
        slurm_template_text = slurm_template_text.replace('${xx_'+attr+'_xx}', value)
    with open(job_slurm_file, 'w') as f_open:
        f_open.write(slurm_template_text)
    return


def get_raw_github_branch(url):
    runner_cwl_uri_split = urllib.parse.urlsplit(url)
    runner_cwl_branch = runner_cwl_uri_split.path.split('/')[3]
    return runner_cwl_branch


def get_raw_github_repo(url):
    runner_cwl_uri_split = urllib.parse.urlsplit(url)
    if runner_cwl_uri_split.netloc == 'raw.githubusercontent.com':
        git_server = 'www.github.com'
    else:
        sys.exit('unhandled git server: %s' % url)
    git_organization = runner_cwl_uri_split.path.split('/')[1]
    git_repo = runner_cwl_uri_split.path.split('/')[2]
    runner_cwl_repo = runner_cwl_uri_split.scheme + '://' + git_server + '/' + git_organization + '/' + git_repo
    return runner_cwl_repo


def setup_job(queue_item):
    job_json_file = '/'.join((queue_item['job_creation_uuid'], 'cwl', queue_item['input_bam_gdc_id'] + '_alignment.json'))
    job_slurm_file = '/'.join((queue_item['job_creation_uuid'], 'slurm', queue_item['input_bam_gdc_id'] + '_alignment.sh'))
    runner_job_cwl_uri = '/'.join((queue_item['runner_job_base_uri'], job_json_file))
    runner_job_slurm_uri = '/'.join((queue_item['runner_job_base_uri'], job_slurm_file))

    runner_json_template_text = fetch_text(queue_item['runner_json_template_uri'])
    slurm_template_text = fetch_text(queue_item['slurm_template_uri'])

    slurm_core = SLURM_CORE # will eventually be decided by cwl engine at run time per step
    slurm_mem_megabytes = SLURM_MEM # make a model
    slurm_disk_gigabytes = math.ceil(10 * (int(queue_item['input_bam_file_size']) / (1000**3))) #use readgroup, will eventually be decided by cwl engine at run time per step
    queue_item['slurm_resource_cores'] = str(slurm_core)
    queue_item['slurm_resource_mem_megabytes'] = str(slurm_mem_megabytes)
    queue_item['slurm_resource_disk_gigabytes'] = str(slurm_disk_gigabytes)

    queue_item['runner_cwl_branch'] = get_raw_github_branch(queue_item['runner_cwl_uri'])
    queue_item['runner_cwl_repo'] = get_raw_github_repo(queue_item['runner_cwl_uri'])
    queue_item['runner_job_branch'] = get_raw_github_branch(runner_job_cwl_uri)
    queue_item['runner_job_cwl_uri'] = runner_job_cwl_uri
    runner_job_repo = get_raw_github_repo(runner_job_cwl_uri)
    queue_item['runner_job_repo'] = runner_job_repo
    queue_item['runner_job_slurm_uri'] = runner_job_slurm_uri


    generate_runner(job_json_file, queue_item, runner_json_template_text)
    generate_slurm(job_slurm_file, queue_item, slurm_template_text)
    return


def main():
    parser = argparse.ArgumentParser('make slurm and cwl job')
    # Logging flags.
    parser.add_argument('-d', '--debug',
        action = 'store_const',
        const = logging.DEBUG,
        dest = 'level',
        help = 'Enable debug logging.',
    )
    parser.set_defaults(level = logging.INFO)

    parser.add_argument('--queue_json',
                        required=True
    )

    args = parser.parse_args()
    queue_json = args.queue_json

    job_creation_uuid = str(uuid.uuid4())
    cwl_dir = '/'.join((job_creation_uuid, 'cwl'))
    slurm_dir = '/'.join((job_creation_uuid, 'slurm'))

    if not os.path.exists(job_creation_uuid):
        os.makedirs(job_creation_uuid)
        os.makedirs(cwl_dir)
        os.makedirs(slurm_dir)
    else:
        sys.exit(job_creation_uuid + ' exists. Exiting.')

    with open(queue_json, 'r') as f:
        queue_dict = json.loads(f.read())
    for queue_item in queue_dict:
        queue_item['job_creation_uuid'] = job_creation_uuid
        setup_job(queue_item)
    return


if __name__=='__main__':
    main()
