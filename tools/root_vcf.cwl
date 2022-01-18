cwlVersion: v1.0
class: CommandLineTool
id: root_vcf
requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:bionic-20180426
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.vcf.basename)
        entry: $(inputs.vcf)
      - entryname: $(inputs.vcf_index.basename)
        entry: $(inputs.vcf_index)
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 500
    ramMax: 500
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1

inputs:
  vcf: File
  vcf_index: File

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.vcf.basename)
    secondaryFiles:
      - .tbi

baseCommand: "true"
