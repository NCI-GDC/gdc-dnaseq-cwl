#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:artful-20171019
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.fasta.basename)
        entry: $(inputs.fasta)
      - entryname: $(inputs.fasta_amb.basename)
        entry: $(inputs.fasta_amb)
      - entryname: $(inputs.fasta_ann.basename)
        entry: $(inputs.fasta_ann)
      - entryname: $(inputs.fasta_bwt.basename)
        entry: $(inputs.fasta_bwt)
      - entryname: $(inputs.fasta_dict.basename)
        entry: $(inputs.fasta_dict)
      - entryname: $(inputs.fasta_fai.basename)
        entry: $(inputs.fasta_fai)
      - entryname: $(inputs.fasta_pac.basename)
        entry: $(inputs.fasta_pac)
      - entryname: $(inputs.fasta_sa.basename)
        entry: $(inputs.fasta_sa)
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 500
    ramMax: 500
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1


class: CommandLineTool

inputs:
  - id: fasta
    type: File

  - id: fasta_amb
    type: File

  - id: fasta_ann
    type: File

  - id: fasta_bwt
    type: File

  - id: fasta_dict
    type: File

  - id: fasta_fai
    type: File

  - id: fasta_pac
    type: File

  - id: fasta_sa
    type: File

outputs:
  - id: output
    type: File
    format: "edam:format_1929"
    outputBinding:
      glob: $(inputs.fasta.basename)
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .fai
      - .pac
      - .sa
      - ^.dict

baseCommand: ['true']
