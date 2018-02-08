#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/mirna-profiler:70d6ea90ae099de24f0e9099c24ff750b207f740af20865151eafdf6725cc8fe
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.sam.basename)
        entry: $(inputs.sam)
      - entryname: $(inputs.stats_miRNA_txt.basename)
        entry: $(inputs.stats_miRNA_txt)
      - entryname: $(inputs.stats_crossmapped_txt.basename)
        entry: $(inputs.stats_crossmapped_txt)
      - entryname: $(inputs.stats_isoforms_txt.basename)
        entry: $(inputs.stats_isoforms_txt)
  - class: ShellCommandRequirement

class: CommandLineTool

inputs:
  - id: genome_version
    type: string
    default: "hg38"
    inputBinding:
      position: 90
      prefix: -g
      shellQuote: false

  - id: mirbase_db
    type: string
    default: "hg38"
    inputBinding:
      position: 91
      prefix: -m
      shellQuote: false

  - id: project_directory
    type: string
    default: "."
    inputBinding:
      position: 92
      prefix: -p
      shellQuote: false

  - id: species_code
    type: string
    default: "hsa"
    inputBinding:
      position: 93
      prefix: -o
      shellQuote: false

  - id: sam
    format: "edam:format_2573"
    type: File
    
  - id: stats_miRNA_txt
    type: File

  - id: stats_crossmapped_txt
    type: File

  - id: stats_isoforms_txt
    type: File

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
