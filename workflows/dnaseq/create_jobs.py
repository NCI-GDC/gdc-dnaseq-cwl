#!/usr/bin/env python3

import argparse
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

class AttributeDict(dict): 
    __getattr__ = dict.__getitem__
    __setattr__ = dict.__setitem__


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


def generate_runner(job_creation_uuid, job_json, queue_data, runner_text, slurm_core, slurm_mem_megabytes, slurm_storage_gigabytes):
    runner_template = json.loads(runner_text, object_hook=lambda d: AttributeDict(**d))
    for attr, value in queue_data.items():
        if attr == 'db_cred':
             setattr(runner_template.db_cred, 'path', value)
        elif attr == 'runner_cwl_branch':
            runner_cwl_branch = ''
            setattr(runner_template, attr, runner_cwl_branch)
        elif attr == 'runner_cwl_repo':
            runner_cwl_repo = ''
            setattr(runner_template, attr, runner_cwl_repo)
        elif attr == 'runner_job_branch':
            runner_job_branch = ''
            setattr(runner_template, attr, runner_job_branch)
        elif attr == 'runner_job_cwl_uri':
            runner_job_cwl_uri = ''
            setattr(runner_template, attr, runner_job_cwl_uri)
        elif attr == 'runner_job_repo':
            runner_job_repo = ''
            setattr(runner_template, attr, runner_job_repo)
        elif attr == 'runner_job_slurm_uri':
            runner_job_slurm_uri = ''
            setattr(runner_template, attr, runner_job_slurm_uri)
        else:
            try:
                hasattr(runner_template, attr)
                setattr(runner_template, attr, value)
            except KeyError:
                continue
    setattr(runner_template, 'thread_count', '8')
    with open(job_json, 'w') as f_open:
        json.dump(runner_template, f_open, sort_keys=True, indent=4)

    return


def generate_slurm(job_creation_uuid, job_slurm, queue_data, slurm_template_text, slurm_core, slurm_mem_megabytes, slurm_storage_gigabytes):
    f_open = open(job_slurm, 'w')

    for attr, value in queue_data.items():
        print(attr, value)
        slurm_template_text = slurm_template_text.replace('${xx_'+attr+'_xx}', value)

    with open(job_slurm, 'w') as f_open:
        f_open.write(slurm_template_text)
    return


def setup_job(job_creation_uuid, queue_item):
    job_json = '/'.join((job_creation_uuid, 'cwl', queue_item['input_bam_gdc_id'] + '_alignment.json'))
    job_slurm = '/'.join((job_creation_uuid, 'slurm', queue_item['input_bam_gdc_id'] + '_alignment.sh'))
    json_uri = '/'.join((queue_item['runner_job_base_uri'], job_json))

    runner_json_template_text = fetch_text(queue_item['runner_json_template_uri'])
    slurm_template_text = fetch_text(queue_item['slurm_template_uri'])

    slurm_core = SLURM_CORE # will eventually be decided by cwl engine at run time per step
    slurm_mem_megabytes = SLURM_MEM # make a model
    slurm_storage_gigabytes = math.ceil(10 * (int(queue_item['input_bam_file_size']) / (1000**3))) #use readgroup_count, will eventually be decided by cwl engine at run time per step
    generate_runner(job_creation_uuid, job_json, queue_item, runner_json_template_text, slurm_core, slurm_mem_megabytes, slurm_storage_gigabytes)
    generate_slurm(job_creation_uuid, job_slurm, queue_item, slurm_template_text, slurm_core, slurm_mem_megabytes, slurm_storage_gigabytes)
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
        setup_job(job_creation_uuid, queue_item)
    return


if __name__=='__main__':
    main()
