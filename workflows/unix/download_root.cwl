#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: fasta_url
    type: string
  - id: fasta_index_url
    type: string
outputs:
  - id: fasta
    type: File
    outputSource: root_fasta/output

steps:
  - id: download_fasta
    run: downloader.cwl
    in:
      - id: url
        source: fasta_url
    out:
      - id: output

  - id: download_fasta_index
    run: downloader.cwl
    in:
      - id: url
        source: fasta_index_url
    out:
      - id: output

  - id: root_fasta
    run: root_fasta.cwl
    in:
      - id: fasta
        source: download_fasta/output
      - id: fasta_index
        source: download_fasta_index/output
    out:
      - id: output
