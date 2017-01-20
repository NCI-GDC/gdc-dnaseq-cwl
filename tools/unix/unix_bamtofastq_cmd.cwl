#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: alpine
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement

inputs:
  - id: bam_path
    type: File
    inputBinding:
      position: 2

outputs:
  - id: output_fastq1
    type:
      type: array
      items: File
    outputBinding:
      glob: "*_1.fq"
      outputEval: $( self.sort(function(a,b) { return a.location > b.location }) )

  - id: output_fastq2
    type:
      type: array
      items: File
    outputBinding:
      glob: "*_2.fq"
      outputEval: $( self.sort(function(a,b) { return a.location > b.location }) )

arguments:
  - valueFrom: ".fq"
    position: 1
    shellQuote: false
  - valueFrom: "|"
    position: 4
    shellQuote: false
  - valueFrom: "xargs"
    position: 5
    shellQuote: false
  - valueFrom: "touch"
    position: 6
    shellQuote: false

baseCommand: grep
