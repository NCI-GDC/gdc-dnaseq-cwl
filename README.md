# GDC DNA-Seq Alignment Workflow

This workflow takes a set of input WGS/WXS/Targeted Sequencing FASTQ/BAM files and generates
a harmonized BAM file and an sqlite database of various metrics collected.

## External Users

The entrypoint CWL workflow for external users is `workflows/main/gdc_dnaseq_main_workflow.cwl`.

### Inputs

| Name | Type | Description |
| ---- | ---- | ----------- |
| `bam_name` | `string` | basename of the final harmonized bam |
| `job_uuid` | `string` | unique identifier for the workflow run |
| `collect_wgs_metrics` | `boolean` | set to `true` to generate metrics for WGS data |
| `amplicon_kit_set_file_list` | `amplicon_kit_set_file[]` | array of objects containing the paths to the amplicon and target files (only for amplicon-based targeted/WXS sequencing) |
| `capture_kit_set_file_list` | `capture_kit_set_file[]` | array of objects containing the paths to the target and bait files (only for hybrid-selection targeted/WXS sequencing) | 
| `readgroup_fastq_pe_file_list` | `readgroup_fastq_file[]` | array of objects containing the paths to paired-end fastq files and their associated readgroup metadata |
| `readgroup_fastq_se_file_list` | `readgroup_fastq_file[]` | array of objects containing the paths to single-end fastq files and their associated readgroup metadata |
| `readgroups_bam_file_list` | `readgroups_bam_file[]` | array of objects containing the paths to BAM files and their associated readgroup metadata |
| `common_biallelic_vcf` | `File` | tabix-indexed common biallelic VCF (e.g., gnomad) |
| `known_snp` | `File` | tabix-indexed dbSNP VCF |
| `run_markduplicates` | `boolean` | this should be `true` in all cases except for amplicon-based PCR sequencing libraries |
| `reference_sequence` | `File` | the reference fasta file and its associated BWA/fai/dict index files |
| `thread_count` | `long` | the number of cores to use for multi-threaded tools |

**Custom Data Types**

* `amplicon_kit_set_file` - contains amplicon sequencing kit files

| Name | Type | Description |
| ---- | ---- | ----------- |
| `amplicon_kit_amplicon_file` | `File` | amplicon baits interval file |
| `amplicon_kit_target_file` | `File` | amplicon target interval file |

* `capture_kit_set_file` - contains the hybrid-selection targeted squencing kit files 

| Name | Type | Description |
| ---- | ---- | ----------- |
| `capture_kit_bait_file` | `File` | capture kit baits interval file |
| `capture_kit_target_file` | `File` | capture kit targets interval file |

* `readgroup_fastq_file` - contains readgroup level fastq files and the associated readgroup metadata

| Name | Type | Description |
| ---- | ---- | ----------- |
| `forward_fastq` | `File` | required R1 fastq file |
| `reverse_fastq` | `File?` | optional R2 fastq file (for paired-end reads) |
| `readgroup_meta` | `readgroup_meta` | object containing the readgroup metadata |

* `readgroups_bam_file` - contains a BAM file and the associated readgroup metadata

| Name | Type | Description |
| ---- | ---- | ----------- |
| `bam` | `File` | the BAM file |
| `readgroup_meta_list` | `readgroup_meta[]` | array of objects containing the readgroup metadata |

* `readgroup_meta` - contains readgroup metadata

| Name | Type | Description |
| ---- | ---- | ----------- |
| `CN` | `string?` | optional sequencing center |
| `DS` | `string?` | optional description |
| `DT` | `string?` | optional ISO8601 sequencing date |
| `FO` | `string?` | optional flow order array of nocleotide bases that corresponded to the nucleotides used for each flow of each read |
| `ID` | `string` | required read group ID |
| `KS` | `string?` | optional array of nucleotide bases that correspond to the key sequence of each read |
| `LB` | `string?` | optional library ID |
| `PI` | `string?` | optional predicted median insert size |
| `PL` | `string` | required platform |
| `PM` | `string?` | optional platform model |
| `PU` | `string?` | optional platform unit |
| `SM` | `string` | required sample ID |

### Outputs

| Name | Type | Description |
| ---- | ---- | ----------- |
| `output_bam` | `File` | harmonized and indexed BAM file |
| `sqlite` | `File` | sqlite file containing metrics data |

## GDC Users

The entrypoint CWL workflow for GDC users is `workflows/gdc_dnaseq.bamfastq_align.workflow.cwl`.
