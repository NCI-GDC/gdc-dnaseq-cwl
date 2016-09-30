#!/usr/bin/env cwl-runner

cwlVersion: "cwl:draft-3"

description: |
  Usage:  cwl-runner <this-file-path> XXXX
  Options:
    --bam_path       input bam path
    --uuid           uuid

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/cocleaning-tool

class: CommandLineTool

inputs:
  - id: input_bam_path
    type:
      type: array
      items: File
      inputBinding:
        prefix: --bam_path
      secondaryFiles:
        - ^.bai

  - id: known_indel_vcf_path
    type: File
    inputBinding:
      prefix: --known_indel_vcf_path
    secondaryFiles:
      - .tbi

  - id: reference_fasta_path
    type: File
    inputBinding:
      prefix: --reference_fasta_path
    secondaryFiles:
      - ^.dict
      - .fai

  - id: target_intervals_path
    type: File
    inputBinding:
      prefix: --intervals_path
      
  - id: uuid
    type: string
    inputBinding:
      prefix: --uuid

outputs:
  - id: output_bam
    type:
      type: array
      items: File
    outputBinding:
      outputEval: $( self.sort(function(a,b) { return a.path > b.path }) )
      glob: |
        {
        var bam_array = [];
        for (var i = 0; i < inputs.bam_path.length; i++) {
          bam_array.concat({"path": inputs.bam_path[i].path.split('/').slice(-1)[0], "class": "File"});
        }
        return bam_array
        }        
    secondaryFiles:
      - ^.bai

  - id: log
    type: File
    description: "python log file"
    outputBinding:
      glob: $(inputs.uuid + "_gatk_indelrealigner.log")

  - id: output_sqlite
    type: File
    description: "sqlite file"
    outputBinding:
      glob: $(inputs.uuid + ".db")

baseCommand: ["/home/ubuntu/.virtualenvs/p3/bin/python","/home/ubuntu/tools/cocleaning-tool/main.py", "--tool_name", "indelrealigner"]
