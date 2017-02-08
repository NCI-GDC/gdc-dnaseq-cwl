#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: ubuntu
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement

inputs:
  - id: INPUT
    type:
      type: array
      items: File

  - id: OUTPUT
    type: string

outputs:
  - id: MERGED_OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.OUTPUT)

arguments:
    - valueFrom: |
        ${
          var cmd = "";
          for (var i = 0; i < inputs.INPUT.length; i++) {
            if (i == inputs.INPUT.length - 1) {
              cmd += "cat " + inputs.INPUT[i].path + " >> " + inputs.OUTPUT;
            }
            else {
              cmd += "cat " + inputs.INPUT[i].path + " >> " + inputs.OUTPUT + " && ";
            }
          }
          return cmd
        }

baseCommand: [bash, -c]
