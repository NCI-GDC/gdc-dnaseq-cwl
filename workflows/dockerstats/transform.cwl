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
    run: ../../tools/bunny_metric_to_sqlite.cwl
    in:
      - id: metric_name
        valueFrom: "postprocess"
      - id: metric_path
        source: get_runtime_metrics/OUTPUT
      - id: slurm_job_id
        source: slurm_job_id
      - id: task_uuid
        source: slurm_job_name
        valueFrom: $(self.basename)
    out:
      -id: output

  - id: bunny_containerstats_to_sqlite
    run: ../../tools/bunny_metrics_to_sqlite.cwl
    in:
      - id: metric_name
        valueFrom: "containerstats"
      - id: metric_path
        source: get_runtime_metrics/OUTPUT
      - id: slurm_job_id
        source: slurm_job_id
      - id: task_uuid
        source: slurm_job_name
        valueFrom: $(self.basename)
    out:
      id: output

  - id: merge_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: [
          bunny_postprocess_to_sqlite/output,
          bunny_containerstats_to_sqlite/output
        ]
      - id: task_uuid
        source: slurm_job_name
        valueFrom: $(self.basename)
    out:
      - id: destination_sqlite
