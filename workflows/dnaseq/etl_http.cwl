#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
 - class: InlineJavascriptRequirement
 - class: StepInputExpressionRequirement
 - class: SubworkflowFeatureRequirement

inputs:
  - id: bam
    type: File
  - id: dbsnp
    type: File
  - id: fasta
    type: File
  - id: fasta_bwa
    type: File
  - id: thread_count
    type: int
  - id: uuid
    type: string

outputs:
  - id: harmonized_bam
    type: File
    outputSource: transform/picard_markduplicates_output
  - id: sqlite
    type: File
    outputSource: transform/merge_all_sqlite_destination_sqlite

steps:
  - id: extract_untar_fastabwa
    run: ../../tools/untar_fastabwa.cwl
    in:
      - id: input
        source: fasta_bwa
    out:
      - id: fasta_amb
      - id: fasta_ann
      - id: fasta_bwt
      - id: fasta_pac
      - id: fasta_sa

  - id: extract_untar_fasta
    run: ../../tools/untar_fasta.cwl
    in:
      - id: input
        source: fasta
    out:
      - id: fasta

  - id: root_fasta_files
    run: ../../tools/root_fasta_dnaseq.cwl
    in:
      - id: fasta
        source: extract_untar_fasta/fasta
      - id: fasta_amb
        source: extract_untar_fastabwa/fasta_amb
      - id: fasta_ann
        source: extract_untar_fastabwa/fasta_ann
      - id: fasta_bwt
        source: extract_untar_fastabwa/fasta_bwt
      - id: fasta_pac
        source: extract_untar_fastabwa/fasta_pac
      - id: fasta_sa
        source: extract_untar_fastabwa/fasta_sa
    out:
      - id: output

  - id: transform
    run: transform.cwl
    in:
      - id: bam_path
        source: bam
      - id: db_snp_path
        source: dbsnp
      - id: reference_fasta_path
        source: root_fasta_files/output
      - id: thread_count
        source: thread_count
      - id: uuid
        source: uuid
    out:
      - id: picard_markduplicates_output
      - id: merge_all_sqlite_destination_sqlite
