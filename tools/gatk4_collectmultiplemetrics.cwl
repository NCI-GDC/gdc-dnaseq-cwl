#!/usr/bin/env cwl-runner
#$namespaces:"
  #edam: "http://edamontology.org/"
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:434cf2a0d55647d63127c60a23d6f4496b86214703220998fb10cb47bc5e0c57
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 10000
    ramMax: 10000
    tmpdirMin: 10
    tmpdirMax: 10
    outdirMin: 10
    outdirMax: 10

class: CommandLineTool

inputs:
  - id: DB_SNP
    type: File
    format: "edam:format_3016"
    inputBinding:
      prefix: --DB_SNP=
      separate: false

  - id: INPUT
    type: File
    format: "edam:format_2572"
    inputBinding:
      prefix: --INPUT=
      separate: false

  - id: METRIC_ACCUMULATION_LEVEL
    type:
      type: array
      items: string
      inputBinding:
        prefix: --METRIC_ACCUMULATION_LEVEL=
        separate: false
    default:
      - "ALL_READS"
      - "LIBRARY"
      - "SAMPLE"
      - "READ_GROUP"

  - id: REFERENCE_SEQUENCE
    type: File
    format: "edam:format_1929"
    inputBinding:
      prefix: --REFERENCE_SEQUENCE=
      separate: false

  - id: TMP_DIR
    type: string
    default: .
    inputBinding:
      prefix: --TMP_DIR=
      separate: false

outputs:
  - id: alignment_summary_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".alignment_summary_metrics")

  - id: bait_bias_detail_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".bait_bias_detail_metrics")

  - id: bait_bias_summary_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".bait_bias_summary_metrics")

  - id: base_distribution_by_cycle_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".base_distribution_by_cycle_metrics")

  - id: base_distribution_by_cycle_pdf
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".base_distribution_by_cycle.pdf")

  - id: gc_bias_detail_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".gc_bias.detail_metrics")

  - id: gc_bias_pdf
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".gc_bias.pdf")

  - id: gc_bias_summary_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".gc_bias.summary_metrics")

  - id: insert_size_histogram_pdf
    type: ["null", File]
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".insert_size_histogram.pdf")

  - id: insert_size_metrics
    type: ["null", File]
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".insert_size_metrics")

  - id: pre_adapter_detail_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".pre_adapter_detail_metrics")

  - id: pre_adapter_summary_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".pre_adapter_summary_metrics")

  - id: quality_by_cycle_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".quality_by_cycle_metrics")

  - id: quality_by_cycle_pdf
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".quality_by_cycle.pdf")

  - id: quality_distribution_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".quality_distribution_metrics")

  - id: quality_distribution_pdf
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".quality_distribution.pdf")

  - id: quality_yield_metrics
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".quality_yield_metrics")

arguments:
  - valueFrom: "--PROGRAM=CollectAlignmentSummaryMetrics"
  - valueFrom: "--PROGRAM=CollectBaseDistributionByCycle" # ALL_READS only
  - valueFrom: "--PROGRAM=CollectGcBiasMetrics"
  - valueFrom: "--PROGRAM=CollectInsertSizeMetrics"
  - valueFrom: "--PROGRAM=CollectQualityYieldMetrics" # ALL_READS only
  - valueFrom: "--PROGRAM=CollectSequencingArtifactMetrics" # ALL_READS only
  - valueFrom: "--PROGRAM=MeanQualityByCycle" # ALL_READS only
  - valueFrom: "--PROGRAM=QualityScoreDistribution" # ALL_READS only

  - valueFrom: $(inputs.INPUT.nameroot)
    prefix: --OUTPUT=
    separate: false

baseCommand: [java, -jar, /usr/local/bin/gatk-package-4.1.2.0-local.jar, CollectMultipleMetrics]
