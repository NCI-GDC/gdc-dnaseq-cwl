#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:artful-20171019
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.vcf.basename)
        entry: $(inputs.vcf)
      - entryname: $(inputs.vcf_index.basename)
        entry: $(inputs.vcf_index)
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
  - id: vcf
    type: File

  - id: vcf_index
    type: File

outputs:
  - id: output
    type: File
    format: "edam:format_3016"
    outputBinding:
      glob: $(inputs.vcf.basename)
    secondaryFiles:
      - .tbi

baseCommand: "true"
