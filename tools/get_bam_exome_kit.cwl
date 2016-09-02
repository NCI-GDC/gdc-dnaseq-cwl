#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/jeremiahsavage/gdc_bam_library_exomekit
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

baseCommand: [python3, -c]
