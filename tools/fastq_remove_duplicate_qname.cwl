#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastq_remove_duplicate_qname:5762be5de2178b6078621e09836019106c78b2e07bfdbcf2c74ab147fb844e34
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 5000
    ramMax: 5000
    tmpdirMin: $(Math.ceil(inputs.INPUT.size / 1048576))
    tmpdirMax: $(Math.ceil(inputs.INPUT.size / 1048576))
    outdirMin: $(Math.ceil(inputs.INPUT.size / 1048576))
    outdirMax: $(Math.ceil(inputs.INPUT.size / 1048576))

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

  - id: METRICS
    type: File
    outputBinding:
      glob: "fastq_dup_rm.log"

arguments:
  - valueFrom: |
      ${
        var cmd = [
        "zcat", inputs.INPUT.path, "|",
        "/usr/local/bin/fastq_remove_duplicate_qname", "-", "|",
        "gzip", "-", ">", inputs.INPUT.basename
        ];
        return cmd.join(' ')
      }

baseCommand: [bash, -c]
