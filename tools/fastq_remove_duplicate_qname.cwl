#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
id: fastq_remove_duplicate_qname
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastq_remove_duplicate_qname:de3c1fe6febe4e7a6bdee7638fdffc17f70c8be2602f8f3b25deb2e07d26e16d
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement


inputs:
  INPUT:
    type: File

outputs:
  OUTPUT:
    type: File
    outputBinding:
      glob: $(inputs.INPUT.basename)

  METRICS:
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