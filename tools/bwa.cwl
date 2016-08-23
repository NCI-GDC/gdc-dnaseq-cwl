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
        function to_rg() {
          var readgroup_str = "@RG";
          var readgroup_json = JSON.parse(inputs.readgroup_json_path);
          for (key in readgroup_json) {
            var value = readgroup_json[key]
              readgroup_str = readgroup_str + "\t" + key + ":" + value;
          }
          return readgroup_str
        }
      
        function bwa_aln(rg_str) {
          var aln_cmd = [
          "aln", "-t", inputs.fasta_path, inputs.thread_count, inputs.fastq1_path, ">", "aln.sai1", "&&"
          "aln", "-t", inputs.fasta_path, inputs.thread_count, inputs.fastq2_path, ">", "aln.sai2", "&&"
          "bwa", "sampe", "-r", rg_str, input.fasta_path, "aln.sai1", "aln.sai2", inputs.fastq1_path, inputs.fastq2_path
          ];
        }

        function bwa_mem(rg_str) {
          var mem_cmd = [
          "mem", "-t", inputs.thread_count, "-T", "0", "-R", rg_str, inputs.fasta_path, inputs.fastq1_path, inputs.fastq2_path
          ];
        }
        var MEM_ALN_CUTOFF = 70;
        var fastqc_json = JSON.parse(inputs.fastqc_json_path.contents);
        var readlength = fastqc_json[fastq1_path.basename]["Sequence length"];
        var encoding = fastqc_json[fastq1_path.basename]["Encoding"];
        var rg_str = to_rg()
        if (readlength < MEM_ALN_CUTOFF) {
          bwa_aln(rg_str);
        } else if (encoding != "Sanger / Illumina 1.9" {
          bwa_aln(rg_str);
        } else {
          bwa_mem(rg_str);
        }
      
      }

baseCommand: [bwa]
