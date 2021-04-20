cwlVersion: v1.0
class: Workflow
id: gdc_dnaseq_bwa_se_wf
requirements:
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.yml
  - class: StepInputExpressionRequirement

inputs:
  job_uuid: string
  reference_sequence:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .fai
      - .pac
      - .sa
      - ^.dict
  readgroup_fastq_se:
    type: ../../tools/readgroup.yml#readgroup_fastq_file
  thread_count: long

outputs:
  bam:
    type: File
    outputSource: bwa_se/OUTPUT
  sqlite:
    type: File
    outputSource: merge_sqlite/destination_sqlite

steps:

  fastq1_remove_duplicate_qname:
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    in:
      INPUT:
        source: readgroup_fastq_se
        valueFrom: $(self.forward_fastq)
    out: [OUTPUT, METRICS]

  fastqc:
    run: ../../tools/fastqc.cwl
    in:
      INPUT: fastq1_remove_duplicate_qname/OUTPUT
      threads: thread_count
    out: [ OUTPUT ]

  fastqc_db:
    run: ../../tools/fastqc_db.cwl
    in:
      INPUT: fastqc/OUTPUT
      job_uuid: job_uuid
    out: [ LOG, OUTPUT ]

  fastqc_basicstats_json:
    run: ../../tools/fastqc_basicstatistics_json.cwl
    in:
      sqlite_path: fastqc_db/OUTPUT
    out: [ OUTPUT ]

  bwa_se:
    run: ../../tools/bwa_record_se.cwl
    in:
      fasta: reference_sequence
      fastq: fastq1_remove_duplicate_qname/OUTPUT
      fastqc_json_path: fastqc_basicstats_json/OUTPUT
      readgroup_meta:
        source: readgroup_fastq_se
        valueFrom: $(self.readgroup_meta)
      thread_count: thread_count
    out: [ OUTPUT ]

  bam_readgroup_to_json:
    run: ../../tools/bam_readgroup_to_json.cwl
    in:
      INPUT: bwa_se/OUTPUT
      MODE:
        valueFrom: "lenient"
    out: [ OUTPUT ]

  readgroup_json_db:
    run: ../../tools/readgroup_json_db.cwl
    scatter: json_path
    in:
      json_path: bam_readgroup_to_json/OUTPUT
      job_uuid: job_uuid
    out: [ log, output_sqlite ]

  merge_readgroup_json_db:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite: readgroup_json_db/output_sqlite
      job_uuid: job_uuid
    out: [ destination_sqlite ]

  merge_sqlite:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite:
        source: [
        fastqc_db/OUTPUT,
        merge_readgroup_json_db/destination_sqlite
        ]
      job_uuid: job_uuid
    out: [ destination_sqlite, log ]
