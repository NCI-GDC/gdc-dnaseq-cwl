#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: bam_path
    type: File

  - id: sam_name
    type: string

  - id: genome_version
    type: string

  - id: species_code
    type: string

  - id: connect_path
    type: File

  - id: task_uuid
    type: string

  - id: barcode
    type: string

  - id: db_cred_s3url
    type: string

  - id: s3cfg_path
    type: File

outputs:
  - id: adapter_report
    type: File
    source: mir_adapter_report.adapter_report
  - id: alignment_stats
    type: File
    source: mir_alignment_stats.alignment_stats
  - id: mirna_species
    type: File
    source: mir_alignment_stats.mirna_species
  - id: crossmapped
    type: File
    source: mir_alignment_stats.crossmapped
  - id: filtered_taglen
    type: File
    source: mir_alignment_stats.filtered_taglen
  - id: softclip_taglen
    type: File
    source: mir_alignment_stats.softclip_taglen
  - id: chastity_taglen
    type: File
    source: mir_alignment_stats.chastity_taglen
  - id: isoforms
    type: File
    source: mir_alignment_stats.isoforms
  - id: 3_UTR
    type: File
    source: mir_alignment_stats.3_UTR
  - id: 5_UTR
    type: File
    source: mir_alignment_stats.5_UTR
  - id: Coding_exon
    type: File
    source: mir_alignment_stats.Coding_exon
  - id: Intron
    type: File
    source: mir_alignment_stats.Intron
  - id: mirna
    type: File
    source: mir_alignment_stats.mirna
  - id: snoRNA
    type: File
    source: mir_alignment_stats.snoRNA
  - id: bed_file
    type:
      type: array
      items: File
    source: mir_alignment_stats.bed_file
  - id: isoform_quant
    type: File
    source: mir_tcga.isoform_quant
  - id: mirna_quant
    type: File
    source: mir_tcga.mirna_quant
  - id: matrix
    type: File
    source: mir_expn_matrix.matrix
  - id: matrix_norm
    type: File
    source: mir_expn_matrix.matrix_norm
  - id: matrix_norm_log
    type: File
    source: mir_expn_matrix.matrix_norm_log
  - id: mimat
    type: File
    source: mir_expn_mimat.mimat
  - id: mimat_norm
    type: File
    source: mir_expn_mimat.mimat_norm
  - id: mimat_norm_log
    type: File
    source: mir_expn_mimat.mimat_norm_log
  - id: tags_graph
    type: File
    source: mir_graph.tags_graph
  - id: softclip_graph
    type: File
    source: mir_graph.softclip_graph
  - id: adapter_graph
    type: File
    source: mir_graph.adapter_graph
  - id: chastity_graph
    type: File
    source: mir_graph.chastity_graph
  - id: saturation_graph
    type: File
    source: mir_graph.saturation_graph
  - id: LINE
    type: File
    source: mir_alignment_stats.LINE
  - id: LTR
    type: File
    source: mir_alignment_stats.LTR
  - id: rmsk_DNA
    type: File
    source: mir_alignment_stats.rmsk_DNA
  - id: rmsk_RNA
    type: [File, "null"]
    source: mir_alignment_stats.rmsk_RNA
  - id: rmsk_Simple_repeat
    type: File
    source: mir_alignment_stats.rmsk_Simple_repeat
  - id: rRNA
    type: File
    source: mir_alignment_stats.rRNA
  - id: Satellite
    type: [File, "null"]
    source: mir_alignment_stats.Satellite
  - id: scRNA
    type: File
    source: mir_alignment_stats.scRNA
  - id: SINE
    type: File
    source: mir_alignment_stats.SINE
  - id: snRNA
    type: File
    source: mir_alignment_stats.snRNA
  - id: srpRNA
    type: File
    source: mir_alignment_stats.srpRNA
  - id: tRNA
    type: File
    source: mir_alignment_stats.tRNA
  - id: adapter_log
    type: File
    source: mir_adapter_report.adapter_log
  - id: stats_log
    type: File
    source: mir_alignment_stats.stats_log
  - id: matrix_log
    type: File
    source: mir_expn_matrix.matrix_log
  - id: mimat_log
    type: File
    source: mir_expn_mimat.mimat_log
  - id: graph_log
    type: File
    source: mir_graph.graph_log
  - id: annotation_log
    type: File
    source: mir_sam_annotator.annotation_log
  - id: tcga_log
    type: File
    source: mir_tcga.tcga_log
  - id: samtools_log
    type: File
    source: samtools.samtools_log

steps:
  - id: samtools_bamtosam
    run:  ../tools/samtools_bamtosam.cwl
    inputs:
      - id: INPUT
        source: bam
    outputs:
      - id: OUTPUT

  - id: mir_adapter_report
    run: ../tools/awk.cwl
    inputs:
      - id: INPUT
        source: samtools_bamtosam/OUTPUT
      - id: EXPRESSION
        valueFrom: "{arr[length($10)]+=1} END {for (i in arr) {print i\" \"arr[i]}}"
      - id: OUTFILE
        source: samtool_bamtosam/OUTPUT
        valueFrom: $(self.nameroot)"_adapter.report"
    outputs:
      - id: OUTPUT

  - id: mir_adapter_report_sorted
    run: ../tools/sort.cwl
    inputs:
      - id: INPUT
        source: mir_adapter_report/OUTPUT
      - id: EXPRESSION
        valueFrom: "-t \" \" -k1n"
      - id: OUTFILE
        source: mir_adapter_report/OUTPUT
        valueFrom: $(self.basename)
    ouputs:
      - id: OUTPUT

  - id: mirna_annotator
    run: ../tools/mirna_annotator.cwl
    inputs:
      - id: sam
        source: samtools_bamtosam/OUTPUT
      - id: mirbase
        valueFrom: mirbase
      - id: ucsc_database
        valueFrom: ucsc_database
      - id: species_code
        valueFrom: species_code
      - id: project_directory
        valueFrom: "."
    outputs:
      - id: output

  - id: mirna_alignment_stats
    run: ../../tools/mirna_alignment_stats.cwl
    inputs:
      - id: adapter_report
        source: mir_adapter_report_sorted/OUTPUT
      - id: sam
        source: mirna_annotator/output
      - id: project_directory
        valueFrom: "."
    outputs:
      - id: alignment_stats_csv
      - id: 3_UTR_txt
      - id: 5_UTR_txt
      - id: Coding_Exon_txt
      - id: Intron_txt
      - id: LINE_txt
      - id: LTR_txt
      - id: SINE_txt
      - id: bed
      - id: chastity_taglengths_csv
      - id: crossmapped_txt
      - id: filtered_taglengths_csv
      - id: isoforms_txt
      - id: miRNA_txt
      - id: mirna_species_txt
      - id: rmsk_DNA_txt
      - id: rmsk_Simple_repeat_txt
      - id: rmsk_Unknown_txt
      - id: scRNA_txt
      - id: snRNA_txt
      - id: softclip_taglengths_csv
      - id: srpRNA_txt

  - id: mirna_tcga
    run: ../tools/mirna_tcga.cwl
    inputs:
      - id: sam
        source: mirna_annotator/output
      - id: mirbase_db
        valueFrom: mirbase
      - id: species_code
        valueFrom: species_code
      - id: genome_version
        valueFrom: ucsc_database
      - id: stats_miRNA_txt
        source: mirna_alignment_stats/miRNA_txt
      - id: stats_crossmapped_txt
        source: mirna_alignment_stats/crossmapped_txt
      - id: stats_isoforms_txt
        source: mirna_alignment_stats/isoforms_txt
    outputs:
      - id: isoform_quant
      - id: mirna_quant
        

  - id: mirna_expression_matrix
    run: ../tools/mirna_expression_matrix.cwl
    inputs:
      - id: mirbase_db
        source: mirbase
      - id: project_db
        source: project_dir
      - id: species_code
        source: species_code
      - id: stats_mirna_species_txt
        source: mirna_alignment_stats/mirna_species_txt
    outputs:
      - id: expn_matrix_txt
      - id: expn_matrix_norm_txt
      - id: expn_matrix_norm_log_txt

  - id: mirna_expression_matrix_mimat
    run: ../tools/mirna_expression_matrix_mimat.cwl
    inputs:
      - id: mirbase_db
        source: mirbase_db
      - id: project_dir
        source: project_dir
      - id: species_code
        source: species_code
      - id: stats_mirna_txt
        source: mirna_alignment_stats/miRNA_txt
      - id: stats_crossmapped_txt
        source: mirna_alignment_stats/crossmapped_txt
    outputs:
      - id: expn_matrix_mimat.txt
      - id: expn_matrix_mimat_norm_txt
      - id: expn_matrix_mimat_norm_log_txt

  - id: mir_graph
    run: ../tools/mir_graph.cwl
    inputs:
      - id: mir_graph.sam_path
        source: mir_sam_annotator.annot_sam
      - id: mir_graph.filtered_taglen
        source: mir_alignment_stats.filtered_taglen
      - id: mir_graph.softclip_taglen
        source: mir_alignment_stats.softclip_taglen
      - id: mir_graph.adapter_report
        source: mir_adapter_report.adapter_report
      - id: mir_graph.chastity_taglen
        source: mir_alignment_stats.chastity_taglen
      - id: mir_graph.alignment_stats
        source: mir_alignment_stats.alignment_stats
      - id: mir_graph.uuid
        source: uuid
      - id: mir_graph.barcode
        source: barcode
      - id: mir_graph.db_cred_s3url
        source: db_cred_s3url
      - id: mir_graph.s3cfg_path
        source: s3cfg_path
    outputs:
      - id: mir_graph.tags_graph
      - id: mir_graph.softclip_graph
      - id: mir_graph.adapter_graph
      - id: mir_graph.chastity_graph
      - id: mir_graph.saturation_graph
      - id: mir_graph.graph_log
