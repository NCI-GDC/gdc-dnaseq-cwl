#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/jeremiahsavage/fastq_remove_duplicate_qname
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    format: "edam:format_2182"

outputs:
  - id: OUTPUT
    type: File
    format: "edam:format_2182"
    outputBinding:
      glob: $(inputs.INPUT.basename)

arguments:
  - valueFrom: |
      ${
        var cmd = [
        "zcat", inputs.INPUT.path, "|",
        "/usr/local/bin/fastq_remove_duplicate_qname", "-", "|"
        "gzip", "-", ">", input.INPUT.basename
        ];
        return cmd.join(' ')
      }

baseCommand: [bash, -c]
