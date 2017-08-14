#!/usr/bin/env python3

import argparse
import ast
from datetime import datetime
import json
import logging
import urllib.request

def get_file_data(gdc_id):
    print('gdc_id=%s' % gdc_id)
    request = urllib.request.urlopen('https://gdc-api.nci.nih.gov/legacy/files/'+ gdc_id).read()
    python_request = request.decode().replace('null', 'False')
    file_data = ast.literal_eval(python_request)
    return file_data

def get_queue_object(queue_item, queue_template):
    queue_object = queue_template.copy()
    for attr, value in queue_item.items():
        queue_object[attr] = value
        if attr == 'input_bam_gdc_id':
            file_data = get_file_data(value)
            queue_object['input_bam_file_size'] = file_data['data']['file_size']
            queue_object['input_bam_md5sum'] = file_data['data']['md5sum']
    print(queue_object)
    return queue_object

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

    parser.add_argument('--queue_items_json',
                        required=True
    )
    parser.add_argument('--queue_template_json',
                        required=True
    )

    args = parser.parse_args()
    queue_items_json = args.queue_items_json
    queue_template_json = args.queue_template_json

    with open(queue_items_json, 'r') as f:
        queue_items = json.load(f)
    with open(queue_template_json, 'r') as f:
        queue_template = json.load(f)

    object_list = list()
    for queue_item in queue_items:
        queue_object = get_queue_object(queue_item, queue_template)
        object_list.append(queue_object)

    #consider `date +%s%N`
    outfile = 'jobs_' + datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S.%f') + 'Z.json'
    with open(outfile, 'w') as f:
        json.dump(object_list, f, sort_keys=True, indent=4)
    return

if __name__=='__main__':
    main()
