#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/jeremiahsavage/bwa

class: CommandLineTool

inputs:
  - id: fastq1_path
    type: File
    inputBinding:
      prefix: --fastq1_path

  - id: fastq2_path
    type: File
    inputBinding:
      prefix: --fastq2_path

  - id: reference_fasta_path
    type: File
    inputBinding:
      prefix: --reference_fasta_path
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa

  - id: readgroup_json_path
    type: File
    inputBinding:
      prefix: --readgroup_json_path

  - id: fastqc_json_path
    type: File
    inputBinding:
      prefix: --fastqc_json_path

  - id: thread_count
    type: int
    inputBinding:
      prefix: --thread_count

outputs:
  []

arguments:
  - valueFrom: |
      ${
      var fastqc_json = JSON.parse(inputs.fastqc_json_path.contents);
      var readlength = fastqc_json[fastq1_path.basename]["Sequence length"];
      var encoding = fastqc_json[fastq1_path.basename]["Encoding"];

      }

baseCommand: [bwa]
