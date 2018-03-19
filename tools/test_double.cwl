#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bc:1
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: expected_value
    type: double

  - id: test_value
    type: double

stdout: output.txt

arguments:
  - valueFrom: |
      ${
        return "if (( $(echo \"" + inputs.expected_value + " == " + inputs.test_value + "\" | bc -l) )); then printf 1 ; else printf 0 ; fi";
      }

outputs:
  - id: result
    type: boolean
    outputBinding:
      glob: output.txt
      loadContents: true
      outputEval: "$(Boolean(parseInt(self[0].contents)))"

baseCommand: [bash, -c]
