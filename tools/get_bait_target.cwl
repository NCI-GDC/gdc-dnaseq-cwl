#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/jeremiahsavage/gdc_bam_library_exomekit
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: capturekey
    type: string

outputs:
  - id: bait
    type: File
    outputBinding:
      glob: "*bait*"

  - id: target
    type: File
    outputBinding:
      glob: "*target*"

arguments:
  - valueFrom: |
      ${
      var cmd="exec(\"import lzma; import json; import subprocess\\nwith open('/usr/local/share/bait_target_key_interval.json') as data_file: data = json.load(data_file)\\nbait = data['bait']['" + inputs.capturekey + "']\\ncmd=['unxz', '-c', '/usr/local/share/intervals/' + bait + '.xz', '>', bait]\\nshell_cmd=' '.join(cmd)\\nsubprocess.check_output(shell_cmd,shell=True)\\ntarget = data['target']['" + inputs.capturekey + "']\\ncmd=['unxz', '-c', '/usr/local/share/intervals/' + target + '.xz', '>', target]\\nshell_cmd=' '.join(cmd)\\nsubprocess.check_output(shell_cmd,shell=True)\")";
      return cmd
      }

baseCommand: [python3, -c]
