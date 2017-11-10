#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/mirna-profiler:latest
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.sam.basename)
        entry: $(inputs.sam)
      - entryname: $(inputs.sam.nameroot)_features/miRNA.txt
        entry: $(inputs.stats_miRNA_txt)
      - entryname: $(inputs.sam.nameroot)_features/crossmapped.txt
        entry: $(inputs.stats_crossmapped_txt)
      - entryname: $(inputs.sam.nameroot)_features/isoforms.txt
        entry: $(inputs.stats_isoforms_txt)
  - class: ShellCommandRequirement

class: CommandLineTool

inputs:
  - id: sam
    format: "edam:format_2573"
    type: File
    
  - id: mirbase_db
    type: string
    default: "hg38"
    inputBinding:
      position: 90
      prefix: -m
      shellQuote: false

  - id: genome_version
    type: string
    default: "hg38"
    inputBinding:
      position: 91
      prefix: -u
      shellQuote: false

  - id: species_code
    type: string
    default: "hsa"
    inputBinding:
      position: 92
      prefix: -o
      shellQuote: false

  - id: project_directory
    type: string
    default: "."
    inputBinding:
      position: 93
      prefix: -p
      shellQuote: false

outputs:
  - id: isoforms_quant
    type: File
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/tcga/isoforms.txt
  - id: mirnas_quant
    type: File
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/tcga/mirnas.txt

arguments:
  - valueFrom: "chmod 1777 /tmp"
    position: 0
    shellQuote: false

  - valueFrom: "&& /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --user=mysql --daemonize"
    position: 1
    shellQuote: false

  - valueFrom: "&& /root/mirna/v0.2.7/code/custom_output/tcga/tcga.pl"
    position: 3
    shellQuote: false

baseCommand: []
