cwlVersion: v1.0
class: Workflow
id: gdc_dnaseq_ar_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/target_kit_schema.yml

inputs:
  job_uuid: string
  bam_file: File
  collect_wgs_metrics: boolean
  amplicon_kit_set_file_list:
    type:
      type: array
      items: ../../tools/target_kit_schema.yml#amplicon_kit_set_file
  capture_kit_set_file_list:
    type:
      type: array
      items: ../../tools/target_kit_schema.yml#capture_kit_set_file
  common_biallelic_vcf:
    type: File
    secondaryFiles:
      - .tbi
  known_snp:
    type: File
    secondaryFiles:
      - .tbi
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
    outputSource: index_bam/output_bam
  sqlite:
    type: File
    outputSource: merge_all_sqlite/destination_sqlite

steps:
  index_bam:
    run: ../../tools/samtools_index.cwl
    in:
      input_bam: bam_file
      threads: thread_count
    out: [output_bam]

  bam_readgroup_to_json:
    run: ../../tools/bam_readgroup_to_json.cwl
    in:
      INPUT: index_bam/output_bam
      MODE:
        valueFrom: "lenient"
    out: [ OUTPUT ]

  readgroup_json_db:
    run: ../../tools/readgroup_json_db.cwl
    scatter: json_path
    in:
      json_path: bam_readgroup_to_json/OUTPUT
      job_uuid: job_uuid
    out: [ log, output_sqlite ]

  merge_readgroup_json_db:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite: readgroup_json_db/output_sqlite
      job_uuid: job_uuid
    out: [ destination_sqlite ]

  picard_validatesamfile_bqsr:
    run: ../../tools/picard_validatesamfile.cwl
    in:
      INPUT: index_bam/output_bam
      VALIDATION_STRINGENCY:
        valueFrom: "STRICT"
    out: [ OUTPUT ]

  picard_validatesamfile_bqsr_to_sqlite:
    run: ../../tools/picard_validatesamfile_to_sqlite.cwl
    in:
      bam:
        source: index_bam/output_bam
        valueFrom: $(self.basename)
      input_state:
        valueFrom: "gatk_applybqsr_readgroups"
      metric_path: picard_validatesamfile_bqsr/OUTPUT
      job_uuid: job_uuid
    out: [ sqlite ]

  metrics:
    run: ../metrics/metrics.cwl
    in:
      bam: index_bam/output_bam
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
          merge_readgroup_json_db/destination_sqlite,
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