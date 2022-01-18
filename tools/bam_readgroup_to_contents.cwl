cwlVersion: v1.0
class: CommandLineTool
id: bam_readgroup_to_contents
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bam_readgroup_to_json:685e4954df4d70f89315a256ecfb707a2dd80b9fcf0d8d10918398df938c6a28
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.yml

inputs:
  INPUT:
    type: File
    inputBinding:
      prefix: --bam_path

  MODE:
    type: string
    default: strict
    inputBinding:
      prefix: --mode

outputs:
  OUTPUT:
    type:
      type: array
      items: string
    outputBinding:
      glob: "*.json"
      outputEval: |
        ${
          var output_array = [];
          for (var i = 0; i < self.length; i++) {
            var data = self[i].contents;
            output_array.push(data);
          }
          return output_array;
        }
      loadContents: true

  log:
    type: File
    outputBinding:
      glob: "output.log"

baseCommand: [/usr/local/bin/bam_readgroup_to_json]
