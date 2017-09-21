#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bunny-runtime-metrics-sqlite:latest
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: metric_path
    type: File
    inputBinding:
      prefix: --metric_path

  - id: metric_name
    type: string
    inputBinding:
      prefix: --metric_name

  - id: slurm_job_id
    type: string
    inputBinding:
      prefix: --slurm_job_id

  - id: task_uuid
    type: string
    inputBinding:
      prefix: --task_uuid

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.run_uuid)_bunny_$(inputs.metric_name).log

  - id: sqlite
    type: File
    outputBinding:
      glob: $(inputs.run_uuid).db
          
baseCommand: [/usr/local/bin/bunny_runtime_metrics_sqlite]
