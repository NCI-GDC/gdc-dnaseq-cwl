#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow


inputs:
  - id: input_slurm_out
    type: File
  - id: runtime_metrics_pattern
    type: string
  - id: slurm_job_id
    type: long
  - id: slurm_job_name
    type: string

outputs:
  - id: output
    type: File
    outputSource: merge_sqlite/destination_sqlite

steps:
  - id: get_runtime_metrics
    run: ../../tools/grep.cwl
    in:
      - id: INPUT
        source: input_slurm_out
      - id: PATTERN
        source: runtime_metrics_pattern
      - id: OUTFILE
        source: input_slurm_out
        valueFrom: $(self.basename)_runtime.out
    out:
      - id: OUTPUT

  - id: bunny_postprocess_to_sqlite
    run: ../../tools/bunny_postprocess_to_sqlite.cwl
    in:
      - id: input_runtime_metrics
        source: get_runtime_metrics/OUTPUT
      - id: job_uuid
        source: slurm_job_name
        valueFrom: $(self.basename)
      - id: slurm_job_id
        source: slurm_job_id
    out:
      -id: output

  - id: bunny_containerstats_to_sqlite
    run: ../../tools/bunny_containerstats_to_sqlite.cwl
    in:
      - id: input_runtime_metrics
        source: get_runtime_metrics/OUTPUT
      - id: job_uuid
        source: slurm_job_name
        valueFrom: $(self.basename)
      - id: slurm_job_id
        source: slurm_job_id
    out:
      id: output

  - id: merge_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: job_uuid
        source: slurm_job_name
        valueFrom: $(self.basename)
      - id: source_sqlite
        source: [
          bunny_postprocess_to_sqlite/output,
          bunny_containerstats_to_sqlite/output
        ]
    out:
      - id: destination_sqlite
