#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: input_bam
    type: File
  - id: thread_count
    type: long
  - id: job_uuid
    type: string

outputs:
  - id: output
    type: File
    outputSource: merge_all_sqlite/destination_sqlite

steps:
  - id: biobambam_bamtofastq
    run: ../../tools/biobambam2_bamtofastq.cwl
    in:
      - id: filename
        source: input_bam
    out:
      - id: output_fastq1
      - id: output_fastq2
      - id: output_fastq_o1
      - id: output_fastq_o2
      - id: output_fastq_s

  - id: remove_duplicate_fastq1
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq1
    out:
      - id: OUTPUT

  - id: remove_duplicate_fastq2
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq2
    out:
      - id: OUTPUT

  - id: remove_duplicate_fastq_o1
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq_o1
    out:
      - id: OUTPUT

  - id: remove_duplicate_fastq_o2
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq_o2
    out:
      - id: OUTPUT

  - id: remove_duplicate_fastq_s
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq_s
    out:
      - id: OUTPUT

  - id: sort_scattered_fastq1
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: remove_duplicate_fastq1/OUTPUT
    out:
      - id: OUTPUT

  - id: sort_scattered_fastq2
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: remove_duplicate_fastq2/OUTPUT
    out:
      - id: OUTPUT

  - id: sort_scattered_fastq_o1
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: remove_duplicate_fastq_o1/OUTPUT
    out:
      - id: OUTPUT

  - id: sort_scattered_fastq_o2
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: remove_duplicate_fastq_o2/OUTPUT
    out:
      - id: OUTPUT

  - id: sort_scattered_fastq_s
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: remove_duplicate_fastq_s/OUTPUT
    out:
      - id: OUTPUT

  - id: bam_readgroup_to_json
    run: ../../tools/bam_readgroup_to_json.cwl
    in:
      - id: INPUT
        source: input_bam
      - id: MODE
        valueFrom: "lenient"
    out:
      - id: OUTPUT

  - id: readgroup_json_db
    run: ../../tools/readgroup_json_db.cwl
    scatter: json_path
    in:
      - id: json_path
        source: bam_readgroup_to_json/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: log
      - id: output_sqlite

  - id: merge_readgroup_json_db
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: readgroup_json_db/output_sqlite
      - id: job_uuid
        source: job_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: fastqc1
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: sort_scattered_fastq1/OUTPUT
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc2
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: sort_scattered_fastq2/OUTPUT
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_s
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: sort_scattered_fastq_s/OUTPUT
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_o1
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: sort_scattered_fastq_o1/OUTPUT
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_o2
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: sort_scattered_fastq_o2/OUTPUT
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_db1
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc1/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_db2
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc2/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_db_s
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc_s/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_db_o1
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc_o1/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_db_o2
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc_o2/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: merge_fastqc_db1_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db1/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db2_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db2/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db_s_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db_s/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db_o1_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db_o1/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db_o2_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db_o2/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: destination_sqlite
      - id: log


  - id: merge_all_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: [
          merge_readgroup_json_db/destination_sqlite,
          merge_fastqc_db1_sqlite/destination_sqlite,
          merge_fastqc_db2_sqlite/destination_sqlite,
          merge_fastqc_db_s_sqlite/destination_sqlite,
          merge_fastqc_db_o1_sqlite/destination_sqlite,
          merge_fastqc_db_o2_sqlite/destination_sqlite,
        ]
      - id: job_uuid
        source: job_uuid
    out:
      - id: destination_sqlite
      - id: log
