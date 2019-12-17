cwlVersion: v1.0
class: ExpressionTool
id: decider_markdup_input 
requirements:
  - class: InlineJavascriptRequirement

inputs:
  run_markdups: boolean
  bam: 
    format: "edam:format_2572"
    type:
      type: array
      items:
        type: array
        items: File
  
outputs:
  do_markdup_workflow: long[]
  skip_markdup_workflow: long[]
  out_bam:
    format: "edam:format_2572"
    type: File[]

expression: |
  ${
     var bams = [];
     for(var i = 0; i < inputs.bam.length; i++) {
       for(var j = 0; j < inputs.bam[i].length; j++) {
         if(inputs.bam[i][j].size > 0) {
           bams.push(inputs.bam[i][j])
         }
       }
     }

     if( inputs.run_markdups ) {
       return({
         'do_markdup_workflow': [1],
         'skip_markdup_workflow': [],
         'out_bam': bams
       });
     } else {
       return({
         'do_markdup_workflow': [],
         'skip_markdup_workflow': [1],
         'out_bam': bams
       });
     }
   }
