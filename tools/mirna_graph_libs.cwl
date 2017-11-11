#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/mirna-profiler:latest
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
      position: 93
      prefix: -p
      shellQuote: false

outputs:
  - id: adapter_jpg
    type: File
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/adapter.jpg

  - id: chastity_jpg
    type: File
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/chastity.jpg

  - id: saturation_jpg
    type: File
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/saturation.jpg

  - id: softclip_jpg
    type: File
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/softclip.jpg

  - id: tags_jpg
    type: File
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/tags.jpg

baseCommand: [/root/mirna/v0.2.7/code/library_stats/graph_libs.pl]
