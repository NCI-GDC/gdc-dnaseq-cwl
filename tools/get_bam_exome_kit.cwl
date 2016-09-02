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
      var cmd = "exec(\"import json\\nwith open('/usr/local/share/bam_libraryname_capturekey.json') as data_file: data = json.load(data_file)\\nprint(data['" + inputs.bam + "']['" + inputs.library + "'])\")";
      return cmd
      }

baseCommand: [python, -c]
