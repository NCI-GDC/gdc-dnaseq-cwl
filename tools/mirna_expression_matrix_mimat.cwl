#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/mirna-profiler:ce50c6e2c06f230f16bc84e8152f2b4e30749487db3a98a21989bfdc6823ee30
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.stats_crossmapped_txt.basename)
        entry: $(inputs.stats_crossmapped_txt)
      - entryname: $(inputs.stats_mirna_txt.basename)
        entry: $(inputs.stats_mirna_txt)
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
      position: 91
      prefix: -p
      shellQuote: false

  - id: species_code
    type: string
    default: "hsa"
    inputBinding:
      position: 92
      prefix: -o
      shellQuote: false

  - id: stats_crossmapped_txt
    type: File

  - id: stats_mirna_txt
    type: File

outputs:
  - id: expn_matrix_mimat_txt
    type: File
    outputBinding:
      glob: expn_matrix_mimat.txt

  - id: expn_matrix_mimat_norm_txt
    type: File
    outputBinding:
      glob: expn_matrix_mimat_norm.txt

  - id: expn_matrix_mimat_norm_log_txt
    type: File
    outputBinding:
      glob: expn_matrix_mimat_norm_log.txt

arguments:
  - valueFrom: "sudo chmod 1777 /tmp"
    position: 0
    shellQuote: false

  - valueFrom: "&& sudo /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --user=mysql --daemonize"
    position: 1
    shellQuote: false

  - valueFrom: "&& /usr/mirna/v0.2.7/code/library_stats/expression_matrix_mimat.pl"
    position: 3
    shellQuote: false

baseCommand: []
