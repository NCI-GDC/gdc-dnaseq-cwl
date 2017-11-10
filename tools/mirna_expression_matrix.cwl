#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/mirna-profiler:latest
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.stats_mirna_species_txt.basename)
        entry: $(inputs.stats_mirna_species_txt)
  - class: ShellCommandRequirement

class: CommandLineTool

inputs:
  - id: mirbase_db
    type: string
    default: "hg38"
    inputBinding:
      position: 90
      prefix: -m
      shellQuote: false

  - id: project_directory
    type: string
    default: "."
    inputBinding:
      position: 93
      prefix: -p
      shellQuote: false

  - id: species_code
    type: string
    default: "hsa"
    inputBinding:
      position: 92
      prefix: -o
      shellQuote: false

  - id: stats_mirna_species_txt
    type: File

outputs:
  - id: expn_matrix_txt
    type: File
    outputBinding:
      glob: expn_matrix.txt

  - id: expn_matrix_norm_txt
    type: File
    outputBinding:
      glob: expn_matrix_norm.txt

  - id: expn_matrix_norm_log_txt
    type: File
    outputBinding:
      glob: expn_matrix_norm_log.txt

arguments:
  - valueFrom: "chmod 1777 /tmp"
    position: 0
    shellQuote: false

  - valueFrom: "&& /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --user=mysql --daemonize"
    position: 1
    shellQuote: false

  - valueFrom: "&& /root/mirna/v0.2.7/code/library_stats/expression_matrix.pl"
    position: 3
    shellQuote: false

baseCommand: []
