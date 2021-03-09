cwlVersion: v1.0
class: CommandLineTool
id: bwa_record_pe
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bwa:6f48348ec54042c9bb420ea5e28eea8f62a81c15b44800673bdfece1f379591b
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.yml
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    coresMin: $(inputs.thread_count)
    coresMax: $(inputs.thread_count)
    ramMin: 10000
    ramMax: 10000
    tmpdirMin: $(Math.ceil(2 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))
    tmpdirMax: $(Math.ceil(2 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))
    outdirMin: $(Math.ceil(2 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))
    outdirMax: $(Math.ceil(2 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))

inputs:
  fastq1:
    type: File
    format: "edam:format_2182"

  fastq2:
    type: File
    format: "edam:format_2182"

  fasta:
    type: File
    format: "edam:format_1929"
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa

  readgroup_meta:
    type: readgroup.yml#readgroup_meta

  fastqc_json_path:
    type: File
    format: "edam:format_3464"
    inputBinding:
      loadContents: true
      valueFrom: $(null)

  thread_count: long

outputs:
  OUTPUT:
    type: File
    format: "edam:format_2572"
    outputBinding:
      glob: $(inputs.readgroup_meta['ID'] + ".bam")

arguments:
  - valueFrom: |
      ${
        function to_rg() {
          var readgroup_str = "@RG";
          var keys = Object.keys(inputs.readgroup_meta).sort();
          for (var i = 0; i < keys.length; i++) {
            var key = keys[i];
            var value = inputs.readgroup_meta[key];
            if (key.length == 2 && value != null) {
              readgroup_str = readgroup_str + "\\t" + key + ":" + value;
            }
          }
          return readgroup_str
        }

        function bwa_aln_33(rg_str, outbam) {
          var cmd = [
          "bwa", "aln", "-t", inputs.thread_count, inputs.fasta.path, inputs.fastq1.path, ">", "aln.sai1", "&&",
          "bwa", "aln", "-t", inputs.thread_count, inputs.fasta.path, inputs.fastq2.path, ">", "aln.sai2", "&&",
          "bwa", "sampe", "-r", "\"" + rg_str + "\"", inputs.fasta.path, "aln.sai1", "aln.sai2", inputs.fastq1.path, inputs.fastq2.path, "|",
          "samtools", "view", "-Shb", "-o", outbam, "-"
          ];
          return cmd.join(' ')
        }

        function bwa_aln_64(rg_str, outbam) {
          var cmd = [
          "bwa", "aln", "-I","-t", inputs.thread_count, inputs.fasta.path, inputs.fastq1.path, ">", "aln.sai1", "&&",
          "bwa", "aln", "-I", "-t", inputs.thread_count, inputs.fasta.path, inputs.fastq2.path, ">", "aln.sai2", "&&",
          "bwa", "sampe", "-r", "\"" + rg_str + "\"", inputs.fasta.path, "aln.sai1", "aln.sai2", inputs.fastq1.path, inputs.fastq2.path, "|",
          "samtools", "view", "-Shb", "-o", outbam, "-"
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

        var outbam = inputs.readgroup_meta['ID'] + ".bam";

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
