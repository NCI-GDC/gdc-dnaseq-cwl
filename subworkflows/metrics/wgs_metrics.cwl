cwlVersion: v1.0
class: Workflow
id: gdc_dnaseq_wgs_metrics_wf
requirements:
  - class: InlineJavascriptRequirement

inputs:
  bam: File
  run_wgs: long 
  fasta:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .fai
      - .pac
      - .sa
      - ^.dict
  input_state: string
  job_uuid: string

outputs:
  sqlite:
    type: File
    outputSource: picard_collectwgsmetrics_to_sqlite/sqlite

steps:
  picard_collectwgsmetrics:
    run: ../../tools/picard_collectwgsmetrics.cwl
    in:
      INPUT: bam
      REFERENCE_SEQUENCE: fasta
      VALIDATION_STRINGENCY:
        default: "SILENT"
    out: [ OUTPUT ]

  picard_collectwgsmetrics_to_sqlite:
    run: ../../tools/picard_collectwgsmetrics_to_sqlite.cwl
    in:
      bam:
        source: bam
        valueFrom: $(self.basename)
      fasta:
        source: fasta
        valueFrom: $(self.basename)
      input_state: input_state
      metric_path: picard_collectwgsmetrics/OUTPUT
      job_uuid: job_uuid
    out: [ log, sqlite ]
