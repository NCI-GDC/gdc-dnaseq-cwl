cwlVersion: v1.0
class: Workflow
id: gdc_dnaseq_conditional_skip_markduplicates_wf

inputs:
  bam: File[]
  job_uuid: string
  thread_count: long
  bam_name: string
  skip_markduplicates: long

outputs:
  output:
    type: File
    outputSource: picard_mergesamfiles/MERGED_OUTPUT 

steps:
  picard_mergesamfiles:
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      INPUT: bam
      VALIDATION_STRINGENCY:
        default: SILENT
      OUTPUT: bam_name
    out: [ MERGED_OUTPUT ]
