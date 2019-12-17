cwlVersion: v1.0
class: Workflow
id: gdc_dnaseq_conditional_markduplicates_wf
requirements:
  - class: InlineJavascriptRequirement

inputs:
  bam: File[]
  job_uuid: string
  thread_count: long
  bam_name: string
  run_markduplicates: long

outputs:
  output:
    type: File
    outputSource: index_markdup_bam/output_bam 
  sqlite:
    type: File
    outputSource: picard_markduplicates_to_sqlite/sqlite

steps:
  picard_markduplicates:
    run: ../../tools/picard_markduplicates.cwl
    in:
      INPUT: bam
      ASSUME_SORT_ORDER:
        default: queryname
      VALIDATION_STRINGENCY:
        default: SILENT
      OUTBAM: bam_name
    out: [ OUTPUT, METRICS ]

  picard_markduplicates_to_sqlite:
    run: ../../tools/picard_markduplicates_to_sqlite.cwl
    in:
      bam: bam_name
      input_state:
        valueFrom: "markduplicates_readgroups"
      metric_path: picard_markduplicates/METRICS
      job_uuid: job_uuid
    out: [ sqlite ]

  sort_markdup_bam:
    run: ../../tools/samtools_sort.cwl
    in:
      input_bam: picard_markduplicates/OUTPUT
      output_bam: bam_name
      threads: thread_count
    out: [ bam ]

  index_markdup_bam:
    run: ../../tools/samtools_index.cwl
    in:
      input_bam: sort_markdup_bam/bam
      threads: thread_count
    out: [ output_bam ]
