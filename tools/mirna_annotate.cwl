#!/usr/bin/env cwl-runner
$namespaces:
  edam: "http://edamontology.org/"
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/mirna-profiler:ce50c6e2c06f230f16bc84e8152f2b4e30749487db3a98a21989bfdc6823ee30
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.sam.basename)
        entry: $(inputs.sam)
        writable: true
  - class: ShellCommandRequirement

class: CommandLineTool

inputs:
  - id: sam
    format: "edam:format_2573"
    type: File
    
  - id: mirbase
    type: string
    default: "hg38"
    inputBinding:
      position: 90
      prefix: -m
      shellQuote: false

  - id: ucsc_database
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
  - id: output
    format: "edam:format_2573"
    type: File
    outputBinding:
      glob: $(inputs.sam.basename)

arguments:
  - valueFrom: "chmod 1777 /tmp"
    position: 0
    shellQuote: false

  - valueFrom: "&& sudo /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --user=mysql --daemonize"
    position: 1
    shellQuote: false

  - valueFrom: "&& /usr/mirna/v0.2.7/code/annotation/annotate.pl"
    position: 3
    shellQuote: false

  # - valueFrom: "&& chown -R ubuntu:ubuntu /var/spool/cwl"
  #   position: 94
  #   shellQuote: false

baseCommand: []
