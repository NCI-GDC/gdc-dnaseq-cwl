#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: bam_normal_signpost_id
    type: string
  - id: bam_tumor_signpost_id
    type: string
  - id: bam_normal_uuid
    type: ["null", string]
  - id: bam_tumor_uuid
    type: ["null", string]
  - id: hostname
    type: File
  - id: host_ipaddress
    type: File
  - id: host_mac
    type: File
  - id: ini_section
    type: string
  - id: known_indel_signpost_id
    type: string
  - id: known_snp_signpost_id
    type: string
  - id: num_threads
    type: int
  - id: postgres_creds_path
    type: File
  - id: reference_fa_signpost_id
    type: string
  - id: repo
    type: string
  - id: repo_hash
    type: string
  - id: s3_bam_normal_url
    type: ["null", string]
  - id: s3_bam_tumor_url
    type: ["null", string]
  - id: status
    type: string
  - id: table_name
    type: string

outputs:
  - id: token
    type: File
    outputSource: sqlite_to_postgres/log

steps:
  - id: queue_status
    run: ../../tools/queue_coclean_status.cwl
    in:
      - id: bam_normal_signpost_id
        source: bam_signpost_id
      - id: bam_normal_uuid
        source: bam_normal_uuid
      - id: bam_tumor_signpost_id
        source: bam_tumor_signpost_id
      - id: bam_tumor_uuid
        source: bam_tumor_uuid
      - id: hostname
        source: hostname
      - id: host_ipadress
        source: host_ipadress
      - id: host_mac
        source: host_mac
      - id: input_signpost_id
        source: input_signpost_id
      - id: known_indel_signpost_id
        source: known_indel_signpost_id
      - id: known_snp_signpost_id
        source: known_snp_signpost_id
      - id: num_threads
        source: num_threads
      - id: reference_fa_signpost_id
        source: reference_fa_signpost_id
      - id: repo
        source: repo
      - id: repo_hash
        source: repo_hash
      - id: s3_bam_normal_url
        source: s3_bam_normal_url
      - id: s3_bam_tumor_url
        source: s3_bam_tumor_url
      - id: status
        source: status
      - id: table_name
        source: table_name
    out:
      - id: log
      - id: sqlite

  - id: sqlite_to_postgres
    run: ../../tools/sqlite_to_postgres_hirate.cwl
    in:
      - id: ini_section
        source: ini_section
      - id: postgres_creds_path
        source: postgres_creds_path
      - id: source_sqlite_path
        source: queue_status/sqlite
      - id: uuid
        source: uuid
    out:
      - id: log
