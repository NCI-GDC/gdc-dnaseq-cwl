#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
 - class: StepInputExpressionRequirement
 - class: MultipleInputFeatureRequirement

inputs:
  bai: File
  bam: File
  input_state: string
  job_uuid: string

outputs:
  sqlite:
    type: File
    outputSource: merge_sqlite/destination_sqlite

steps:
  bai_ls_l:
    run: ../../tools/ls_l.cwl
    in:
      INPUT: bai
    out: [ OUTPUT ]

  bai_md5sum:
    run: ../../tools/md5sum.cwl
    in:
      INPUT: bai
    out: [ OUTPUT ]

  bai_sha256:
    run: ../../tools/sha256sum.cwl
    in:
      INPUT: bai
    out: [ OUTPUT ]

  bam_ls_l:
    run: ../../tools/ls_l.cwl
    in:
      INPUT: bam
    out: [ OUTPUT ]

  bam_md5sum:
    run: ../../tools/md5sum.cwl
    in:
      INPUT: bam
    out: [ OUTPUT ]

  bam_sha256:
    run: ../../tools/sha256sum.cwl
    in:
      INPUT: bam
    out: [ OUTPUT ]

  bai_integrity_to_db:
    run: ../../tools/integrity_to_sqlite.cwl
    in:
      input_state: input_state
      ls_l_path: bai_ls_l/OUTPUT
      md5sum_path: bai_md5sum/OUTPUT
      sha256sum_path: bai_sha256/OUTPUT
      job_uuid: job_uuid
    out: [ OUTPUT ]

  bam_integrity_to_db:
    run: ../../tools/integrity_to_sqlite.cwl
    in:
      input_state: input_state
      ls_l_path: bam_ls_l/OUTPUT
      md5sum_path: bam_md5sum/OUTPUT
      sha256sum_path: bam_sha256/OUTPUT
      job_uuid: job_uuid
    out: [ OUTPUT ]

  merge_sqlite:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite:
        source: [
        bai_integrity_to_db/OUTPUT,
        bam_integrity_to_db/OUTPUT
        ]
      job_uuid: job_uuid
    out: [ destination_sqlite, log ]
