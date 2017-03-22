#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:xenial-20161010
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: expected_value
    type: int

  - id: test_value
    type: int

arguments:
  - valueFrom: |
      ${
        return "if [ " + inputs.expected_value + " -eq " + inputs.test_value + " ]; then exit 0 ; else exit 1 ; fi";
      }

outputs:
  []

baseCommand: [bash, -c]
