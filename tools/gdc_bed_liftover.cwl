#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc_bed_liftover
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  []

outputs:
  - id: INTERVAL_LIST
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.list.gz"
      outputEval: |
        ${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }

  - id: BED
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.bed.gz"
      outputEval: |
        ${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }

  - id: BEDINDEX
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.bed.gz.tbi"
      outputEval: |
        ${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }

baseCommand: [/usr/local/bin/main.sh]
