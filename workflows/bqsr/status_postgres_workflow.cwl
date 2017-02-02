#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: bam_signpost_id
    type: string
  - id: bam__uuid
    type: ["null", string]
  - id: hostname
    type: string
  - id: host_ipaddress
    type: string
  - id: host_mac
    type: string
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
  - id: run_uuid
    type: string
  - id: s3_bam_url
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
    run: ../../tools/queue_bqsr_status.cwl
    in:
      - id: bam_signpost_id
        source: bam_signpost_id
      - id: bam_uuid
        source: bam_uuid
      - id: hostname
        source: hostname
      - id: host_ipaddress
        source: host_ipaddress
      - id: host_mac
        source: host_mac
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
      - id: run_uuid
        source: run_uuid
      - id: s3_bam_url
        source: s3_bam_url
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
        source: run_uuid
    out:
      - id: log
