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
    format: "edam:format_2182"

  - id: fastq2
    type: File
    format: "edam:format_2182"

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
    format: "edam:format_1929"
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
  - id: OUTPUT
    type: File
    format: "edam:format_2572"
    outputBinding:
      glob: $(inputs.readgroup_json_path.basename.slice(0,-4) + "bam")

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

        function bwa_aln_33(rg_str) {
          var aln_cmd = [
          "bwa", "aln", "-t", inputs.thread_count, inputs.fasta_path, inputs.thread_count, inputs.fastq1_path, ">", "aln.sai1", "&&",
          "bwa", "aln", "-t", inputs.thread_count, inputs.fasta_path, inputs.thread_count, inputs.fastq2_path, ">", "aln.sai2", "&&",
          "bwa", "sampe", "-r", "\"" + rg_str + "\"", input.fasta_path, "aln.sai1", "aln.sai2", inputs.fastq1.path, inputs.fastq.path
          ];
          return cmd.join(' ')
        }

        function bwa_aln_64(rg_str) {
          var aln_cmd = [
          "bwa", "aln", "-t", "-I", inputs.thread_count, inputs.fasta_path, inputs.thread_count, inputs.fastq1_path, ">", "aln.sai1", "&&",
          "bwa", "aln", "-t", "-I", inputs.thread_count, inputs.fasta_path, inputs.thread_count, inputs.fastq2_path, ">", "aln.sai2", "&&",
          "bwa", "sampe", "-r", "\"" + rg_str + "\"", input.fasta_path, "aln.sai1", "aln.sai2", inputs.fastq1.path, inputs.fastq.path
          ];
          return cmd.join(' ')
        }

        function bwa_mem(rg_str, outbam) {
          var cmd = [
          "bwa", "mem", "-t", inputs.thread_count, "-T", "0", "-R", "\"" + rg_str + "\"",
          inputs.fasta.path, inputs.fastq1.path, inputs.fastq2.path, "|",
          "samtools", "view", "-Shb", "-o", outbam, "-"
          ];
          return cmd.join(' ')
        }

        var MEM_ALN_CUTOFF = 70;
        var fastqc_json = JSON.parse(inputs.fastqc_json_path.contents);
        var readlength = fastqc_json[inputs.fastq1.basename]["Sequence length"];
        var encoding = fastqc_json[inputs.fastq1.basename]["Encoding"];
        var rg_str = to_rg();

        var outbam = inputs.readgroup_json_path.basename.slice(0,-4) + "bam";

        if (encoding == "Illumina 1.3" || encoding == "Illumina 1.5") {
          return bwa_aln_64(rg_str, outbam)
        } else if (encoding == "Sanger / Illumina 1.9") {
          if (readlength < MEM_ALN_CUTOFF) {
            return bwa_aln_33(rg_str, outbam)
          }
          else {
            return bwa_mem(rg_str, outbam)
          }
        } else {
          return
        }
      
      }

baseCommand: [bash, -c]
