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

  - id: 3_UTR_txt
    type: ["null", File]
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/3_UTR.txt

  - id: 5_UTR_txt
    type: ["null", File]
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/5_UTR.txt

  - id: Coding_Exon_txt
    type: ["null", File]
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/Coding_Exon.txt

  - id: Intron_txt
    type: ["null", File]
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/Intron.txt

  - id: LINE_txt
    type: ["null", File]
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/LINE.txt

  - id: LTR_txt
    type: ["null", File]
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/LTR.txt

  - id: SINE_txt
    type: ["null", File]
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/SINE.txt

  - id: bed
    type:
      type: array
      items: File
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/bed/*.txt.gz

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

  - id: rmsk_DNA_txt
    type: ["null", File]
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/rmsk_DNA.txt

  - id: rmsk_Simple_repeat_txt
    type: ["null", File]
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/rmsk_Simple_repeat.txt

  - id: rmsk_Unknown_txt
    type: ["null", File]
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/rmsk_Unknown.txt

  - id: scRNA_txt
    type: ["null", File]
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/scRNA.txt

  - id: snRNA_txt
    type: ["null", File]
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/snRNA.txt

  - id: softclip_taglengths_csv
    type: ["null", File]
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/softclip_taglengths.csv

  - id: srpRNA_txt
    type: ["null", File]
    outputBinding:
      glob: $(inputs.sam.nameroot)_features/srpRNA.txt

baseCommand: [/root/mirna/v0.2.7/code/library_stats/alignment_stats.pl]
