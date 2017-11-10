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
  - id: stats_alignment_stats_csv
    type: File

  - id: sam
    type: File

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

baseCommand: [/root/mirna/v0.2.7/code/library_stats/graph_libs.pl]
