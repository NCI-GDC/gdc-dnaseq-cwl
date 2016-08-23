#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/jeremiahsavage/bwa
  - class: ShellCommandRequirement

class: CommandLineTool

inputs:
  - id: fastq1
    type: File

  - id: fastq2
    type: File

  - id: fasta
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa

  - id: readgroup_json_path
    type: File
    inputBinding:
      loadContents: true
      valueFrom: null

  - id: fastqc_json_path
    type: File
    inputBinding:
      loadContents: true
      valueFrom: null

  - id: thread_count
    type: int

outputs:
  []

arguments:
  - valueFrom: |
      ${
        function to_rg() {
          var readgroup_str = "@RG";
          var readgroup_json = JSON.parse(inputs.readgroup_json_path.contents);
          for (var key in readgroup_json) {
            var value = readgroup_json[key];
            readgroup_str = readgroup_str + "\\t" + key + ":" + value;
          }
          return readgroup_str
        }

        function bwa_aln(rg_str) {
          var aln_cmd = [
          "bwa", "aln", "-t", inputs.fasta_path, inputs.thread_count, inputs.fastq1_path, ">", "aln.sai1", "&&",
          "bwa", "aln", "-t", inputs.fasta_path, inputs.thread_count, inputs.fastq2_path, ">", "aln.sai2", "&&",
          "bwa", "sampe", "-r", rg_str, input.fasta_path, "aln.sai1", "aln.sai2", inputs.fastq1.path, inputs.fastq.path
          ];
          return cmd
        }

        function bwa_mem(rg_str) {
          var cmd = [
          "/usr/local/bin/bwa", "mem", "-t", inputs.thread_count, "-T", "0", "-R", "\"" + rg_str + "\"",
          inputs.fasta.path, inputs.fastq1.path, inputs.fastq2.path
          ];
          return cmd.join(' ')
        }

        var MEM_ALN_CUTOFF = 70;
        var fastqc_json = JSON.parse(inputs.fastqc_json_path.contents);
        var readlength = fastqc_json[inputs.fastq1.basename]["Sequence length"];
        var encoding = fastqc_json[inputs.fastq1.basename]["Encoding"];
        var rg_str = to_rg();

        if (readlength < MEM_ALN_CUTOFF) {
          return "mem"
        } else if (encoding != "Sanger / Illumina 1.9") {
          return "mem"
        } else {
          return bwa_mem(rg_str)
        }
      
      }

baseCommand: [bash, -c]
