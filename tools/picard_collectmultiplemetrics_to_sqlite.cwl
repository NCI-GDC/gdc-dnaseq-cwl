#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard_metrics_sqlite:cd079dc1e5a8c65604283aab1587e4a783fd857c60e336f29bbcd1904d4f71d8
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 10
    tmpdirMax: 10
    outdirMin: 10
    outdirMax: 10

class: CommandLineTool

inputs:
  - id: bam
    type: string
    inputBinding:
      prefix: --bam

  - id: fasta
    type: string
    inputBinding:
      prefix: --fasta

  - id: input_state
    type: string
    inputBinding:
      prefix: --input_state

  - id: job_uuid
    type: string
    inputBinding:
      prefix: --job_uuid

  - id: vcf
    type: string
    inputBinding:
      prefix: --vcf

  - id: alignment_summary_metrics
    type: File
    inputBinding:
      prefix: --alignment_summary_metrics

  - id: bait_bias_detail_metrics
    type: File
    inputBinding:
      prefix: --bait_bias_detail_metrics

  - id: bait_bias_summary_metrics
    type: File
    inputBinding:
      prefix: --bait_bias_summary_metrics

  - id: base_distribution_by_cycle_metrics
    type: File
    inputBinding:
      prefix: --base_distribution_by_cycle_metrics

  - id: gc_bias_detail_metrics
    type: File
    inputBinding:
      prefix: --gc_bias_detail_metrics

  - id: gc_bias_summary_metrics
    type: File
    inputBinding:
      prefix: --gc_bias_summary_metrics

  - id: insert_size_metrics
    type: ["null", File]
    inputBinding:
      prefix: --insert_size_metrics

  - id: pre_adapter_detail_metrics
    type: File
    inputBinding:
      prefix: --pre_adapter_detail_metrics

  - id: pre_adapter_summary_metrics
    type: File
    inputBinding:
      prefix: --pre_adapter_summary_metrics

  - id: quality_by_cycle_metrics
    type: File
    inputBinding:
      prefix: --quality_by_cycle_metrics

  - id: quality_distribution_metrics
    type: File
    inputBinding:
      prefix: --quality_distribution_metrics

  - id: quality_yield_metrics
    type: File
    inputBinding:
      prefix: --quality_yield_metrics

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.job_uuid+"_picard_CollectMultipleMetrics.log")

  - id: sqlite
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + ".db")

baseCommand: [/usr/local/bin/picard_metrics_sqlite, --metric_name, CollectMultipleMetrics]
