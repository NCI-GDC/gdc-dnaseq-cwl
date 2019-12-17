cwlVersion: v1.0
class: ExpressionTool
id: decider_markdup_output 
requirements:
  - class: InlineJavascriptRequirement

inputs:
  markdup_bam: 
    format: "edam:format_2572"
    type: File[]
  markdup_sqlite: File[]
  skip_markdup_bam: 
    format: "edam:format_2572"
    type: File[]

outputs:
  bam:
    format: "edam:format_2572"
    type: File
    secondaryFiles:
      - "^.bai"

  sqlite: File?

expression: |
  ${
     if(inputs.markdup_bam.length == 1) {
       return({'bam': inputs.markdup_bam[0],
               'sqlite': inputs.markdup_sqlite[0]}); 
     } else if(inputs.skip_markdup_bam.length == 1) {
       return({'bam': inputs.skip_markdup_bam[0],
               'sqlite': null}) 
     } else {
       throw "Either markdup bam or skip markdup bam arrays have to be length 1"
     }
   }
