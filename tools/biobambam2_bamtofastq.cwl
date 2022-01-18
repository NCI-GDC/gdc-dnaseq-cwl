cwlVersion: v1.0
class: CommandLineTool
id: biobambam2_bamtofastq
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/biobambam:533ed9be5fd34b177b5a906262c615bff1a4cdc2c84b78c2244cbd7283842120
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 2000
    ramMax: 2000
    tmpdirMin: $(Math.ceil(0.9 * inputs.filename.size / 1048576))
    tmpdirMax: $(Math.ceil(0.9 * inputs.filename.size / 1048576))
    outdirMin: $(Math.ceil(0.9 * inputs.filename.size / 1048576))
    outdirMax: $(Math.ceil(0.9 * inputs.filename.size / 1048576))

inputs:
  collate:
    type: int
    default: 1
    inputBinding:
      prefix: collate=
      separate: false

  exclude:
    type: string
    default: QCFAIL,SECONDARY,SUPPLEMENTARY
    inputBinding:
      prefix: exclude=
      separate: false

  filename:
    type: File
    inputBinding:
      prefix: filename=
      separate: false

  gz:
    type: int
    default: 1
    inputBinding:
      prefix: gz=
      separate: false

  inputformat:
    type: string
    default: "bam"
    inputBinding:
      prefix: inputformat=
      separate: false

  level:
    type: int
    default: 5
    inputBinding:
      prefix: level=
      separate: false

  outputdir:
    type: string
    default: .
    inputBinding:
      prefix: outputdir=
      separate: false

  outputperreadgroup:
    type: int
    default: 1
    inputBinding:
      prefix: outputperreadgroup=
      separate: false

  outputperreadgroupsuffixF:
    type: string
    default: _1.fq.gz
    inputBinding:
      prefix: outputperreadgroupsuffixF=
      separate: false

  outputperreadgroupsuffixF2:
    type: string
    default: _2.fq.gz
    inputBinding:
      prefix: outputperreadgroupsuffixF2=
      separate: false

  outputperreadgroupsuffixO:
    type: string
    default: _o1.fq.gz
    inputBinding:
      prefix: outputperreadgroupsuffixO=
      separate: false

  outputperreadgroupsuffixO2:
    type: string
    default: _o2.fq.gz
    inputBinding:
      prefix: outputperreadgroupsuffixO2=
      separate: false

  outputperreadgroupsuffixS:
    type: string
    default: _s.fq.gz
    inputBinding:
      prefix: outputperreadgroupsuffixS=
      separate: false

  tryoq:
    type: int
    default: 1
    inputBinding:
      prefix: tryoq=
      separate: false

  T:
    type: string
    default: tempfq
    inputBinding:
      prefix: T=
      separate: false

outputs:
  output_fastq1:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*_1.fq.gz"
      outputEval: |
        ${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }

  output_fastq2:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*_2.fq.gz"
      outputEval: |
        ${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }

  output_fastq_o1:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*_o1.fq.gz"
      outputEval: |
        ${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }

  output_fastq_o2:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*_o2.fq.gz"
      outputEval: |
        ${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }

  output_fastq_s:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*_s.fq.gz"
      outputEval: |
        ${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }

baseCommand: [/usr/local/bin/bamtofastq]
