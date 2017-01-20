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
  - id: output_readgroup
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.readgroup"
      outputEval: $( self.sort(function(a,b) { return a.location > b.location }) )

arguments:
  - valueFrom: ".readgroup"
    position: 1
    shellQuote: false

  - valueFrom: "|"
    position: 3
    shellQuote: false

  - valueFrom: "xargs"
    position: 4
    shellQuote: false

  - valueFrom: "touch"
    position: 5
    shellQuote: false

baseCommand: grep
