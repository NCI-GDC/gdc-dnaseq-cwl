cwlVersion: v1.0
class: Workflow
id: gdc_dnaseq_main_wf
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
  collect_wgs_metrics: boolean
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
  run_markduplicates: boolean
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

  merge_fastq_arrays:
    run: merge_fastq_array_workflow.cwl
    in:
      bam_pe_fastqs: readgroups_bam_to_readgroups_fastq_lists/pe_file_list
      bam_se_fastqs: readgroups_bam_to_readgroups_fastq_lists/se_file_list
      bam_o1_fastqs: readgroups_bam_to_readgroups_fastq_lists/o1_file_list
      bam_o2_fastqs: readgroups_bam_to_readgroups_fastq_lists/o2_file_list
      fastqs_pe: fastq_clean_pe/output
      fastqs_se: fastq_clean_se/output
    out: [ merged_pe_fastq_array, merged_se_fastq_array ]

  bwa_pe:
    run: bwa_pe.cwl
    scatter: readgroup_fastq_pe
    in:
      job_uuid: job_uuid
      reference_sequence: reference_sequence
      readgroup_fastq_pe: merge_fastq_arrays/merged_pe_fastq_array 
      thread_count: thread_count
    out: [ bam, sqlite ]

  bwa_se:
    run: bwa_se.cwl
    scatter: readgroup_fastq_se
    in:
      job_uuid: job_uuid
      reference_sequence: reference_sequence
      readgroup_fastq_se: merge_fastq_arrays/merged_se_fastq_array 
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

  dup_branch_decider:
    run: ../../tools/decider_markdup_input.cwl
    in:
      run_markdups: run_markduplicates
      bam:
        source: [bwa_pe/bam, bwa_se/bam]
    out: [ do_markdup_workflow, skip_markdup_workflow, out_bam ]

  conditional_markduplicates:
    run: conditional_markduplicates.cwl
    scatter: run_markduplicates 
    in:
      bam: dup_branch_decider/out_bam
      job_uuid: job_uuid
      thread_count: thread_count
      bam_name: bam_name
      run_markduplicates: dup_branch_decider/do_markdup_workflow
    out: [ output, sqlite ]

  conditional_skip_markduplicates:
    run: conditional_skip_markduplicates.cwl
    scatter: skip_markduplicates
    in:
      bam: dup_branch_decider/out_bam
      job_uuid: job_uuid
      thread_count: thread_count
      bam_name: bam_name
      skip_markduplicates: dup_branch_decider/skip_markdup_workflow 
    out: [ output ]

  dup_outputs_decider:
    run: ../../tools/decider_markdup_output.cwl
    in:
      markdup_bam: conditional_markduplicates/output
      markdup_sqlite: conditional_markduplicates/sqlite
      skip_markdup_bam: conditional_skip_markduplicates/output
    out: [ bam, sqlite ] 

  gatk_baserecalibrator:
    run: ../../tools/gatk4_baserecalibrator.cwl
    in:
      input: dup_outputs_decider/bam 
      known-sites: known_snp
      reference: reference_sequence
    out: [ output_grp ]

  gatk_applybqsr:
    run: ../../tools/gatk4_applybqsr.cwl
    in:
      input: dup_outputs_decider/bam 
      bqsr-recal-file: gatk_baserecalibrator/output_grp
    out: [ output_bam ]

  picard_validatesamfile_bqsr:
    run: ../../tools/picard_validatesamfile.cwl
    in:
      INPUT: gatk_applybqsr/output_bam
      VALIDATION_STRINGENCY:
        valueFrom: "STRICT"
    out: [ OUTPUT ]

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
      collect_wgs_metrics:
        source: collect_wgs_metrics
        valueFrom: |
          ${
             if (self) {
               return([1]);
             } else {
               return([]);
             }
           }
      common_biallelic_vcf: common_biallelic_vcf
      fasta: reference_sequence
      input_state:
        valueFrom: "gatk_applybqsr_readgroups"
      job_uuid: job_uuid
      known_snp: known_snp
      thread_count: thread_count
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
          dup_outputs_decider/sqlite,
          picard_validatesamfile_bqsr_to_sqlite/sqlite,
          metrics/sqlite
          ]
        valueFrom: |
          ${
             var res = [];
             for (var i = 0; i<self.length; i++) {
               if(self[i] !== null) {
                 res.push(self[i])
               }
             }
             return(res);
           }
      job_uuid: job_uuid
    out: [ destination_sqlite, log ]
