#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/mirna-profiler:bd6f4799a457e0e0fde6dca548801c789656173fe529fd1706dc79adce0085f8
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.sam.basename)
        entry: $(inputs.sam)
        writable: true
      - entryname: $(inputs.adapter_report.basename)
        entry: $(inputs.adapter_report)
        writable: true

class: CommandLineTool

inputs:
  - id: sam
    format: "edam:format_2573"
    type: File

  - id: adapter_report
    type: File

  - id: project_directory
    type: string
    default: "."
    inputBinding:
      position: 93
      prefix: -p

outputs:
  - id: alignment_stats_csv
    type: File
    outputBinding:
      glob: alignment_stats.csv

  - id: features
    type: Directory
    outputBinding:
      glob: $(inputs.sam.nameroot)_features

  # - id: bed
  #   type: Directory
  #   outputBinding:
  #     glob: $(inputs.sam.nameroot)_features/bed

  - id: chastity_taglengths_csv
    type: File
    outputBinding: 
     glob: $(inputs.sam.nameroot)_features/chastity_taglengths.csv

  - id: crossmapped_txt
    type: File
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/crossmapped.txt

  - id: filtered_taglengths_csv
    type: File
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/filtered_taglengths.csv

  - id: isoforms_txt
    type: File
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/isoforms.txt

  - id: miRNA_txt
    type: File
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/miRNA.txt

  - id: mirna_species_txt
    type: File
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/mirna_species.txt

  - id: softclip_taglengths_csv
    type: File
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/softclip_taglengths.csv

baseCommand: [/root/mirna/v0.2.7/code/library_stats/alignment_stats.pl]
