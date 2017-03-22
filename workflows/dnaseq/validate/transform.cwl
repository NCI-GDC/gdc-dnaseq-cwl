#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: sqlite_file
    type: File
  - id: sql_count_fastq_files
    type: string
  - id: exp_count_fastq_files
    type: int
  - id: sql_count_files_output
    type: string
  - id: exp_count_files_output
    type: int
  - id: sql_count_readgroups
    type: string
  - id: exp_count_readgroups
    type: int
  - id: sql_bases_mapped_samtools_stats
    type: string
  - id: exp_bases_mapped_samtools_stats
    type: int
  - id: sql_reads_mapped_samtools_stats
    type: string
  - id: exp_reads_mapped_samtools_stats
    type: int

outputs:
  []

steps:
  - id: sqlite_count_fastq_files
    run: ../../../tools/get_int_sqlite.cwl
    in:
      - id: sqlite_expression
        source: sql_count_fastq_files
      - id: sqlite_file
        source: sqlite_file
    out:
      - id: result

  - id: sqlite_count_files_output
    run: ../../../tools/get_int_sqlite.cwl
    in:
      - id: sqlite_expression
        source: sql_count_files_output
      - id: sqlite_file
        source: sqlite_file
    out:
      - id: result

  - id: sqlite_count_readgroups
    run: ../../../tools/get_int_sqlite.cwl
    in:
      - id: sqlite_expression
        source: sql_count_readgroups
      - id: sqlite_file
        source: sqlite_file
    out:
      - id: result

  - id: sqlite_bases_mapped_samtools_stats
    run: ../../../tools/get_int_sqlite.cwl
    in:
      - id: sqlite_expression
        source: sql_bases_mapped_samtools_stats
      - id: sqlite_file
        source: sqlite_file
    out:
      - id: result

  - id: sqlite_reads_mapped_samtools_stats
    run: ../../../tools/get_int_sqlite.cwl
    in:
      - id: sqlite_expression
        source: sql_reads_mapped_samtools_stats
      - id: sqlite_file
        source: sqlite_file
    out:
      - id: result

  - id: test_count_fastq_files
    run: ../../../tools/test_int.cwl
    in:
      - id: expected_value
        source: exp_count_fastq_files
      - id: test_value
        source: sqlite_count_fastq_files/result
    out:
      []

        
        
        
