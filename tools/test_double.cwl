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

arguments:
  - valueFrom: |
      ${
        return "if (( $(echo \"" + inputs.expected_value + " == " + inputs.test_value + "\" | bc -l) )); then exit 0 ; else exit 1 ; fi";
      }

outputs:
  []

baseCommand: [bash, -c]
