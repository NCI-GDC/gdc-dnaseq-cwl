#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: alpine
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement

inputs:
  - id: fastq1_path
    type: File
  - id: fastq2_path
    type: File
  - id: readgroup_path
    type: File

outputs:
  - id: output_bam
    type: File
    outputBinding:
      glob: $(  inputs.readgroup_path.path.split('/').slice(-1)[0].slice(0,-10)+"_realign.bam" )

arguments:
    - valueFrom: $(  '"' + inputs.fastq1_path.path.split('/').slice(-1)[0] + '"' )
      position: 1
      shellQuote: false
    - valueFrom: ">"
      position: 2
      shellQuote: false
    - valueFrom: $( inputs.readgroup_path.path.split('/').slice(-1)[0].slice(0,-10)+"_realign.bam" )
      position: 3
      shellQuote: false
    - valueFrom: "&&"
      position: 4
      shellQuote: false
    - valueFrom: echo
      position: 5
      shellQuote: false
    - valueFrom: $(  '"' + inputs.fastq2_path.path.split('/').slice(-1)[0] + '"' )
      position: 6
      shellQuote: false
    - valueFrom: ">>"
      position: 7
      shellQuote: false
    - valueFrom: $( inputs.readgroup_path.path.split('/').slice(-1)[0].slice(0,-10)+"_realign.bam" )
      position: 8
      shellQuote: false
    - valueFrom: "&&"
      position: 9
      shellQuote: false
    - valueFrom: echo
      position: 10
      shellQuote: false
    - valueFrom: $(  '"' + inputs.readgroup_path.path.split('/').slice(-1)[0] + '"' )
      position: 11
      shellQuote: false
    - valueFrom: ">>"
      position: 12
      shellQuote: false
    - valueFrom: $( inputs.readgroup_path.path.split('/').slice(-1)[0].slice(0,-10)+"_realign.bam" )
      position: 13
      shellQuote: false

baseCommand: echo
