cwlVersion: v1.0
class: CommandLineTool
id: merge_sqlite
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/merge_sqlite:1b3a6f55be8579ecfb4c9c0513c3b710717a8f4cd8e79c88ee8c0f28f604faa3
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: |
      ${
      var req_space = 0;
      for (var i = 0; i < inputs.source_sqlite.length; i++) {
          req_space += inputs.source_sqlite[i].size;
        }
      return Math.ceil(2 * (req_space / 1048576));
      }      
    outdirMin: |
      ${
      var req_space = 0;
      for (var i = 0; i < inputs.source_sqlite.length; i++) {
          req_space += inputs.source_sqlite[i].size;
        }
      return Math.ceil(req_space / 1048576);
      }      

inputs:
  source_sqlite:
    format: "edam:format_3621"
    type:
      type: array
      items: File
      inputBinding:
        prefix: "--source_sqlite"

  job_uuid:
    type: string
    inputBinding:
      prefix: "--job_uuid"

outputs:
  destination_sqlite:
    format: "edam:format_3621"
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + ".db")

  log:
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + ".log")

baseCommand: [/usr/local/bin/merge_sqlite]
