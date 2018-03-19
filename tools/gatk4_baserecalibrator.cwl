#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:latest
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: addOutputSAMProgramRecord
    type: string
    default: "true"
    inputBinding:
      prefix: --addOutputSAMProgramRecord

  - id: addOutputVCFCommandLine
    type: string
    default: "true"
    inputBinding:
      prefix: --addOutputVCFCommandLine

  - id: arguments_file
    type: ["null", File]
    inputBinding:
      prefix: --arguments_file

  - id: binary_tag_name
    type: ["null", string]
    inputBinding:
      prefix: --binary_tag_name

  - id: bqsrBAQGapOpenPenalty
    type: double
    default: 40.0
    inputBinding:
      prefix: --bqsrBAQGapOpenPenalty

  - id: cloudIndexPrefetchBuffer
    type: long
    default: -1
    inputBinding:
      prefix: --cloudIndexPrefetchBuffer

  - id: cloudPrefetchBuffer
    type: long
    default: 40
    inputBinding:
      prefix: --cloudPrefetchBuffer

  - id: createOutputBamIndex
    type: string
    default: "true"
    inputBinding:
      prefix: --createOutputBamIndex

  - id: createOutputBamMD5
    type: string
    default: "false"
    inputBinding:
      prefix: --createOutputBamMD5

  - id: createOutputVariantIndex
    type: string
    default: "true"
    inputBinding:
      prefix: --createOutputVariantIndex

  - id: createOutputVariantMD5
    type: string
    default: "false"
    inputBinding:
      prefix: --createOutputVariantMD5

  - id: defaultBaseQualities
    type: long
    default: -1
    inputBinding:
      prefix: --defaultBaseQualities

  - id: deletions_default_quality
    type: long
    default: 45
    inputBinding:
      prefix: --deletions_default_quality

  - id: disableBamIndexCaching
    type: string
    default: "false"
    inputBinding:
      prefix: --disableBamIndexCaching

  - id: disableReadFilter
    type:
      type: array
      items: string
      inputBinding:
        prefix: --disableReadFilter

  - id: disableSequenceDictionaryValidation
    type: string
    default: "false"
    inputBinding:
      prefix: --disableSequenceDictionaryValidation

  - id: disableToolDefaultReadFilters
    type: string
    default: "false"
    inputBinding:
      prefix: --disableToolDefaultReadFilters

  - id: excludeIntervals
    type:
      type: array
      items: string
      inputBinding:
        prefix: --excludeIntervals

  - id: gcs_max_retries
    type: long
    default: 20
    inputBinding:
      prefix: --gcs_max_retries

  - id: indels_context_size
    type: long
    default: 3
    inputBinding:
      prefix: --indels_context_size

  - id: input
    format: "edam:format_2572"
    type: File
    inputBinding:
      prefix: --input
    secondaryFiles:
      - ^.bai

  - id: insertions_default_quality
    type: long
    default: 45
    inputBinding:
      prefix: --insertions_default_quality

  - id: interval_exclusion_padding
    type: long
    default: 0
    inputBinding:
      prefix: --interval_exclusion_padding

  - id: interval_merging_rule
    type: string
    default: "ALL"
    inputBinding:
      prefix: --interval_merging_rule

  - id: interval_padding
    type: long
    default: 0
    inputBinding:
      prefix: --interval_padding

  - id: interval_set_rule
    type: string
    default: "UNION"
    inputBinding:
      prefix: --interval_set_rule

  - id: intervals
    type:
      type: array
      items: File
      inputBinding:
        prefix: --intervals

  - id: lenient
    type: string
    default: "false"
    inputBinding:
      prefix: --lenient

  - id: low_quality_tail
    type: long
    default: 2
    inputBinding:
      prefix: --low_quality_tail

  - id: maximum_cycle_value
    type: long
    default: 500
    inputBinding:
      prefix: --maximum_cycle_value

  - id: mismatches_context_size
    type: long
    default: 2
    inputBinding:
      prefix: --mismatches_context_size

  - id: mismatches_default_quality
    type: long
    default: -1
    inputBinding:
      prefix: --mismatches_default_quality

  - id: preserve_qscores_less_than
    type: long
    default: 6
    inputBinding:
      prefix: --preserve_qscores_less_than

  - id: quantizing_levels
    type: long
    default: 16
    inputBinding:
      prefix: --quantizing_levels

  - id: QUIET
    type: string
    default: "false"
    inputBinding:
      prefix: --QUIET

  - id: readFilter
    type:
      type: array
      items: string
      inputBinding:
        prefix: --readFilter

  - id: readIndex
    type:
      type: array
      items: string
      inputBinding:
        prefix: --readIndex

  - id: readValidationStringency
    type: string
    default: "SILENT"
    inputBinding:
      prefix: --readValidationStringency

  - id: secondsBetweenProgressUpdates
    type: double
    default: 10.0
    inputBinding:
      prefix: --secondsBetweenProgressUpdates

  - id: sequenceDictionary
    type: ["null", File]
    inputBinding:
      prefix: --sequenceDictionary

  - id: TMP_DIR
    type:
      type: array
      items: string
      inputBinding:
        prefix: --TMP_DIR

  - id: use_jdk_deflater
    type: string
    default: "false"
    inputBinding:
      prefix: --use_jdk_deflater

  - id: use_jdk_inflater
    type: string
    default: "false"
    inputBinding:
      prefix: --use_jdk_inflater

  - id: useOriginalQualities
    type: string
    default: "false"
    inputBinding:
      prefix: --useOriginalQualities

  - id: verbosity
    type: string
    default: "INFO"
    inputBinding:
      prefix: --verbosity

  - id: knownSites
    format: "edam:format_3016"
    type: File
    inputBinding:
      prefix: --knownSites
    secondaryFiles:
      - .tbi

  - id: --logging_level
    default: INFO
    type: string
    inputBinding:
      prefix: --logging_level

  - id: low_quality_tail
    type: int
    default: 2
    inputBinding:
      prefix: --low_quality_tail

  - id: lowMemoryMode
    type: boolean
    default: false
    inputBinding:
      prefix: --lowMemoryMode

  - id: maximum_cycle_value
    type: int
    default: 500
    inputBinding:
      prefix: --maximum_cycle_value

  - id: mismatches_context_size
    type: int
    default: 2
    inputBinding:
      prefix: --mismatches_context_size

  - id: mismatches_default_quality
    type: int
    default: -1
    inputBinding:
      prefix: --mismatches_default_quality

  - id: no_standard_covs
    type: boolean
    default: false
    inputBinding:
      prefix: --no_standard_covs

  - id: num_cpu_threads_per_data_thread
    type: long
    default: 1
    inputBinding:
      prefix: --num_cpu_threads_per_data_thread

  - id: --quantizing_levels
    type: int
    default: 16
    inputBinding:
      prefix: --quantizing_levels

  - id: run_without_dbsnp_potentially_ruining_quality
    type: boolean
    default: false
    inputBinding:
      prefix: --run_without_dbsnp_potentially_ruining_quality

  - id: sort_by_all_columns
    type: boolean
    default: false
    inputBinding:
      prefix: --sort_by_all_columns

  - id: reference
    format: "edam:format_1929"
    type: File
    inputBinding:
      prefix: --reference
    secondaryFiles:
      - .fai
      - ^.dict

outputs:
  - id: output_grp
    type: File
    outputBinding:
      glob: $(inputs.input_file.nameroot + "_bqsr.grp")

  - id: output_log
    type: File
    outputBinding:
      glob: $(inputs.log_to_file)

arguments:
  - valueFrom: $(inputs.input_file.nameroot + "_bqsr.grp")
    prefix: --output
    separate: true

baseCommand: [/usr/local/bin/gatk-launch, BaseRecalibrator]
