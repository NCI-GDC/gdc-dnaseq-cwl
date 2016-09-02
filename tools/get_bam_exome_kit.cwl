#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: python:3.5.2-alpine
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: bam
    type: string

  - id: bam_library_capturekey
    type: File
    format:

  - id: library
    type: string

outputs:
  - id: exome_kit
    type: File
    outputBinding:
      glob: $(inputs.library + ".kit")

stdout: $(inputs.library + ".kit")

arguments:
  - valueFrom: |
      ${
      var cmd = "exec(\"import json\\nwith open('" + inputs.bam_library_capturekey.path + "') as data_file: data = json.load(data_file)\\nprint(data['" + inputs.bam + "']['" + inputs.library + "'])\")";
      return cmd
      }

baseCommand: [python, -c]
