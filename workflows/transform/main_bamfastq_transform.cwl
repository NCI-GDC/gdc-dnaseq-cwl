#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/target_kit_schema.yml
      - $import: ../../tools/readgroup.yml
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  bam_name: string
  job_uuid: string
  amplicon_kit_set_file_list:
    type:
      type: array
      items: ../../tools/target_kit_schema.yml#amplicon_kit_set_file
  capture_kit_set_file_list:
    type:
      type: array
      items: ../../tools/target_kit_schema.yml#capture_kit_set_file
  readgroup_fastq_pe_file_list:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_file
  readgroup_fastq_se_file_list:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_file
  readgroups_bam_file_list:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroups_bam_file
  common_biallelic_vcf:
    type: File
    secondaryFiles:
      - .tbi
  known_snp:
    type: File
    secondaryFiles:
      - .tbi
  run_bamindex: long[]
  run_markduplicates: long[]
  reference_sequence:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .fai
      - .pac
      - .sa
      - ^.dict
  sq_header: File
  thread_count: long

outputs:
  output_bam:
    type: File
    outputSource: gatk_applybqsr/output_bam
  sqlite:
    type: File
    outputSource: merge_all_sqlite/destination_sqlite

steps:
  fastq_clean_pe:
    run: fastq_clean.cwl
    scatter: input
    in:
      input: readgroup_fastq_pe_file_list
      job_uuid: job_uuid
    out: [ output, sqlite ]

  fastq_clean_se:
    run: fastq_clean.cwl
    scatter: input
    in:
      input: readgroup_fastq_se_file_list
      job_uuid: job_uuid
    out: [ output, sqlite ]

  merge_sqlite_fastq_clean_pe:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite: fastq_clean_pe/sqlite
      job_uuid: job_uuid
    out: [ destination_sqlite, log ]

  merge_sqlite_fastq_clean_se:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite: fastq_clean_se/sqlite
      job_uuid: job_uuid
    out: [ destination_sqlite, log ]

  readgroups_bam_to_readgroups_fastq_lists:
    run: readgroups_bam_to_readgroups_fastq_lists.cwl
    scatter: readgroups_bam_file
    in:
      readgroups_bam_file: readgroups_bam_file_list
    out: [ pe_file_list, se_file_list, o1_file_list, o2_file_list ]

  merge_bam_pe_fastq_records:
    run: ../../tools/merge_pe_fastq_records.cwl
    in:
      input: readgroups_bam_to_readgroups_fastq_lists/pe_file_list
    out: [ output ]

  merge_pe_fastq_records:
    run: ../../tools/merge_pe_fastq_records.cwl
    in:
      input:
        source: [
          merge_bam_pe_fastq_records/output,
          fastq_clean_pe/output
        ]
    out: [ output ]

  merge_bam_se_fastq_records:
    run: ../../tools/merge_se_fastq_records.cwl
    in:
      input: readgroups_bam_to_readgroups_fastq_lists/se_file_list
    out: [ output ]

  merge_se_fastq_records:
    run: ../../tools/merge_se_fastq_records.cwl
    in:
      input:
        source: [
          merge_bam_se_fastq_records/output,
          fastq_clean_se/output
        ]
    out: [ output ]

  merge_o1_fastq_records:
    run: ../../tools/merge_se_fastq_records.cwl
    in:
      input: readgroups_bam_to_readgroups_fastq_lists/o1_file_list
    out: [ output ]

  merge_o2_fastq_records:
    run: ../../tools/merge_se_fastq_records.cwl
    in:
      input: readgroups_bam_to_readgroups_fastq_lists/o2_file_list
    out: [ output ]

  bwa_pe:
    run: bwa_pe.cwl
    scatter: readgroup_fastq_pe
    in:
      job_uuid: job_uuid
      reference_sequence: reference_sequence
      readgroup_fastq_pe: merge_pe_fastq_records/output
      thread_count: thread_count
    out: [ bam, sqlite ]

  bwa_se:
    run: bwa_se.cwl
    scatter: readgroup_fastq_se
    in:
      job_uuid: job_uuid
      reference_sequence: reference_sequence
      readgroup_fastq_se: merge_se_fastq_records/output
      thread_count: thread_count
    out: [ bam, sqlite ]

  bwa_o1:
    run: bwa_se.cwl
    scatter: readgroup_fastq_se
    in:
      job_uuid: job_uuid
      reference_sequence: reference_sequence
      readgroup_fastq_se: merge_o1_fastq_records/output
      thread_count: thread_count
    out: [ bam, sqlite ]

  bwa_o2:
    run: bwa_se.cwl
    scatter: readgroup_fastq_se
    in:
      job_uuid: job_uuid
      reference_sequence: reference_sequence
      readgroup_fastq_se: merge_o2_fastq_records/output
      thread_count: thread_count
    out: [ bam, sqlite ]

  merge_sqlite_bwa_pe:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite: bwa_pe/sqlite
      job_uuid: job_uuid
    out: [ destination_sqlite, log ]

  merge_sqlite_bwa_se:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite: bwa_se/sqlite
      job_uuid: job_uuid
    out: [ destination_sqlite, log ]

  picard_mergesamfiles:
    run: ../../tools/picard_mergesamfiles_aoa.cwl
    in:
      INPUT:
        source: [
          bwa_pe/bam,
          bwa_se/bam,
          bwa_o1/bam,
          bwa_o2/bam
        ]
      OUTPUT: bam_name
    out: [ MERGED_OUTPUT ]

  bam_reheader:
    run: ../../tools/bam_reheader.cwl
    in:
      input: picard_mergesamfiles/MERGED_OUTPUT
      header: sq_header
    out: [ output ]

  conditional_markduplicates:
    run: conditional_markduplicates.cwl
    scatter: run_markduplicates
    in:
      bam: bam_reheader/output
      job_uuid: job_uuid
      run_markduplicates: run_markduplicates
    out: [ output, sqlite ]

  conditional_index:
    run: conditional_bamindex.cwl
    scatter: run_bamindex
    in:
      bam: bam_reheader/output
      run_bamindex: run_bamindex
      thread_count: thread_count
    out: [ output, sqlite ]

  decide_markduplicates_index:
    run: ../../tools/decider_conditional_bams.cwl
    in:
      conditional_bam1: conditional_markduplicates/output
      conditional_sqlite1: conditional_markduplicates/sqlite
      conditional_bam2: conditional_index/output
      conditional_sqlite2: conditional_index/sqlite
    out: [ output, sqlite ]

  gatk_baserecalibrator:
    run: ../../tools/gatk4_baserecalibrator.cwl
    in:
      input: decide_markduplicates_index/output
      known-sites: known_snp
      reference: reference_sequence
    out: [ output_grp ]

  gatk_applybqsr:
    run: ../../tools/gatk4_applybqsr.cwl
    in:
      input: decide_markduplicates_index/output
      bqsr-recal-file: gatk_baserecalibrator/output_grp
    out: [ output_bam ]

  picard_validatesamfile_bqsr:
    run: ../../tools/picard_validatesamfile.cwl
    in:
      INPUT: gatk_applybqsr/output_bam
      VALIDATION_STRINGENCY:
        valueFrom: "STRICT"
    out: [ OUTPUT ]

  #need eof and dup QNAME detection
  picard_validatesamfile_bqsr_to_sqlite:
    run: ../../tools/picard_validatesamfile_to_sqlite.cwl
    in:
      bam:
        source: gatk_applybqsr/output_bam
        valueFrom: $(self.basename)
      input_state:
        valueFrom: "gatk_applybqsr_readgroups"
      metric_path: picard_validatesamfile_bqsr/OUTPUT
      job_uuid: job_uuid
    out: [ sqlite ]

  metrics:
    run: metrics.cwl
    in:
      bam: gatk_applybqsr/output_bam
      amplicon_kit_set_file_list: amplicon_kit_set_file_list
      capture_kit_set_file_list: capture_kit_set_file_list
      common_biallelic_vcf: common_biallelic_vcf
      fasta: reference_sequence
      input_state:
        valueFrom: "gatk_applybqsr_readgroups"
      job_uuid: job_uuid
      known_snp: known_snp
    out: [ sqlite ]

  integrity:
    run: integrity.cwl
    in:
      bai:
        source: gatk_applybqsr/output_bam
        valueFrom: $(self.secondaryFiles[0])
      bam: gatk_applybqsr/output_bam
      input_state:
        valueFrom: "gatk_applybqsr_readgroups"
      job_uuid: job_uuid
    out: [ sqlite ]

  merge_all_sqlite:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite:
        source: [
          merge_sqlite_fastq_clean_pe/destination_sqlite,
          merge_sqlite_fastq_clean_se/destination_sqlite,
          merge_sqlite_bwa_pe/destination_sqlite,
          merge_sqlite_bwa_se/destination_sqlite,
          decide_markduplicates_index/sqlite,
          picard_validatesamfile_bqsr_to_sqlite/sqlite,
          metrics/sqlite,
          integrity/sqlite
          ]
      job_uuid: job_uuid
    out: [ destination_sqlite, log ]
