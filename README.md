# GDC DNA-Seq Alignment Workflow
![Version badge](https://img.shields.io/badge/biobambam-2.0.87-yellowgreen.svg)
![Version badge](https://img.shields.io/badge/BWA-0.7.15-yellowgreen.svg)
![Version badge](https://img.shields.io/badge/GATK-4.2.4.1-brightgreen.svg)<br>
![Version badge](https://img.shields.io/badge/samtools-1.8-yellowgreen.svg)
![Version badge](https://img.shields.io/badge/FastQC-v0.11.7-yellowgreen.svg)
![Version badge](https://img.shields.io/badge/Picard-2.26.10-brightgreen.svg)<br>

This workflow takes a set of input WGS/WXS/Targeted Sequencing FASTQ/BAM files and generates
a harmonized BAM file and an sqlite database of various metrics collected.
## License Note
This repository is licensed under Apache License Version 2.0. Exceptions are code blocks licensed under CC-BY-SA-4.0. <br>
The CC-BY-SA-4.0 code blocks are denoted by `/begin <AUTHOR> CC-BY-SA-4.0` to `/end <AUTHOR> CC-BY-SA-4.0`.

## Pre-requisites
- Docker
- [just](https://github.com/casey/just)
- `jq` (recommended)
- Activated python3.8+ virtualenv

`just init` will install the correct version of `cwltool`, `jinja-cli`, and `pre-commit`, be sure to have a python3.8+ virtual environment active.

`just build-all` will build and validate all workflows in the repo.

These workflows are developed and tested on Ubuntu. 

* Ubuntu 20.04

The CWL is developed for `cwltools` version `3.1.20230213100550`
<br>
https://www.commonwl.org/ <br>

## Environment

## Repository Structure

### Top-level

The top level of the workflow repository should contain a `justfile`, `build.sh` script, and a `.gitlab-ci.yml` config.

Small CWL scripts not specific to any workflow should be stored in a top-level `tools` directory. These can include general shell commands and `CommandLine` workflows to call bioinformatics tools.

__NOTICE__: This `tools` directory will be copied to the root of the Docker image. Relative path references to CWL in tools will remain valid in both the repo filesystem and docker image filesystem.

Eventually these tooling CWL scripts will be stored in a common library.

The `build.sh` script is used to automatically build and publish images in a CI environment.

The `justfile` contains commands to locally build workflow images, run `just -l` for a full list of commands.

Individual workflow CWL scripts should be stored within top-level directories named after the workflow.

### Workflow Subdirectory

Each workflow directory should also contain the template justfile and Dockerfile.

The `ENTRY_CWL` should be updated with the path to the main workflow cwl script, relative to the workflow directory.

This CWL script will be used as the argument to the `cwltool --pack` command, but can be overwritten using `make pack ENTRY_CWL=...`

The CWL scripts comprising a workflow can be stored under any manner of directory structure.

Ideally any CWL script referenced by another file is in the same directory or a subdirectory of the calling script. (Essentially do not traverse up a directory, only sideways and/or down).

This will enable moving an entire subdirectory, if needed, without needing to update any references contained within.


## GDC Users

There are two entry points:
 - harmonization of FASTQ and BAM data: `gdc-dnaseq-aln-cwl/gdc_dnaseq.bamfastq_align.workflow.cwl`.
 - trusted pre-aligned data: `gdc-dnaseq-prealn-cwl/gdc_dnaseq.aligned_reads.workflow.cwl`.

## For external users

The repository has only been tested on GDC data and in the particular environment GDC is running in. Some of the reference data required for the workflow production are hosted in [GDC reference files](https://gdc.cancer.gov/about-data/data-harmonization-and-generation/gdc-reference-files "GDC reference files"). For any questions related to GDC data, please contact the GDC Help Desk at support@nci-gdc.datacommons.io.

The entrypoint CWL workflow for external users is `subworkflows/main/gdc_dnaseq_main_workflow.cwl`.

With the updates to the workflow builds, the easiest way to run this workflow externally is to:

1. Pack the workflow into a single JSON file via `cwltool pack subworkflows/main/gdc_dnaseq_main_workflow.cwl > gdc_dnaseq_main_workflow.tmp`
2. Update the `dockerPull` template strings: `jinja -u 'strict' -d gdc-dnaseq-aln-cwl/dockers.json gdc_dnaseq_main_workflow.tmp > gdc_dnaseq_main_workflow.json`

Alternatively, fork this repo and make any necessary updates locally.

An example input yaml is available here: `example/gdc_dnaseq_main_workflow_example_input.yaml`.

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

Further documentation available [here](https://docs.google.com/document/d/17NFwGvn4vMEXZV9Qmg30BqAcKrdxBYCOB4pFdkkwIIo/edit#)

# Using this template

This template repository should be used as the base for new workflow repositories which will use the new Docker packaging scheme.

# CWL Workflow Development

## Pre-requisites

- Docker
- [just](https://github.com/casey/just)
- `jq` (recommended)

`just init` will install the correct version of `cwltool`, `jinja-cli`, and `pre-commit`, be sure to have a python3.8+ virtual environment active.

`just build-all` will build and validate all workflows in the repo.

## Just

The `just` utility is a command runner replacement for `make`.

It has various improvements over `make` including the ability to list available command with `just -l`:

### Root Justfile

```
Available recipes:
    build WORKFLOW # Builds individual workflow
    build-all      # Builds all docker images for each directory with a justfile
    init
    pack WORKFLOW  # Builds Docker for WORKFLOW and prints packed JSON
```

The root `justfile` provides recipes for Dockerizing workflows locally, while workflow-level `justfiles` provide recipes for building the workflow.

### Workflow Justfile

The workflow-level `justfile` requires the `ENTRY_CWL` path be updated.

```
# justfile
ENTRY_CWL := "workflow.cwl"
```

Certain recipes check if the `ENTRY_CWL` file exists, and will show an error message if not.

```
Available recipes:
    get-dockers          # Formats and prints all Dockers used in workflow
    get-dockers-template # Prints all dockerPull declarations in unformatted workflow
    inputs               # Print template input file for workflow
    pack                 # Pack and apply Jinja templating. Creates cwl.json file
    validate             # Validates CWL workflow
```

Some important commands for workflow development:

`just validate` will run cwltool's validation and show any errors in the CWL.

`just inputs` will output a template input file for the workflow.

`just get-dockers-template` will pack the workflow to JSON and print all unique dockerPull declarations.

This command is useful for building the `dockers.json` file or finding un-templated image strings.

`just get-dockers` will pack the workflow to JSON and apply the Docker formatting.

No template strings should remain after formatting.

## dockerPull Jinja Templates

For CommandLineTool workflows utilizing `dockerPull`, the docker image should be specified in CWL as a jinja-compatible template string.

`dockerPull: "{{ docker_repository }}/image_name:{{ image_name }}"`

__NOTICE__: Double quotes required

Within each workflow's `justfile` is the `just pack` command which:

1. Packs the CWL workflow into a temporary JSON file
2. Uses `jinja-cli` and the `dockers.json` file to replace each template string
3. Saves the result to `cwl.json`

------

### `dockers.json`

```json
{
        "docker_repository": "docker.osdc.io/ncigdc",
        "image_name": "abcdef"
}
```

This JSON file combined with the example string above will result in a final string:

`dockerPull: "docker.osdc.io/ncigdc/image_name:abcdef`

in the packed cwl.json file.

------

While this prevents the CWL from being used directly, it enables easy updating of multiple Docker images for GPAS, and allows external users to supply their own images/tags.


