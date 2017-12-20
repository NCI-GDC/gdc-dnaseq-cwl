#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: StepInputExpressionRequirement

inputs:
  - id: awk_expression
    type: string
  - id: bam
    type: File
  - id: mirbase_db
    type: string
  - id: species_code
    type: string
  - id: project_directory
    type: string
  - id: ucsc_database
    type: string

outputs:
  - id: mirna_adapter_report_sorted_output
    type: File
    outputSource: mirna_adapter_report_sorted/OUTPUT
  - id: mirna_alignment_stats_features
    type: Directory
    outputSource: mirna_alignment_stats/features
  - id: mirna_expression_matrix_expn_matrix_txt
    type: File
    outputSource: mirna_expression_matrix/expn_matrix_txt
  - id: mirna_expression_matrix_expn_matrix_norm_txt
    type: File
    outputSource: mirna_expression_matrix/expn_matrix_norm_txt
  - id: mirna_expression_matrix_expn_matrix_norm_log_txt
    type: File
    outputSource: mirna_expression_matrix/expn_matrix_norm_log_txt
  - id: mirna_expression_matrix_mimat_expn_matrix_mimat_txt
    type: File
    outputSource: mirna_expression_matrix_mimat/expn_matrix_mimat_txt
  - id: mirna_expression_matrix_mimat_expn_matrix_mimat_norm_txt
    type: File
    outputSource: mirna_expression_matrix_mimat/expn_matrix_mimat_norm_txt
  - id: mirna_expression_matrix_mimat_expn_matrix_mimat_norm_log_txt
    type: File
    outputSource: mirna_expression_matrix_mimat/expn_matrix_mimat_norm_log_txt
  - id: mirna_graph_libs_jpgs
    type: Directory
    outputSource: mirna_graph_libs/jpgs
  - id: mirna_tcga_isoforms_quant
    type: File
    outputSource: mirna_tcga/isoforms_quant
  - id: mirna_tcga_mirnas_quant
    type: File
    outputSource: mirna_tcga/mirnas_quant

steps:
  - id: samtools_bamtosam
    run:  ../../tools/samtools_view.cwl
    in:
      - id: INPUT
        source: bam
      - id: output_format
        valueFrom: "SAM"
    out:
      - id: OUTPUT

  - id: mirna_adapter_report
    run: ../../tools/awk.cwl
    in:
      - id: INPUT
        source: samtools_bamtosam/OUTPUT
      - id: EXPRESSION
        source: awk_expression
      - id: OUTFILE
        source: samtools_bamtosam/OUTPUT
        valueFrom: $(self.nameroot)_adapter.report
    out:
      - id: OUTPUT

  - id: mirna_adapter_report_sorted
    run: ../../tools/sort.cwl
    in:
      - id: INPUT
        source: mirna_adapter_report/OUTPUT
      - id: key
        valueFrom: "1n"
      - id: OUTFILE
        source: mirna_adapter_report/OUTPUT
        valueFrom: $(self.basename)
    out:
      - id: OUTPUT

  - id: mirna_annotate
    run: ../../tools/mirna_annotate.cwl
    in:
      - id: sam
        source: samtools_bamtosam/OUTPUT
      - id: mirbase
        source: mirbase_db
      - id: ucsc_database
        source: ucsc_database
      - id: species_code
        source: species_code
      - id: project_directory
        source: project_directory
    out:
      - id: output

  - id: mirna_alignment_stats
    run: ../../tools/mirna_alignment_stats.cwl
    in:
      - id: adapter_report
        source: mirna_adapter_report_sorted/OUTPUT
      - id: sam
        source: mirna_annotate/output
      - id: project_directory
        source: project_directory
    out:
      - id: features
      - id: alignment_stats_csv
      - id: chastity_taglengths_csv
      - id: crossmapped_txt
      - id: filtered_taglengths_csv
      - id: isoforms_txt
      - id: miRNA_txt
      - id: mirna_species_txt
      - id: softclip_taglengths_csv

  - id: mirna_tcga
    run: ../../tools/mirna_tcga.cwl
    in:
      - id: genome_version
        source: ucsc_database
      - id: mirbase_db
        source: mirbase_db
      - id: project_directory
        source: project_directory
      - id: species_code
        source: species_code
      - id: sam
        source: mirna_annotate/output
      - id: stats_miRNA_txt
        source: mirna_alignment_stats/miRNA_txt
      - id: stats_crossmapped_txt
        source: mirna_alignment_stats/crossmapped_txt
      - id: stats_isoforms_txt
        source: mirna_alignment_stats/isoforms_txt
    out:
      - id: isoforms_quant
      - id: mirnas_quant

  - id: mirna_expression_matrix
    run: ../../tools/mirna_expression_matrix.cwl
    in:
      - id: mirbase_db
        source: mirbase_db
      - id: project_directory
        source: project_directory
      - id: species_code
        source: species_code
      - id: stats_mirna_species_txt
        source: mirna_alignment_stats/mirna_species_txt
    out:
      - id: expn_matrix_txt
      - id: expn_matrix_norm_txt
      - id: expn_matrix_norm_log_txt

  - id: mirna_expression_matrix_mimat
    run: ../../tools/mirna_expression_matrix_mimat.cwl
    in:
      - id: mirbase_db
        source: mirbase_db
      - id: project_directory
        source: project_directory
      - id: species_code
        source: species_code
      - id: stats_crossmapped_txt
        source: mirna_alignment_stats/crossmapped_txt
      - id: stats_mirna_txt
        source: mirna_alignment_stats/miRNA_txt
    out:
      - id: expn_matrix_mimat_txt
      - id: expn_matrix_mimat_norm_txt
      - id: expn_matrix_mimat_norm_log_txt

  - id: mirna_graph_libs
    run: ../../tools/mirna_graph_libs.cwl
    in:
      - id: sam
        source: mirna_annotate/output
      - id: adapter_report
        source: mirna_adapter_report_sorted/OUTPUT
      - id: alignment_stats_csv
        source: mirna_alignment_stats/alignment_stats_csv
      - id: chastity_taglengths_csv
        source: mirna_alignment_stats/chastity_taglengths_csv
      - id: filtered_taglengths_csv
        source: mirna_alignment_stats/filtered_taglengths_csv
      - id: softclip_taglengths_csv
        source: mirna_alignment_stats/softclip_taglengths_csv
    out:
      - id: jpgs
