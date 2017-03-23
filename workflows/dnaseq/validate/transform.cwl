#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: MultipleInputFeatureRequirement

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
  - id: sql_average_quality_samtools_stats
    type: string
  - id: exp_average_quality_samtools_stats
    type: double
  - id: sql_bases_duplicated_samtools_stats
    type: string
  - id: exp_bases_duplicated_samtools_stats
    type: int
  - id: sql_pairs_diff_chr_samtools_stats
    type: string
  - id: exp_pairs_diff_chr_samtools_stats
    type: int
  - id: sql_pairs_other_orient_samtools_stats
    type: string
  - id: exp_pairs_other_orient_samtools_stats
    type: int
  - id: sql_raw_total_seq_samtools_stats
    type: string
  - id: exp_raw_total_seq_samtools_stats
    type: int
  - id: sql_reads_mq0_samtools_stats
    type: string
  - id: exp_reads_mq0_samtools_stats
    type: int
  - id: sql_reads_dup_samtools_stats
    type: string
  - id: exp_reads_dup_samtools_stats
    type: int
  - id: sql_reads_mapped_samtools_stats
    type: string
  - id: exp_reads_mapped_samtools_stats
    type: int
  - id: sql_reads_mapped_and_paired_samtools_stats
    type: string
  - id: exp_reads_mapped_and_paired_samtools_stats
    type: int
  - id: sql_reads_paired_samtool_stats
    type: string
  - id: exp_reads_paired_samtool_stats
    type: int
  - id: sql_reads_prop_paired_samtools_stats
    type: string
  - id: exp_reads_prop_paired_samtools_stats
    type: int
  - id: sql_read_unmapped_samtools_stats
    type: string
  - id: exp_read_unmapped_samtools_stats
    type: int
  - id: sql_seqs_samtools_stats
    type: string
  - id: exp_seqs_samtools_stats
    type: int
  - id: sql_total_length_samtools_stats
    type: string
  - id: exp_total_length_samtools_stats
    type: int
  - id: sql_read_pairs_picard_markduplicates
    type: string
  - id: exp_read_pairs_picard_markduplicates
    type: int
  - id: sql_read_pair_dups_picard_markduplicates
    type: string
  - id: exp_read_pair_dups_picard_markduplicates
    type: int

outputs:
  - id: tests_logical_conjunction_result
    type: boolean
    outputSource: tests_logical_conjunction/result

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
      - id: result

  - id: test_count_files_output
    run: ../../../tools/test_int.cwl
    in:
      - id: expected_value
        source: exp_count_files_output
      - id: test_value
        source: sqlite_count_files_output/result
    out:
      - id: result

  - id: test_count_readgroups
    run: ../../../tools/test_int.cwl
    in:
      - id: expected_value
        source: exp_count_readgroups
      - id: test_value
        source: sqlite_count_readgroups/result
    out:
      - id: result

  - id: test_bases_mapped_samtools_stats
    run: ../../../tools/test_int.cwl
    in:
      - id: expected_value
        source: exp_bases_mapped_samtools_stats
      - id: test_value
        source: sqlite_bases_mapped_samtools_stats/result
    out:
      - id: result

  - id: test_reads_mapped_samtools_stats
    run: ../../../tools/test_int.cwl
    in:
      - id: expected_value
        source: exp_reads_mapped_samtools_stats
      - id: test_value
        source: sqlite_reads_mapped_samtools_stats/result
    out:
      - id: result

  - id: tests_logical_conjunction
    run: ../../../tools/logical_conjunction_expression.cwl
    in:
      - id: values
        source: [
        test_count_fastq_files/result,
        test_count_files_output/result,
        test_count_readgroups/result,
        test_bases_mapped_samtools_stats/result,
        test_reads_mapped_samtools_stats/result
        ]
    out:
      - id: result
