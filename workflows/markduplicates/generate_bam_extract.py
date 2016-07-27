#!/usr/bin/env python

import os

def main():
    reheader_file = 'reheader.txt'
    fixmate_file = 'fixmate.txt'
    reheader_s3_list = list()
    fixmate_s3_list = list()
    with open(reheader_file, 'r') as f_open:
        for line in f_open:
            line_split = line.split('\t')
            s3url = line_split[12]
            reheader_s3_list.append(s3url)
    with open(fixmate_file, 'r') as f_open:
        for line in f_open:
            line_split = line.split('\t')
            s3url = line_split[12]
            fixmate_s3_list.append(s3url)
    reheader_s3_list = sorted(reheader_s3_list)
    fixmate_s3_list = sorted(fixmate_s3_list)
    
    for s3 in reheader_s3_list:
        outfile = os.path.basename(os.path.dirname(s3)) + '.json'
        o_open = open(outfile,'w')
        o_open.write('{\n  "urls": [\n    "' + s3 + '"\n  ]\n}')
        o_open.close()
                     
    for s3 in fixmate_s3_list:
        outfile = os.path.basename(os.path.dirname(s3)) + '.json'
        o_open = open(outfile,'w')
        o_open.write('{\n  "urls": [\n    "' + s3 + '"\n  ]\n}')
        o_open.close()


if __name__=='__main__':
    main()
