#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/mirna-profiler:70d6ea90ae099de24f0e9099c24ff750b207f740af20865151eafdf6725cc8fe
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.sam.basename)
        entry: $(inputs.sam)
      - entryname: $(inputs.adapter_report.basename)
        entry: $(inputs.adapter_report)
      - entryname: $(inputs.alignment_stats_csv.basename)
        entry: $(inputs.alignment_stats_csv)
      - entryname: $(inputs.chastity_taglengths_csv.basename)
        entry: $(inputs.chastity_taglengths_csv)
      - entryname: $(inputs.filtered_taglengths_csv.basename)
        entry: $(inputs.filtered_taglengths_csv)
      - entryname: $(inputs.softclip_taglengths_csv.basename)
        entry: $(inputs.softclip_taglengths_csv)
  - class: ShellCommandRequirement

class: CommandLineTool

inputs:
  - id: sam
    type: File

  - id: adapter_report
    type: File

  - id: alignment_stats_csv
    type: File

  - id: chastity_taglengths_csv
    type: File

  - id: filtered_taglengths_csv
    type: File

  - id: softclip_taglengths_csv
    type: File

  - id: project_directory
    type: string
    default: "."
    inputBinding:
      position: 90
      prefix: -p
      shellQuote: false

outputs:
  - id: jpgs
    type: Directory
    outputBinding:
      glob: $(inputs.sam.nameroot)_features

baseCommand: [/usr/mirna/v0.2.7/code/library_stats/graph_libs.pl]
