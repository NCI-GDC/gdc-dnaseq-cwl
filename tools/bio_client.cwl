#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-client:latest
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement

inputs:
  - id: config
    type: File
    inputBinding:
      prefix: --config-file

  - id: aws_shared_credentials
    type: File
  
  - id: endpoint_json
    type: File
    inputBinding:
      loadContents: true
      valueFrom: $(null)

  - id: input
    type: File

  - id: s3cfg_section
    type: string
    
  - id: s3uri
    type: string

outputs:
  - id: output
    type: File
    outputBinding:
      glob: "output"

arguments:
  - valueFrom: |
      ${
      var endpoint_json = JSON.parse(inputs.endpoint_json.contents);
      var endpoint_url = String(endpoint_json[inputs.s3cfg_section]);
      var endpoint = endpoint_url.replace("http://","");
      var dig_cmd = ["dig", "+short", endpoint, "|", "grep", "-E", "'[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'", "|", "shuf", "-n1"];
      var shell_dig = "http://" + "`" + dig_cmd.join(' ') + "`";
      var cmd = ["aws", "s3", "cp", "--profile", inputs.s3cfg_section, "--endpoint-url", shell_dig, inputs.input.path, inputs.s3uri];
      var shell_cmd = cmd.join(' ');
      return shell_cmd
      }
    position: 0

stdout: "output"
    
baseCommand: [/usr/local/bin/bio_client.py]
