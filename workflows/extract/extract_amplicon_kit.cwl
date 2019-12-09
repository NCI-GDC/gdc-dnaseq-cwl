cwlVersion: v1.0
class: Workflow
id: gdc_dnaseq_extract_amplicon_kit_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/target_kit_schema.yml

inputs:
  bioclient_config: File
  amplicon_kit_set_uuid:
    type: ../../tools/target_kit_schema.yml#amplicon_kit_set_uuid

outputs:
  output:
    type: ../../tools/target_kit_schema.yml#amplicon_kit_set_file
    outputSource: emit_amplicon_kit/output

steps:
  extract_amplicon_kit_amplicon:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle:
        source: amplicon_kit_set_uuid
        valueFrom: $(self.amplicon_kit_amplicon_uuid)
    out: [ output ]

  extract_amplicon_kit_target:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle:
        source: amplicon_kit_set_uuid
        valueFrom: $(self.amplicon_kit_target_uuid)
    out: [ output ]

  emit_amplicon_kit:
    run: ../../tools/emit_amplicon_kit_file.cwl
    in:
      amplicon_kit_amplicon_file: extract_amplicon_kit_amplicon/output
      amplicon_kit_target_file: extract_amplicon_kit_target/output
    out: [ output ]
