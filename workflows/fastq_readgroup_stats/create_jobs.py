#!/usr/bin/env python3

import argparse
import ast
import json
import logging
import math
import os
import sys
import tempfile
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


def generate_runner(job_json_file, queue_data, job_template, temp_dir):
    job_object = job_template.copy()
    for attr, value in queue_data.items():
        if type(job_object[attr]) == dict:
            job_object[attr]['path'] = value
        else:
            job_object[attr] = value
    job_json_path = os.path.join(temp_dir, job_json_file)
    os.makedirs(os.path.dirname(job_json_path),exist_ok=True)
    with open(job_json_path, 'w') as f_open:
        json.dump(job_object, f_open, sort_keys=True, indent=4)
    return


def generate_slurm(job_slurm_file, queue_data, slurm_template_text, temp_dir):
    for attr, value in queue_data.items():
        slurm_template_text = slurm_template_text.replace('${xx_'+attr+'_xx}', str(value))
    job_slurm_path = os.path.join(temp_dir, job_slurm_file)
    os.makedirs(os.path.dirname(job_slurm_path),exist_ok=True)
    with open(job_slurm_path, 'w') as f_open:
        f_open.write(slurm_template_text)
    return


def setup_job(queue_item, temp_dir):
    job_json_file = '/'.join((queue_item['job_creation_uuid'], 'cwl', queue_item['input_bam_gdc_id'] + '.json'))
    job_slurm_file = '/'.join((queue_item['job_creation_uuid'], 'slurm', queue_item['input_bam_gdc_id'] + '.sh'))
    runner_job_cwl_uri = '/'.join((queue_item['runner_job_base_uri'], job_json_file))
    runner_job_slurm_uri = '/'.join((queue_item['runner_job_base_uri'], job_slurm_file))

    runner_json_template = ast.literal_eval(fetch_text(queue_item['runner_json_template_uri']))
    slurm_template_text = fetch_text(queue_item['slurm_template_uri'])

    slurm_core = SLURM_CORE # will eventually be decided by cwl engine at run time per step
    slurm_mem_megabytes = SLURM_MEM # make a model
    slurm_disk_gigabytes = math.ceil(3 * (int(queue_item['input_bam_file_size']) / (1000**3))) #use readgroup, will eventually be decided by cwl engine at run time per step
    queue_item['slurm_resource_cores'] = slurm_core
    queue_item['slurm_resource_mem_megabytes'] = slurm_mem_megabytes
    queue_item['slurm_resource_disk_gigabytes'] = slurm_disk_gigabytes

    queue_item['runner_cwl_branch'] = get_raw_github_branch(queue_item['runner_cwl_uri'])
    queue_item['runner_cwl_repo'] = get_raw_github_repo(queue_item['runner_cwl_uri'])
    queue_item['runner_job_branch'] = get_raw_github_branch(runner_job_cwl_uri)
    queue_item['runner_job_cwl_uri'] = runner_job_cwl_uri
    runner_job_repo = get_raw_github_repo(runner_job_cwl_uri)
    queue_item['runner_job_repo'] = runner_job_repo
    queue_item['runner_job_slurm_uri'] = runner_job_slurm_uri

    generate_slurm(job_slurm_file, queue_item, slurm_template_text, temp_dir)
    del queue_item['runner_job_base_uri']
    del queue_item['runner_json_template_uri']
    del queue_item['scratch_dir']
    del queue_item['slurm_template_uri']
    del queue_item['virtualenv_name']

    generate_runner(job_json_file, queue_item, runner_json_template, temp_dir)
    return


# same as main, but for library usage
def run(queue_json_tempfile, temp_dir):
    job_creation_uuid = str(uuid.uuid4())
    job_creation_dir = os.path.join(temp_dir, job_creation_uuid)
    cwl_dir = os.path.join(temp_dir, job_creation_uuid, 'cwl')
    slurm_dir = os.path.join(temp_dir, job_creation_uuid, 'slurm')
    os.makedirs(cwl_dir)
    os.makedirs(slurm_dir)

    with open(queue_json_tempfile.name,'r') as f:
        f.seek(0)
        queue_dict = json.loads(f.read())

    with tempfile.TemporaryDirectory() as temp_dir:
        for queue_item in queue_dict:
            queue_item['job_creation_uuid'] = job_creation_uuid
            setup_job(queue_item, temp_dir)
        print('os.listdir(temp_dir): %s' % os.listdir(temp_dir))
        return temp_dir, job_creation_uuid

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

    # if not os.path.exists(job_creation_uuid):
    #     os.makedirs(job_creation_uuid)
    #     os.makedirs(cwl_dir)
    #     os.makedirs(slurm_dir)
    # else:
    #     sys.exit(job_creation_uuid + ' exists. Exiting.')

    with open(queue_json, 'r') as f:
        queue_dict = json.loads(f.read())

    temp_dir = tempfile.mkdtemp(dir='.')
    for queue_item in queue_dict:
        queue_item['job_creation_uuid'] = job_creation_uuid
        setup_job(queue_item, temp_dir)
    return


if __name__=='__main__':
    main()
