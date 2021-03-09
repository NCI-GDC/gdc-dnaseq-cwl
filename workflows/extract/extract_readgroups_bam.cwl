cwlVersion: v1.0
class: Workflow
id: gdc_dnaseq_extract_readgroups_bam_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.yml
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  bioclient_config: File
  readgroups_bam_uuid:
    type: ../../tools/readgroup.yml#readgroups_bam_uuid

outputs:
  output:
    type: ../../tools/readgroup.yml#readgroups_bam_file
    outputSource: emit_readgroups_bam_file/output

steps:
  extract_bam:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle:
        source: readgroups_bam_uuid
        valueFrom: $(self.bam_uuid)
      file_size:
        source: readgroups_bam_uuid
        valueFrom: $(self.bam_file_size)
    out: [ output ]

  emit_readgroups_bam_file:
    run: ../../tools/emit_readgroups_bam_file.cwl
    in:
      bam: extract_bam/output
      readgroup_meta_list:
        source: readgroups_bam_uuid
        valueFrom: $(self.readgroup_meta_list)
    out: [ output ]
