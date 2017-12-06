{
    "cwlVersion": "v1.0", 
    "$graph": [
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "fedora:26"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }, 
                {
                    "class": "ResourceRequirement", 
                    "coresMin": 1, 
                    "coresMax": 1
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#awk.cwl/INPUT", 
                    "type": "File", 
                    "inputBinding": {
                        "position": 1
                    }
                }, 
                {
                    "id": "#awk.cwl/EXPRESSION", 
                    "type": "string", 
                    "inputBinding": {
                        "position": 0
                    }
                }, 
                {
                    "id": "#awk.cwl/OUTFILE", 
                    "type": "string"
                }
            ], 
            "outputs": [
                {
                    "id": "#awk.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.OUTFILE)"
                    }
                }
            ], 
            "stdout": "$(inputs.OUTFILE)", 
            "baseCommand": [
                "awk"
            ], 
            "id": "#awk.cwl"
        }, 
        {
            "class": "CommandLineTool", 
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/awscli:ef005e74478e9a2fb3ce638cbfa6199e88b322abd0934ba0586980a9f45fc052"
                }, 
                {
                    "class": "EnvVarRequirement", 
                    "envDef": [
                        {
                            "envName": "AWS_CONFIG_FILE", 
                            "envValue": "$(inputs.aws_config.path)"
                        }, 
                        {
                            "envName": "AWS_SHARED_CREDENTIALS_FILE", 
                            "envValue": "$(inputs.aws_shared_credentials.path)"
                        }
                    ]
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }, 
                {
                    "class": "ShellCommandRequirement"
                }
            ], 
            "inputs": [
                {
                    "id": "#aws_s3_put.cwl/aws_config", 
                    "type": "File"
                }, 
                {
                    "id": "#aws_s3_put.cwl/aws_shared_credentials", 
                    "type": "File"
                }, 
                {
                    "id": "#aws_s3_put.cwl/endpoint_json", 
                    "type": "File", 
                    "inputBinding": {
                        "loadContents": true, 
                        "valueFrom": "$(null)"
                    }
                }, 
                {
                    "id": "#aws_s3_put.cwl/input", 
                    "type": "File"
                }, 
                {
                    "id": "#aws_s3_put.cwl/s3cfg_section", 
                    "type": "string"
                }, 
                {
                    "id": "#aws_s3_put.cwl/s3uri", 
                    "type": "string"
                }
            ], 
            "outputs": [
                {
                    "id": "#aws_s3_put.cwl/output", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "output"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "${\nvar endpoint_json = JSON.parse(inputs.endpoint_json.contents);\nvar endpoint_url = String(endpoint_json[inputs.s3cfg_section]);\nvar endpoint = endpoint_url.replace(\"http://\",\"\");\nvar dig_cmd = [\"dig\", \"+short\", endpoint, \"|\", \"grep\", \"-E\", \"'[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}'\", \"|\", \"shuf\", \"-n1\"];\nvar shell_dig = \"http://\" + \"`\" + dig_cmd.join(' ') + \"`\";\nvar cmd = [\"aws\", \"s3\", \"cp\", \"--profile\", inputs.s3cfg_section, \"--endpoint-url\", shell_dig, inputs.input.path, inputs.s3uri];\nvar shell_cmd = cmd.join(' ');\nreturn shell_cmd\n}\n", 
                    "position": 0
                }
            ], 
            "stdout": "output", 
            "baseCommand": [
                "bash", 
                "-c"
            ], 
            "id": "#aws_s3_put.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/bam_readgroup_to_json:9850b6456aaa5011512b2e5574e8eef2622d7a31d2ed878770bd1259412e807e"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#bam_readgroup_to_json.cwl/INPUT", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "inputBinding": {
                        "prefix": "--bam_path"
                    }
                }, 
                {
                    "id": "#bam_readgroup_to_json.cwl/MODE", 
                    "type": "string", 
                    "default": "strict", 
                    "inputBinding": {
                        "prefix": "--mode"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#bam_readgroup_to_json.cwl/OUTPUT", 
                    "format": "edam:format_3464", 
                    "type": {
                        "type": "array", 
                        "items": "File"
                    }, 
                    "outputBinding": {
                        "glob": "*.json", 
                        "outputEval": "${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }\n"
                    }
                }, 
                {
                    "id": "#bam_readgroup_to_json.cwl/log", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "output.log"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/bam_readgroup_to_json"
            ], 
            "id": "#bam_readgroup_to_json.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/bam_reheader:2a404a0eabc344da137e6573a7e6cdb0cacb646e386261bfbcdf0990422a5096"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#bam_reheader.cwl/input", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "inputBinding": {
                        "prefix": "--bam_path"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#bam_reheader.cwl/output", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "outputBinding": {
                        "glob": "$(inputs.input.basename)"
                    }
                }, 
                {
                    "id": "#bam_reheader.cwl/log", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.input.basename + \".log\")"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/bam_reheader"
            ], 
            "id": "#bam_reheader.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/biobambam:5f20c171e7f2b2a0a6e11d65dff5d8c2efafd2e09c26ab19695f6a47a438e823"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#biobambam2_bamtofastq.cwl/collate", 
                    "type": "int", 
                    "default": 1, 
                    "inputBinding": {
                        "prefix": "collate=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/exclude", 
                    "type": "string", 
                    "default": "QCFAIL,SECONDARY,SUPPLEMENTARY", 
                    "inputBinding": {
                        "prefix": "exclude=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/filename", 
                    "format": "edam:format_2572", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "filename=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/gz", 
                    "type": "int", 
                    "default": 1, 
                    "inputBinding": {
                        "prefix": "gz=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/inputformat", 
                    "type": "string", 
                    "default": "bam", 
                    "inputBinding": {
                        "prefix": "inputformat=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/level", 
                    "type": "int", 
                    "default": 5, 
                    "inputBinding": {
                        "prefix": "level=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/outputdir", 
                    "type": "string", 
                    "default": ".", 
                    "inputBinding": {
                        "prefix": "outputdir=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/outputperreadgroup", 
                    "type": "int", 
                    "default": 1, 
                    "inputBinding": {
                        "prefix": "outputperreadgroup=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/outputperreadgroupsuffixF", 
                    "type": "string", 
                    "default": "_1.fq.gz", 
                    "inputBinding": {
                        "prefix": "outputperreadgroupsuffixF=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/outputperreadgroupsuffixF2", 
                    "type": "string", 
                    "default": "_2.fq.gz", 
                    "inputBinding": {
                        "prefix": "outputperreadgroupsuffixF2=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/outputperreadgroupsuffixO", 
                    "type": "string", 
                    "default": "_o1.fq.gz", 
                    "inputBinding": {
                        "prefix": "outputperreadgroupsuffixO=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/outputperreadgroupsuffixO2", 
                    "type": "string", 
                    "default": "_o2.fq.gz", 
                    "inputBinding": {
                        "prefix": "outputperreadgroupsuffixO2=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/outputperreadgroupsuffixS", 
                    "type": "string", 
                    "default": "_s.fq.gz", 
                    "inputBinding": {
                        "prefix": "outputperreadgroupsuffixS=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/tryoq", 
                    "type": "int", 
                    "default": 1, 
                    "inputBinding": {
                        "prefix": "tryoq=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/T", 
                    "type": "string", 
                    "default": "tempfq", 
                    "inputBinding": {
                        "prefix": "T=", 
                        "separate": false
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#biobambam2_bamtofastq.cwl/output_fastq1", 
                    "format": "edam:format_2182", 
                    "type": {
                        "type": "array", 
                        "items": "File"
                    }, 
                    "outputBinding": {
                        "glob": "*_1.fq.gz", 
                        "outputEval": "${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }\n"
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/output_fastq2", 
                    "format": "edam:format_2182", 
                    "type": {
                        "type": "array", 
                        "items": "File"
                    }, 
                    "outputBinding": {
                        "glob": "*_2.fq.gz", 
                        "outputEval": "${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }\n"
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/output_fastq_o1", 
                    "format": "edam:format_2182", 
                    "type": {
                        "type": "array", 
                        "items": "File"
                    }, 
                    "outputBinding": {
                        "glob": "*_o1.fq.gz", 
                        "outputEval": "${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }\n"
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/output_fastq_o2", 
                    "format": "edam:format_2182", 
                    "type": {
                        "type": "array", 
                        "items": "File"
                    }, 
                    "outputBinding": {
                        "glob": "*_o2.fq.gz", 
                        "outputEval": "${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }\n"
                    }
                }, 
                {
                    "id": "#biobambam2_bamtofastq.cwl/output_fastq_s", 
                    "format": "edam:format_2182", 
                    "type": {
                        "type": "array", 
                        "items": "File"
                    }, 
                    "outputBinding": {
                        "glob": "*_s.fq.gz", 
                        "outputEval": "${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }\n"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/bamtofastq"
            ], 
            "id": "#biobambam2_bamtofastq.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/bwa:fac166f93639cbbd4f19db5d07eaf9fa0e1e31f667dd6375d3fc1c995992cd49"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }, 
                {
                    "class": "ShellCommandRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#bwa_pe.cwl/fastq1", 
                    "type": "File", 
                    "format": "edam:format_2182"
                }, 
                {
                    "id": "#bwa_pe.cwl/fastq2", 
                    "type": "File", 
                    "format": "edam:format_2182"
                }, 
                {
                    "id": "#bwa_pe.cwl/fasta", 
                    "type": "File", 
                    "format": "edam:format_1929", 
                    "secondaryFiles": [
                        ".amb", 
                        ".ann", 
                        ".bwt", 
                        ".pac", 
                        ".sa"
                    ]
                }, 
                {
                    "id": "#bwa_pe.cwl/readgroup_json_path", 
                    "type": "File", 
                    "format": "edam:format_3464", 
                    "inputBinding": {
                        "loadContents": true, 
                        "valueFrom": "$(null)"
                    }
                }, 
                {
                    "id": "#bwa_pe.cwl/fastqc_json_path", 
                    "type": "File", 
                    "format": "edam:format_3464", 
                    "inputBinding": {
                        "loadContents": true, 
                        "valueFrom": "$(null)"
                    }
                }, 
                {
                    "id": "#bwa_pe.cwl/thread_count", 
                    "type": "long"
                }
            ], 
            "outputs": [
                {
                    "id": "#bwa_pe.cwl/OUTPUT", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "outputBinding": {
                        "glob": "$(inputs.readgroup_json_path.basename.slice(0,-4) + \"bam\")"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "${\n  function to_rg() {\n    var readgroup_str = \"@RG\";\n    var readgroup_json = JSON.parse(inputs.readgroup_json_path.contents);\n    var keys = Object.keys(readgroup_json).sort();\n    for (var i = 0; i < keys.length; i++) {\n      var key = keys[i];\n      var value = readgroup_json[key];\n      readgroup_str = readgroup_str + \"\\\\t\" + key + \":\" + value;\n    }\n    return readgroup_str\n  }\n\n  function bwa_aln_33(rg_str, outbam) {\n    var cmd = [\n    \"bwa\", \"aln\", \"-t\", inputs.thread_count, inputs.fasta.path, inputs.fastq1.path, \">\", \"aln.sai1\", \"&&\",\n    \"bwa\", \"aln\", \"-t\", inputs.thread_count, inputs.fasta.path, inputs.fastq2.path, \">\", \"aln.sai2\", \"&&\",\n    \"bwa\", \"sampe\", \"-r\", \"\\\"\" + rg_str + \"\\\"\", inputs.fasta.path, \"aln.sai1\", \"aln.sai2\", inputs.fastq1.path, inputs.fastq2.path, \"|\",\n    \"samtools\", \"view\", \"-Shb\", \"-o\", outbam, \"-\"\n    ];\n    return cmd.join(' ')\n  }\n\n  function bwa_aln_64(rg_str, outbam) {\n    var cmd = [\n    \"bwa\", \"aln\", \"-I\",\"-t\", inputs.thread_count, inputs.fasta.path, inputs.fastq1.path, \">\", \"aln.sai1\", \"&&\",\n    \"bwa\", \"aln\", \"-I\", \"-t\", inputs.thread_count, inputs.fasta.path, inputs.fastq2.path, \">\", \"aln.sai2\", \"&&\",\n    \"bwa\", \"sampe\", \"-r\", \"\\\"\" + rg_str + \"\\\"\", inputs.fasta.path, \"aln.sai1\", \"aln.sai2\", inputs.fastq1.path, inputs.fastq2.path, \"|\",\n    \"samtools\", \"view\", \"-Shb\", \"-o\", outbam, \"-\"\n    ];\n    return cmd.join(' ')\n  }\n\n  function bwa_mem(rg_str, outbam) {\n    var cmd = [\n    \"bwa\", \"mem\", \"-t\", inputs.thread_count, \"-T\", \"0\", \"-R\", \"\\\"\" + rg_str + \"\\\"\",\n    inputs.fasta.path, inputs.fastq1.path, inputs.fastq2.path, \"|\",\n    \"samtools\", \"view\", \"-Shb\", \"-o\", outbam, \"-\"\n    ];\n    return cmd.join(' ')\n  }\n\n  var MEM_ALN_CUTOFF = 70;\n  var fastqc_json = JSON.parse(inputs.fastqc_json_path.contents);\n  var readlength = fastqc_json[inputs.fastq1.basename][\"Sequence length\"];\n  var encoding = fastqc_json[inputs.fastq1.basename][\"Encoding\"];\n  var rg_str = to_rg();\n\n  var outbam = inputs.readgroup_json_path.basename.slice(0,-4) + \"bam\";\n  \n  if (encoding == \"Illumina 1.3\" || encoding == \"Illumina 1.5\") {\n    return bwa_aln_64(rg_str, outbam)\n  } else if (encoding == \"Sanger / Illumina 1.9\") {\n    if (readlength < MEM_ALN_CUTOFF) {\n      return bwa_aln_33(rg_str, outbam)\n    }\n    else {\n      return bwa_mem(rg_str, outbam)\n    }\n  } else {\n    return\n  }\n\n}\n"
                }
            ], 
            "baseCommand": [
                "bash", 
                "-c"
            ], 
            "id": "#bwa_pe.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                }, 
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/bwa:fac166f93639cbbd4f19db5d07eaf9fa0e1e31f667dd6375d3fc1c995992cd49"
                }, 
                {
                    "class": "ShellCommandRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#bwa_se.cwl/fastq", 
                    "type": "File", 
                    "format": "edam:format_2182"
                }, 
                {
                    "id": "#bwa_se.cwl/fasta", 
                    "type": "File", 
                    "format": "edam:format_1929", 
                    "secondaryFiles": [
                        ".amb", 
                        ".ann", 
                        ".bwt", 
                        ".pac", 
                        ".sa"
                    ]
                }, 
                {
                    "id": "#bwa_se.cwl/readgroup_json_path", 
                    "type": "File", 
                    "inputBinding": {
                        "loadContents": true, 
                        "valueFrom": "$(null)"
                    }
                }, 
                {
                    "id": "#bwa_se.cwl/fastqc_json_path", 
                    "type": "File", 
                    "inputBinding": {
                        "loadContents": true, 
                        "valueFrom": "$(null)"
                    }
                }, 
                {
                    "id": "#bwa_se.cwl/samse_maxOcc", 
                    "type": "long", 
                    "default": 3
                }, 
                {
                    "id": "#bwa_se.cwl/thread_count", 
                    "type": "long"
                }
            ], 
            "outputs": [
                {
                    "id": "#bwa_se.cwl/OUTPUT", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "outputBinding": {
                        "glob": "$(inputs.readgroup_json_path.basename.slice(0,-4) + \"bam\")"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "${\n  function to_rg() {\n    var readgroup_str = \"@RG\";\n    var readgroup_json = JSON.parse(inputs.readgroup_json_path.contents);\n    var keys = Object.keys(readgroup_json).sort();\n    for (var i = 0; i < keys.length; i++) {\n      var key = keys[i];\n      var value = readgroup_json[key];\n      readgroup_str = readgroup_str + \"\\\\t\" + key + \":\" + value;\n    }\n    return readgroup_str\n  }\n\n  function bwa_aln_33(rg_str, outbam) {\n    var cmd = [\n    \"bwa\", \"aln\", \"-t\", inputs.thread_count, inputs.fasta.path, inputs.fastq.path, \">\", \"aln.sai\", \"&&\",\n    \"bwa\", \"samse\", \"-n\", inputs.samse_maxOcc, \"-r\", \"\\\"\" + rg_str + \"\\\"\", inputs.fasta.path, \"aln.sai\", inputs.fastq.path, \"|\",\n    \"samtools\", \"view\", \"-Shb\", \"-o\", outbam, \"-\"\n    ];\n    return cmd.join(' ')\n  }\n\n  function bwa_aln_64(rg_str, outbam) {\n    var cmd = [\n    \"bwa\", \"aln\", \"-I\",\"-t\", inputs.thread_count, inputs.fasta.path, inputs.fastq.path, \">\", \"aln.sai\", \"&&\",\n    \"bwa\", \"samse\", \"-n\", inputs.samse_maxOcc, \"-r\", \"\\\"\" + rg_str + \"\\\"\", inputs.fasta.path, \"aln.sai\", inputs.fastq.path, \"|\",\n    \"samtools\", \"view\", \"-Shb\", \"-o\", outbam, \"-\"\n    ];\n    return cmd.join(' ')\n  }\n\n  function bwa_mem(rg_str, outbam) {\n    var cmd = [\n    \"bwa\", \"mem\", \"-t\", inputs.thread_count, \"-T\", \"0\", \"-R\", \"\\\"\" + rg_str + \"\\\"\",\n    inputs.fasta.path, inputs.fastq.path, \"|\",\n    \"samtools\", \"view\", \"-Shb\", \"-o\", outbam, \"-\"\n    ];\n    return cmd.join(' ')\n  }\n\n  var MEM_ALN_CUTOFF = 70;\n  var fastqc_json = JSON.parse(inputs.fastqc_json_path.contents);\n  var readlength = fastqc_json[inputs.fastq.basename][\"Sequence length\"];\n  var encoding = fastqc_json[inputs.fastq.basename][\"Encoding\"];\n  var rg_str = to_rg();\n\n  var outbam = inputs.readgroup_json_path.basename.slice(0,-4) + \"bam\";\n\n  if (encoding == \"Illumina 1.3\" || encoding == \"Illumina 1.5\") {\n    return bwa_aln_64(rg_str, outbam)\n  } else if (encoding == \"Sanger / Illumina 1.9\") {\n    if (readlength < MEM_ALN_CUTOFF) {\n      return bwa_aln_33(rg_str, outbam)\n    }\n    else {\n      return bwa_mem(rg_str, outbam)\n    }\n  } else {\n    return\n  }\n\n}\n"
                }
            ], 
            "baseCommand": [
                "bash", 
                "-c"
            ], 
            "id": "#bwa_se.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "ExpressionTool", 
            "inputs": [
                {
                    "id": "#decider_bwa_expression.cwl/fastq_path", 
                    "format": "edam:format_2182", 
                    "type": {
                        "type": "array", 
                        "items": "File"
                    }
                }, 
                {
                    "id": "#decider_bwa_expression.cwl/readgroup_path", 
                    "format": "edam:format_3464", 
                    "type": {
                        "type": "array", 
                        "items": "File"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#decider_bwa_expression.cwl/output_readgroup_paths", 
                    "format": "edam:format_3464", 
                    "type": {
                        "type": "array", 
                        "items": "File"
                    }
                }
            ], 
            "expression": "${\n   function include(arr,obj) {\n     return (arr.indexOf(obj) != -1)\n   }\n\n   function endsWith(str, suffix) {\n     return str.indexOf(suffix, str.length - suffix.length) !== -1;\n   }\n\n   function local_basename(path) {\n     var basename = path.split(/[\\\\/]/).pop();\n     return basename\n   }\n\n   function local_dirname(path) {\n     return path.replace(/\\\\/g,'/').replace(/\\/[^\\/]*$/, '');\n   }\n\n   function get_slice_number(fastq_name) {\n     if (endsWith(fastq_name, '_1.fq.gz')) {\n       return -8\n     }\n     else if (endsWith(fastq_name, '_s.fq.gz')) {\n       return -8\n     }\n     else if (endsWith(fastq_name, '_o1.fq.gz')) {\n       return -9\n     }\n     else if (endsWith(fastq_name, '_o2.fq.gz')) {\n       return -9\n     }\n     else {\n       exit()\n     }\n   }\n   \n   // get predicted readgroup basenames from fastq\n   var readgroup_basename_array = [];\n   for (var i = 0; i < inputs.fastq_path.length; i++) {\n     var fq_path = inputs.fastq_path[i];\n     var fq_name = local_basename(fq_path.location);\n\n     var slice_number = get_slice_number(fq_name);\n     \n     var readgroup_name = fq_name.slice(0,slice_number) + \".json\";\n     readgroup_basename_array.push(readgroup_name);\n   }\n\n   // find which readgroup items are in predicted basenames\n   var readgroup_array = [];\n   for (var i = 0; i < inputs.readgroup_path.length; i++) {\n     var readgroup_path = inputs.readgroup_path[i];\n     var readgroup_basename = local_basename(readgroup_path.location);\n     if (include(readgroup_basename_array, readgroup_basename)) {\n       readgroup_array.push(readgroup_path);\n     }\n   }\n\n   var readgroup_sorted = readgroup_array.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) })\n   return {'output_readgroup_paths': readgroup_sorted}\n }\n", 
            "id": "#decider_bwa_expression.cwl"
        }, 
        {
            "class": "CommandLineTool", 
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/git-client:cd11e0475ba67cba39c5590533208bc38e82f5904b51ee487943f2b04f6c9469"
                }, 
                {
                    "class": "EnvVarRequirement", 
                    "envDef": [
                        {
                            "envName": "http_proxy", 
                            "envValue": "http://cloud-proxy:3128"
                        }, 
                        {
                            "envName": "https_proxy", 
                            "envValue": "http://cloud-proxy:3128"
                        }
                    ]
                }, 
                {
                    "class": "ShellCommandRequirement"
                }
            ], 
            "inputs": [
                {
                    "id": "#emit_git_hash.cwl/repo", 
                    "type": "string", 
                    "inputBinding": {
                        "position": 0
                    }
                }, 
                {
                    "id": "#emit_git_hash.cwl/branch", 
                    "type": "string", 
                    "inputBinding": {
                        "position": 1
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#emit_git_hash.cwl/output", 
                    "type": "string", 
                    "outputBinding": {
                        "glob": "output", 
                        "loadContents": true, 
                        "outputEval": "$(self[0].contents)"
                    }
                }
            ], 
            "stdout": "output", 
            "arguments": [
                {
                    "valueFrom": " | awk '{printf $1}'", 
                    "position": 2, 
                    "shellQuote": false
                }
            ], 
            "baseCommand": [
                "git", 
                "ls-remote"
            ], 
            "id": "#emit_git_hash.cwl"
        }, 
        {
            "class": "CommandLineTool", 
            "inputs": [], 
            "outputs": [
                {
                    "id": "#emit_host_ipaddress.cwl/output", 
                    "type": "string", 
                    "outputBinding": {
                        "glob": "output", 
                        "loadContents": true, 
                        "outputEval": "$(self[0].contents)"
                    }
                }
            ], 
            "stdout": "output", 
            "baseCommand": [
                "bash", 
                "-c", 
                "printf %s $(ip addr list eth0 | grep 'inet ' | cut -d' ' -f6 | cut -d/ -f1)"
            ], 
            "id": "#emit_host_ipaddress.cwl"
        }, 
        {
            "class": "CommandLineTool", 
            "inputs": [], 
            "outputs": [
                {
                    "id": "#emit_host_mac.cwl/output", 
                    "type": "string", 
                    "outputBinding": {
                        "glob": "output", 
                        "loadContents": true, 
                        "outputEval": "$(self[0].contents)"
                    }
                }
            ], 
            "stdout": "output", 
            "baseCommand": [
                "bash", 
                "-c", 
                "printf %s $(ip addr list eth0 | grep 'link/ether' | cut -d' ' -f6 | cut -d/ -f1)"
            ], 
            "id": "#emit_host_mac.cwl"
        }, 
        {
            "class": "CommandLineTool", 
            "inputs": [], 
            "outputs": [
                {
                    "id": "#emit_hostname.cwl/output", 
                    "type": "string", 
                    "outputBinding": {
                        "glob": "output", 
                        "loadContents": true, 
                        "outputEval": "$(self[0].contents)"
                    }
                }
            ], 
            "stdout": "output", 
            "baseCommand": [
                "bash", 
                "-c", 
                "printf %s $(hostname)"
            ], 
            "id": "#emit_hostname.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "ExpressionTool", 
            "inputs": [
                {
                    "id": "#emit_json.cwl/float_keys", 
                    "type": {
                        "type": "array", 
                        "items": "string"
                    }
                }, 
                {
                    "id": "#emit_json.cwl/float_values", 
                    "type": {
                        "type": "array", 
                        "items": "float"
                    }
                }, 
                {
                    "id": "#emit_json.cwl/long_keys", 
                    "type": {
                        "type": "array", 
                        "items": "string"
                    }
                }, 
                {
                    "id": "#emit_json.cwl/long_values", 
                    "type": {
                        "type": "array", 
                        "items": "long"
                    }
                }, 
                {
                    "id": "#emit_json.cwl/string_keys", 
                    "type": {
                        "type": "array", 
                        "items": "string"
                    }
                }, 
                {
                    "id": "#emit_json.cwl/string_values", 
                    "type": {
                        "type": "array", 
                        "items": "string"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#emit_json.cwl/output", 
                    "type": "string"
                }
            ], 
            "expression": "${\n\n  var OutputObject = {};\n  for (var i = 0; i < inputs.string_keys.length; i++) {\n    var key = inputs.string_keys[i];\n    var value = inputs.string_values[i];\n    OutputObject[key] = value;\n  }\n\n  for (var i = 0; i < inputs.long_keys.length; i++) {\n    var key = inputs.long_keys[i];\n    var value = parseInt(inputs.long_values[i]);\n    OutputObject[key] = value;\n  }\n\n  for (var i = 0; i < inputs.float_keys.length; i++) {\n    var key = inputs.float_keys[i];\n    var value = parseFloat(inputs.float_values[i]);\n    OutputObject[key] = value;\n  }\n\n  return {'output': JSON.stringify(OutputObject)}\n  //return {'output': OutputObject}\n}\n", 
            "id": "#emit_json.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/fastq_remove_duplicate_qname:5762be5de2178b6078621e09836019106c78b2e07bfdbcf2c74ab147fb844e34"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }, 
                {
                    "class": "ShellCommandRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#fastq_remove_duplicate_qname.cwl/INPUT", 
                    "type": "File", 
                    "format": "edam:format_2182"
                }
            ], 
            "outputs": [
                {
                    "id": "#fastq_remove_duplicate_qname.cwl/OUTPUT", 
                    "type": "File", 
                    "format": "edam:format_2182", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.basename)"
                    }
                }, 
                {
                    "id": "#fastq_remove_duplicate_qname.cwl/METRICS", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "fastq_dup_rm.log"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "${\n  var cmd = [\n  \"zcat\", inputs.INPUT.path, \"|\",\n  \"/usr/local/bin/fastq_remove_duplicate_qname\", \"-\", \"|\",\n  \"gzip\", \"-\", \">\", inputs.INPUT.basename\n  ];\n  return cmd.join(' ')\n}\n"
                }
            ], 
            "baseCommand": [
                "bash", 
                "-c"
            ], 
            "id": "#fastq_remove_duplicate_qname.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/fastqc:9c853425fffb39da6084fb131f1bbe561648b1eb792204e68b50e94f05a6976f"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#fastqc.cwl/adapters", 
                    "type": [
                        "null", 
                        "File"
                    ], 
                    "inputBinding": {
                        "prefix": "--adapters"
                    }
                }, 
                {
                    "id": "#fastqc.cwl/casava", 
                    "type": "boolean", 
                    "default": false, 
                    "inputBinding": {
                        "prefix": "--casava"
                    }
                }, 
                {
                    "id": "#fastqc.cwl/contaminants", 
                    "type": [
                        "null", 
                        "File"
                    ], 
                    "inputBinding": {
                        "prefix": "--contaminants"
                    }
                }, 
                {
                    "id": "#fastqc.cwl/dir", 
                    "type": "string", 
                    "default": ".", 
                    "inputBinding": {
                        "prefix": "--dir"
                    }
                }, 
                {
                    "id": "#fastqc.cwl/extract", 
                    "type": "boolean", 
                    "default": false, 
                    "inputBinding": {
                        "prefix": "--extract"
                    }
                }, 
                {
                    "id": "#fastqc.cwl/format", 
                    "type": "string", 
                    "default": "fastq", 
                    "inputBinding": {
                        "prefix": "--format"
                    }
                }, 
                {
                    "id": "#fastqc.cwl/INPUT", 
                    "type": "File", 
                    "format": "edam:format_2182", 
                    "inputBinding": {
                        "position": 99
                    }
                }, 
                {
                    "id": "#fastqc.cwl/kmers", 
                    "type": [
                        "null", 
                        "File"
                    ], 
                    "inputBinding": {
                        "prefix": "--kmers"
                    }
                }, 
                {
                    "id": "#fastqc.cwl/limits", 
                    "type": [
                        "null", 
                        "File"
                    ], 
                    "inputBinding": {
                        "prefix": "--limits"
                    }
                }, 
                {
                    "id": "#fastqc.cwl/nano", 
                    "type": "boolean", 
                    "default": false, 
                    "inputBinding": {
                        "prefix": "--nano"
                    }
                }, 
                {
                    "id": "#fastqc.cwl/noextract", 
                    "type": "boolean", 
                    "default": true, 
                    "inputBinding": {
                        "prefix": "--noextract"
                    }
                }, 
                {
                    "id": "#fastqc.cwl/nofilter", 
                    "type": "boolean", 
                    "default": false, 
                    "inputBinding": {
                        "prefix": "--nofilter"
                    }
                }, 
                {
                    "id": "#fastqc.cwl/nogroup", 
                    "type": "boolean", 
                    "default": false, 
                    "inputBinding": {
                        "prefix": "--nogroup"
                    }
                }, 
                {
                    "id": "#fastqc.cwl/outdir", 
                    "type": "string", 
                    "default": ".", 
                    "inputBinding": {
                        "prefix": "--outdir"
                    }
                }, 
                {
                    "id": "#fastqc.cwl/quiet", 
                    "type": "boolean", 
                    "default": false, 
                    "inputBinding": {
                        "prefix": "--quiet"
                    }
                }, 
                {
                    "id": "#fastqc.cwl/threads", 
                    "type": "long", 
                    "default": 1, 
                    "inputBinding": {
                        "prefix": "--threads"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#fastqc.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "${\n  function endsWith(str, suffix) {\n    return str.indexOf(suffix, str.length - suffix.length) !== -1;\n  }\n\n  var filename = inputs.INPUT.nameroot;\n\n  if ( endsWith(filename, '.fq') ) {\n    var nameroot = filename.slice(0,-3);\n  }\n  else if ( endsWith(nameroot, '.fastq') ) {\n    var nameroot = filename.slice(0,-6);\n  }\n  else {\n    var nameroot = filename;\n  }\n\n  var output = nameroot +\"_fastqc.zip\";\n  return output\n}\n  \n"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/FastQC/fastqc"
            ], 
            "id": "#fastqc.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                }, 
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/fastqc_to_json:4a955c8dd0078b129293a7603b24da5ded003ab148a6e2e86b5c1a574863c7e5"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#fastqc_basicstatistics_json.cwl/sqlite_path", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--sqlite_path"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#fastqc_basicstatistics_json.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "fastqc.json"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/fastqc_to_json"
            ], 
            "id": "#fastqc_basicstatistics_json.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/fastqc_db:b9c09ea65f40e154d239ebf494f4cd14ed2526cb6b70f65f9d822d3ebd4f1594"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#fastqc_db.cwl/INPUT", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--INPUT"
                    }
                }, 
                {
                    "id": "#fastqc_db.cwl/task_uuid", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--task_uuid"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#fastqc_db.cwl/LOG", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".log\")"
                    }
                }, 
                {
                    "id": "#fastqc_db.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".db\")"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/fastqc_db"
            ], 
            "id": "#fastqc_db.cwl"
        }, 
        {
            "class": "CommandLineTool", 
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/curl:d27480e7ac07e583146362d59f48254c2f59dfaa023212d12e091e136a52bcdf
                }
            ], 
            "inputs": [
                {
                    "id": "#gdc_get_object.cwl/gdc_token", 
                    "type": "File", 
                    "inputBinding": {
                        "loadContents": true, 
                        "valueFrom": "$(null)"
                    }
                }, 
                {
                    "id": "#gdc_get_object.cwl/gdc_uuid", 
                    "type": "string"
                }
            ], 
            "outputs": [
                {
                    "id": "#gdc_get_object.cwl/output", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "*"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "X-Auth-Token: $(inputs.gdc_token.contents)", 
                    "position": 0
                }, 
                {
                    "valueFrom": "https://gdc-api.nci.nih.gov/data/$(inputs.gdc_uuid)", 
                    "position": 1
                }
            ], 
            "baseCommand": [
                "curl", 
                "--remote-name", 
                "--remote-header-name", 
                "--header"
            ], 
            "id": "#gdc_get_object.cwl"
        }, 
        {
            "class": "CommandLineTool", 
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "ubuntu:artful-20171019"
                }
            ], 
            "inputs": [
                {
                    "id": "#generate_load_token.cwl/load1", 
                    "type": [
                        "null", 
                        "File"
                    ]
                }, 
                {
                    "id": "#generate_load_token.cwl/load2", 
                    "type": [
                        "null", 
                        "File"
                    ]
                }, 
                {
                    "id": "#generate_load_token.cwl/load3", 
                    "type": [
                        "null", 
                        "File"
                    ]
                }, 
                {
                    "id": "#generate_load_token.cwl/load4", 
                    "type": [
                        "null", 
                        "File"
                    ]
                }, 
                {
                    "id": "#generate_load_token.cwl/load5", 
                    "type": [
                        "null", 
                        "File"
                    ]
                }, 
                {
                    "id": "#generate_load_token.cwl/load6", 
                    "type": [
                        "null", 
                        "File"
                    ]
                }, 
                {
                    "id": "#generate_load_token.cwl/load7", 
                    "type": [
                        "null", 
                        "File"
                    ]
                }
            ], 
            "outputs": [
                {
                    "id": "#generate_load_token.cwl/token", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "token"
                    }
                }
            ], 
            "baseCommand": [
                "touch", 
                "token"
            ], 
            "id": "#generate_load_token.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "ExpressionTool", 
            "inputs": [
                {
                    "id": "#generate_s3load_path.cwl/load_bucket", 
                    "type": "string"
                }, 
                {
                    "id": "#generate_s3load_path.cwl/filename", 
                    "type": "string"
                }, 
                {
                    "id": "#generate_s3load_path.cwl/task_uuid", 
                    "type": "string"
                }
            ], 
            "outputs": [
                {
                    "id": "#generate_s3load_path.cwl/output", 
                    "type": "string"
                }
            ], 
            "expression": "${\n  var output = inputs.load_bucket + \"/\" + inputs.task_uuid + \"/\" + inputs.filename;\n  return {'output': output}\n}\n", 
            "id": "#generate_s3load_path.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/integrity_to_sqlite:40edb00dd1679ad7019ee4b8c634aadc1e8aa66e6baac8d0a72b7389dbac76bf"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#integrity_to_sqlite.cwl/input_state", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--input_state"
                    }
                }, 
                {
                    "id": "#integrity_to_sqlite.cwl/ls_l_path", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--ls_l_path"
                    }
                }, 
                {
                    "id": "#integrity_to_sqlite.cwl/md5sum_path", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--md5sum_path"
                    }
                }, 
                {
                    "id": "#integrity_to_sqlite.cwl/sha256sum_path", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--sha256sum_path"
                    }
                }, 
                {
                    "id": "#integrity_to_sqlite.cwl/task_uuid", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--task_uuid"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#integrity_to_sqlite.cwl/LOG", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".log\")"
                    }
                }, 
                {
                    "id": "#integrity_to_sqlite.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".db\")"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/integrity_to_sqlite"
            ], 
            "id": "#integrity_to_sqlite.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/json-to-sqlite:43564cbca5b19e99d5d4ebf28987cde30facd6082854086967617fbe6be641eb"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#json_to_sqlite.cwl/input_json", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--input_json"
                    }
                }, 
                {
                    "id": "#json_to_sqlite.cwl/task_uuid", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--task_uuid"
                    }
                }, 
                {
                    "id": "#json_to_sqlite.cwl/table_name", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--table_name"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#json_to_sqlite.cwl/sqlite", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid).db"
                    }
                }, 
                {
                    "id": "#json_to_sqlite.cwl/log", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid).log"
                    }
                }
            ], 
            "baseCommand": [
                "json_to_sqlite"
            ], 
            "id": "#json_to_sqlite.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "ubuntu:artful-20171019"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#ls_l.cwl/INPUT", 
                    "type": "File", 
                    "inputBinding": {
                        "position": 0
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#ls_l.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".ls\")"
                    }
                }
            ], 
            "stdout": "$(inputs.INPUT.nameroot + \".ls\")", 
            "baseCommand": [
                "ls", 
                "-l"
            ], 
            "id": "#ls_l.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "ubuntu:artful-20171019"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#md5sum.cwl/INPUT", 
                    "type": "File", 
                    "inputBinding": {
                        "position": 0
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#md5sum.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".md5\")"
                    }
                }
            ], 
            "stdout": "$(inputs.INPUT.nameroot + \".md5\")", 
            "baseCommand": [
                "md5sum"
            ], 
            "id": "#md5sum.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/merge_sqlite:32bf383b197503e795278332d3c8bd5944f736f25ebaedb25a3a104252c3b76f"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#merge_sqlite.cwl/source_sqlite", 
                    "format": "edam:format_3621", 
                    "type": {
                        "type": "array", 
                        "items": "File", 
                        "inputBinding": {
                            "prefix": "--source_sqlite"
                        }
                    }
                }, 
                {
                    "id": "#merge_sqlite.cwl/task_uuid", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--task_uuid"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#merge_sqlite.cwl/destination_sqlite", 
                    "format": "edam:format_3621", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".db\")"
                    }
                }, 
                {
                    "id": "#merge_sqlite.cwl/log", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".log\")"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/merge_sqlite"
            ], 
            "id": "#merge_sqlite.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/mirna-profiler:bd6f4799a457e0e0fde6dca548801c789656173fe529fd1706dc79adce0085f8"
                }, 
                {
                    "class": "InitialWorkDirRequirement", 
                    "listing": [
                        {
                            "entryname": "$(inputs.sam.basename)", 
                            "entry": "$(inputs.sam)", 
                            "writable": true
                        }, 
                        {
                            "entryname": "$(inputs.adapter_report.basename)", 
                            "entry": "$(inputs.adapter_report)", 
                            "writable": true
                        }
                    ]
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#mirna_alignment_stats.cwl/sam", 
                    "format": "edam:format_2573", 
                    "type": "File"
                }, 
                {
                    "id": "#mirna_alignment_stats.cwl/adapter_report", 
                    "type": "File"
                }, 
                {
                    "id": "#mirna_alignment_stats.cwl/project_directory", 
                    "type": "string", 
                    "default": ".", 
                    "inputBinding": {
                        "position": 93, 
                        "prefix": "-p"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#mirna_alignment_stats.cwl/alignment_stats_csv", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "alignment_stats.csv"
                    }
                }, 
                {
                    "id": "#mirna_alignment_stats.cwl/features", 
                    "type": "Directory", 
                    "outputBinding": {
                        "glob": "$(inputs.sam.nameroot)_features"
                    }
                }, 
                {
                    "id": "#mirna_alignment_stats.cwl/chastity_taglengths_csv", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.sam.nameroot)_features/chastity_taglengths.csv"
                    }
                }, 
                {
                    "id": "#mirna_alignment_stats.cwl/crossmapped_txt", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.sam.nameroot)_features/crossmapped.txt"
                    }
                }, 
                {
                    "id": "#mirna_alignment_stats.cwl/filtered_taglengths_csv", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.sam.nameroot)_features/filtered_taglengths.csv"
                    }
                }, 
                {
                    "id": "#mirna_alignment_stats.cwl/isoforms_txt", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.sam.nameroot)_features/isoforms.txt"
                    }
                }, 
                {
                    "id": "#mirna_alignment_stats.cwl/miRNA_txt", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.sam.nameroot)_features/miRNA.txt"
                    }
                }, 
                {
                    "id": "#mirna_alignment_stats.cwl/mirna_species_txt", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.sam.nameroot)_features/mirna_species.txt"
                    }
                }, 
                {
                    "id": "#mirna_alignment_stats.cwl/softclip_taglengths_csv", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.sam.nameroot)_features/softclip_taglengths.csv"
                    }
                }
            ], 
            "baseCommand": [
                "/root/mirna/v0.2.7/code/library_stats/alignment_stats.pl"
            ], 
            "id": "#mirna_alignment_stats.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/mirna-profiler:bd6f4799a457e0e0fde6dca548801c789656173fe529fd1706dc79adce0085f8"
                }, 
                {
                    "class": "InitialWorkDirRequirement", 
                    "listing": [
                        {
                            "entryname": "$(inputs.sam.basename)", 
                            "entry": "$(inputs.sam)", 
                            "writable": true
                        }
                    ]
                }, 
                {
                    "class": "ShellCommandRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#mirna_annotate.cwl/sam", 
                    "format": "edam:format_2573", 
                    "type": "File"
                }, 
                {
                    "id": "#mirna_annotate.cwl/mirbase", 
                    "type": "string", 
                    "default": "hg38", 
                    "inputBinding": {
                        "position": 90, 
                        "prefix": "-m", 
                        "shellQuote": false
                    }
                }, 
                {
                    "id": "#mirna_annotate.cwl/ucsc_database", 
                    "type": "string", 
                    "default": "hg38", 
                    "inputBinding": {
                        "position": 91, 
                        "prefix": "-u", 
                        "shellQuote": false
                    }
                }, 
                {
                    "id": "#mirna_annotate.cwl/species_code", 
                    "type": "string", 
                    "default": "hsa", 
                    "inputBinding": {
                        "position": 92, 
                        "prefix": "-o", 
                        "shellQuote": false
                    }
                }, 
                {
                    "id": "#mirna_annotate.cwl/project_directory", 
                    "type": "string", 
                    "default": ".", 
                    "inputBinding": {
                        "position": 93, 
                        "prefix": "-p", 
                        "shellQuote": false
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#mirna_annotate.cwl/output", 
                    "format": "edam:format_2573", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.sam.basename)"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "chmod 1777 /tmp", 
                    "position": 0, 
                    "shellQuote": false
                }, 
                {
                    "valueFrom": "&& /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --user=mysql --daemonize", 
                    "position": 1, 
                    "shellQuote": false
                }, 
                {
                    "valueFrom": "&& /root/mirna/v0.2.7/code/annotation/annotate.pl", 
                    "position": 3, 
                    "shellQuote": false
                }
            ], 
            "baseCommand": [], 
            "id": "#mirna_annotate.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/mirna-profiler:bd6f4799a457e0e0fde6dca548801c789656173fe529fd1706dc79adce0085f8"
                }, 
                {
                    "class": "InitialWorkDirRequirement", 
                    "listing": [
                        {
                            "entryname": "$(inputs.stats_mirna_species_txt.basename)", 
                            "entry": "$(inputs.stats_mirna_species_txt)"
                        }
                    ]
                }, 
                {
                    "class": "ShellCommandRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#mirna_expression_matrix.cwl/mirbase_db", 
                    "type": "string", 
                    "default": "hg38", 
                    "inputBinding": {
                        "position": 90, 
                        "prefix": "-m", 
                        "shellQuote": false
                    }
                }, 
                {
                    "id": "#mirna_expression_matrix.cwl/project_directory", 
                    "type": "string", 
                    "default": ".", 
                    "inputBinding": {
                        "position": 93, 
                        "prefix": "-p", 
                        "shellQuote": false
                    }
                }, 
                {
                    "id": "#mirna_expression_matrix.cwl/species_code", 
                    "type": "string", 
                    "default": "hsa", 
                    "inputBinding": {
                        "position": 92, 
                        "prefix": "-o", 
                        "shellQuote": false
                    }
                }, 
                {
                    "id": "#mirna_expression_matrix.cwl/stats_mirna_species_txt", 
                    "type": "File"
                }
            ], 
            "outputs": [
                {
                    "id": "#mirna_expression_matrix.cwl/expn_matrix_txt", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "expn_matrix.txt"
                    }
                }, 
                {
                    "id": "#mirna_expression_matrix.cwl/expn_matrix_norm_txt", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "expn_matrix_norm.txt"
                    }
                }, 
                {
                    "id": "#mirna_expression_matrix.cwl/expn_matrix_norm_log_txt", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "expn_matrix_norm_log.txt"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "chmod 1777 /tmp", 
                    "position": 0, 
                    "shellQuote": false
                }, 
                {
                    "valueFrom": "&& /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --user=mysql --daemonize", 
                    "position": 1, 
                    "shellQuote": false
                }, 
                {
                    "valueFrom": "&& /root/mirna/v0.2.7/code/library_stats/expression_matrix.pl", 
                    "position": 3, 
                    "shellQuote": false
                }
            ], 
            "baseCommand": [], 
            "id": "#mirna_expression_matrix.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/mirna-profiler:bd6f4799a457e0e0fde6dca548801c789656173fe529fd1706dc79adce0085f8"
                }, 
                {
                    "class": "InitialWorkDirRequirement", 
                    "listing": [
                        {
                            "entryname": "$(inputs.stats_crossmapped_txt.basename)", 
                            "entry": "$(inputs.stats_crossmapped_txt)"
                        }, 
                        {
                            "entryname": "$(inputs.stats_mirna_txt.basename)", 
                            "entry": "$(inputs.stats_mirna_txt)"
                        }
                    ]
                }, 
                {
                    "class": "ShellCommandRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#mirna_expression_matrix_mimat.cwl/mirbase_db", 
                    "type": "string", 
                    "default": "hg38", 
                    "inputBinding": {
                        "position": 90, 
                        "prefix": "-m", 
                        "shellQuote": false
                    }
                }, 
                {
                    "id": "#mirna_expression_matrix_mimat.cwl/project_directory", 
                    "type": "string", 
                    "default": ".", 
                    "inputBinding": {
                        "position": 91, 
                        "prefix": "-p", 
                        "shellQuote": false
                    }
                }, 
                {
                    "id": "#mirna_expression_matrix_mimat.cwl/species_code", 
                    "type": "string", 
                    "default": "hsa", 
                    "inputBinding": {
                        "position": 92, 
                        "prefix": "-o", 
                        "shellQuote": false
                    }
                }, 
                {
                    "id": "#mirna_expression_matrix_mimat.cwl/stats_crossmapped_txt", 
                    "type": "File"
                }, 
                {
                    "id": "#mirna_expression_matrix_mimat.cwl/stats_mirna_txt", 
                    "type": "File"
                }
            ], 
            "outputs": [
                {
                    "id": "#mirna_expression_matrix_mimat.cwl/expn_matrix_mimat_txt", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "expn_matrix_mimat.txt"
                    }
                }, 
                {
                    "id": "#mirna_expression_matrix_mimat.cwl/expn_matrix_mimat_norm_txt", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "expn_matrix_mimat_norm.txt"
                    }
                }, 
                {
                    "id": "#mirna_expression_matrix_mimat.cwl/expn_matrix_mimat_norm_log_txt", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "expn_matrix_mimat_norm_log.txt"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "chmod 1777 /tmp", 
                    "position": 0, 
                    "shellQuote": false
                }, 
                {
                    "valueFrom": "&& /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --user=mysql --daemonize", 
                    "position": 1, 
                    "shellQuote": false
                }, 
                {
                    "valueFrom": "&& /root/mirna/v0.2.7/code/library_stats/expression_matrix_mimat.pl", 
                    "position": 3, 
                    "shellQuote": false
                }
            ], 
            "baseCommand": [], 
            "id": "#mirna_expression_matrix_mimat.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/mirna-profiler:bd6f4799a457e0e0fde6dca548801c789656173fe529fd1706dc79adce0085f8"
                }, 
                {
                    "class": "InitialWorkDirRequirement", 
                    "listing": [
                        {
                            "entryname": "$(inputs.sam.basename)", 
                            "entry": "$(inputs.sam)"
                        }, 
                        {
                            "entryname": "$(inputs.adapter_report.basename)", 
                            "entry": "$(inputs.adapter_report)"
                        }, 
                        {
                            "entryname": "$(inputs.alignment_stats_csv.basename)", 
                            "entry": "$(inputs.alignment_stats_csv)"
                        }, 
                        {
                            "entryname": "$(inputs.chastity_taglengths_csv.basename)", 
                            "entry": "$(inputs.chastity_taglengths_csv)"
                        }, 
                        {
                            "entryname": "$(inputs.filtered_taglengths_csv.basename)", 
                            "entry": "$(inputs.filtered_taglengths_csv)"
                        }, 
                        {
                            "entryname": "$(inputs.softclip_taglengths_csv.basename)", 
                            "entry": "$(inputs.softclip_taglengths_csv)"
                        }
                    ]
                }, 
                {
                    "class": "ShellCommandRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#mirna_graph_libs.cwl/sam", 
                    "type": "File"
                }, 
                {
                    "id": "#mirna_graph_libs.cwl/adapter_report", 
                    "type": "File"
                }, 
                {
                    "id": "#mirna_graph_libs.cwl/alignment_stats_csv", 
                    "type": "File"
                }, 
                {
                    "id": "#mirna_graph_libs.cwl/chastity_taglengths_csv", 
                    "type": "File"
                }, 
                {
                    "id": "#mirna_graph_libs.cwl/filtered_taglengths_csv", 
                    "type": "File"
                }, 
                {
                    "id": "#mirna_graph_libs.cwl/softclip_taglengths_csv", 
                    "type": "File"
                }, 
                {
                    "id": "#mirna_graph_libs.cwl/project_directory", 
                    "type": "string", 
                    "default": ".", 
                    "inputBinding": {
                        "position": 90, 
                        "prefix": "-p", 
                        "shellQuote": false
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#mirna_graph_libs.cwl/jpgs", 
                    "type": "Directory", 
                    "outputBinding": {
                        "glob": "$(inputs.sam.nameroot)_features"
                    }
                }
            ], 
            "baseCommand": [
                "/root/mirna/v0.2.7/code/library_stats/graph_libs.pl"
            ], 
            "id": "#mirna_graph_libs.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/mirna-profiler:bd6f4799a457e0e0fde6dca548801c789656173fe529fd1706dc79adce0085f8"
                }, 
                {
                    "class": "InitialWorkDirRequirement", 
                    "listing": [
                        {
                            "entryname": "$(inputs.sam.basename)", 
                            "entry": "$(inputs.sam)"
                        }, 
                        {
                            "entryname": "$(inputs.stats_miRNA_txt.basename)", 
                            "entry": "$(inputs.stats_miRNA_txt)"
                        }, 
                        {
                            "entryname": "$(inputs.stats_crossmapped_txt.basename)", 
                            "entry": "$(inputs.stats_crossmapped_txt)"
                        }, 
                        {
                            "entryname": "$(inputs.stats_isoforms_txt.basename)", 
                            "entry": "$(inputs.stats_isoforms_txt)"
                        }
                    ]
                }, 
                {
                    "class": "ShellCommandRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#mirna_tcga.cwl/genome_version", 
                    "type": "string", 
                    "default": "hg38", 
                    "inputBinding": {
                        "position": 90, 
                        "prefix": "-g", 
                        "shellQuote": false
                    }
                }, 
                {
                    "id": "#mirna_tcga.cwl/mirbase_db", 
                    "type": "string", 
                    "default": "hg38", 
                    "inputBinding": {
                        "position": 91, 
                        "prefix": "-m", 
                        "shellQuote": false
                    }
                }, 
                {
                    "id": "#mirna_tcga.cwl/project_directory", 
                    "type": "string", 
                    "default": ".", 
                    "inputBinding": {
                        "position": 92, 
                        "prefix": "-p", 
                        "shellQuote": false
                    }
                }, 
                {
                    "id": "#mirna_tcga.cwl/species_code", 
                    "type": "string", 
                    "default": "hsa", 
                    "inputBinding": {
                        "position": 93, 
                        "prefix": "-o", 
                        "shellQuote": false
                    }
                }, 
                {
                    "id": "#mirna_tcga.cwl/sam", 
                    "format": "edam:format_2573", 
                    "type": "File"
                }, 
                {
                    "id": "#mirna_tcga.cwl/stats_miRNA_txt", 
                    "type": "File"
                }, 
                {
                    "id": "#mirna_tcga.cwl/stats_crossmapped_txt", 
                    "type": "File"
                }, 
                {
                    "id": "#mirna_tcga.cwl/stats_isoforms_txt", 
                    "type": "File"
                }
            ], 
            "outputs": [
                {
                    "id": "#mirna_tcga.cwl/isoforms_quant", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.sam.nameroot)_features/tcga/isoforms.txt"
                    }
                }, 
                {
                    "id": "#mirna_tcga.cwl/mirnas_quant", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.sam.nameroot)_features/tcga/mirnas.txt"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "chmod 1777 /tmp", 
                    "position": 0, 
                    "shellQuote": false
                }, 
                {
                    "valueFrom": "&& /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --user=mysql --daemonize", 
                    "position": 1, 
                    "shellQuote": false
                }, 
                {
                    "valueFrom": "&& /root/mirna/v0.2.7/code/custom_output/tcga/tcga.pl", 
                    "position": 3, 
                    "shellQuote": false
                }
            ], 
            "baseCommand": [], 
            "id": "#mirna_tcga.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/picard:43e6e7d6cc07dba36889023f23c3d34f4923ee0d76489d3ba0d5e3868d8b3e85
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#picard_collectmultiplemetrics.cwl/DB_SNP", 
                    "type": "File", 
                    "format": "edam:format_3016", 
                    "inputBinding": {
                        "prefix": "DB_SNP=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/INPUT", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "inputBinding": {
                        "prefix": "INPUT=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/METRIC_ACCUMULATION_LEVEL=", 
                    "type": "string", 
                    "default": "ALL_READS", 
                    "inputBinding": {
                        "prefix": "METRIC_ACCUMULATION_LEVEL=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/REFERENCE_SEQUENCE", 
                    "type": "File", 
                    "format": "edam:format_1929", 
                    "inputBinding": {
                        "prefix": "REFERENCE_SEQUENCE=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/TMP_DIR", 
                    "type": "string", 
                    "default": ".", 
                    "inputBinding": {
                        "prefix": "TMP_DIR=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/VALIDATION_STRINGENCY", 
                    "default": "STRICT", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "VALIDATION_STRINGENCY=", 
                        "separate": false
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#picard_collectmultiplemetrics.cwl/alignment_summary_metrics", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".alignment_summary_metrics\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/bait_bias_detail_metrics", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".bait_bias_detail_metrics\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/bait_bias_summary_metrics", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".bait_bias_summary_metrics\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/base_distribution_by_cycle_metrics", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".base_distribution_by_cycle_metrics\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/base_distribution_by_cycle_pdf", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".base_distribution_by_cycle.pdf\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/gc_bias_detail_metrics", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".gc_bias.detail_metrics\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/gc_bias_pdf", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".gc_bias.pdf\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/gc_bias_summary_metrics", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".gc_bias.summary_metrics\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/insert_size_histogram_pdf", 
                    "type": [
                        "null", 
                        "File"
                    ], 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".insert_size_histogram.pdf\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/insert_size_metrics", 
                    "type": [
                        "null", 
                        "File"
                    ], 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".insert_size_metrics\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/pre_adapter_detail_metrics", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".pre_adapter_detail_metrics\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/pre_adapter_summary_metrics", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".pre_adapter_summary_metrics\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/quality_by_cycle_metrics", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".quality_by_cycle_metrics\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/quality_by_cycle_pdf", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".quality_by_cycle.pdf\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/quality_distribution_metrics", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".quality_distribution_metrics\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/quality_distribution_pdf", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".quality_distribution.pdf\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics.cwl/quality_yield_metrics", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".quality_yield_metrics\")"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "PROGRAM=CollectAlignmentSummaryMetrics"
                }, 
                {
                    "valueFrom": "PROGRAM=CollectBaseDistributionByCycle"
                }, 
                {
                    "valueFrom": "PROGRAM=CollectGcBiasMetrics"
                }, 
                {
                    "valueFrom": "PROGRAM=CollectInsertSizeMetrics"
                }, 
                {
                    "valueFrom": "PROGRAM=CollectQualityYieldMetrics"
                }, 
                {
                    "valueFrom": "PROGRAM=CollectSequencingArtifactMetrics"
                }, 
                {
                    "valueFrom": "PROGRAM=MeanQualityByCycle"
                }, 
                {
                    "valueFrom": "PROGRAM=QualityScoreDistribution"
                }, 
                {
                    "valueFrom": "$(inputs.INPUT.nameroot)", 
                    "prefix": "OUTPUT=", 
                    "separate": false
                }
            ], 
            "baseCommand": [
                "java", 
                "-jar", 
                "/usr/local/bin/picard.jar", 
                "CollectMultipleMetrics"
            ], 
            "id": "#picard_collectmultiplemetrics.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/picard_metrics_sqlite:bbb809fe71a61233801e376068c734539ee58e080d704c6ddc759e24ec59eaaf"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/bam", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--bam"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/fasta", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--fasta"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/input_state", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--input_state"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/task_uuid", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--task_uuid"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/vcf", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--vcf"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/alignment_summary_metrics", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--alignment_summary_metrics"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/bait_bias_detail_metrics", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--bait_bias_detail_metrics"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/bait_bias_summary_metrics", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--bait_bias_summary_metrics"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/base_distribution_by_cycle_metrics", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--base_distribution_by_cycle_metrics"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/gc_bias_detail_metrics", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--gc_bias_detail_metrics"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/gc_bias_summary_metrics", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--gc_bias_summary_metrics"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/insert_size_metrics", 
                    "type": [
                        "null", 
                        "File"
                    ], 
                    "inputBinding": {
                        "prefix": "--insert_size_metrics"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/pre_adapter_detail_metrics", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--pre_adapter_detail_metrics"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/pre_adapter_summary_metrics", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--pre_adapter_summary_metrics"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/quality_by_cycle_metrics", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--quality_by_cycle_metrics"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/quality_distribution_metrics", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--quality_distribution_metrics"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/quality_yield_metrics", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--quality_yield_metrics"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/log", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid+\"_picard_CollectMultipleMetrics.log\")"
                    }
                }, 
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/sqlite", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".db\")"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/picard_metrics_sqlite", 
                "--metric_name", 
                "CollectMultipleMetrics"
            ], 
            "id": "#picard_collectmultiplemetrics_to_sqlite.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/picard:43e6e7d6cc07dba36889023f23c3d34f4923ee0d76489d3ba0d5e3868d8b3e85
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#picard_collectoxogmetrics.cwl/DB_SNP", 
                    "type": "File", 
                    "format": "edam:format_3016", 
                    "inputBinding": {
                        "prefix": "DB_SNP=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_collectoxogmetrics.cwl/INPUT", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "inputBinding": {
                        "prefix": "INPUT=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_collectoxogmetrics.cwl/REFERENCE_SEQUENCE", 
                    "type": "File", 
                    "format": "edam:format_1929", 
                    "inputBinding": {
                        "prefix": "REFERENCE_SEQUENCE=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_collectoxogmetrics.cwl/TMP_DIR", 
                    "type": "string", 
                    "default": ".", 
                    "inputBinding": {
                        "prefix": "TMP_DIR=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_collectoxogmetrics.cwl/USE_OQ", 
                    "type": "string", 
                    "default": "true", 
                    "inputBinding": {
                        "prefix": "USE_OQ=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_collectoxogmetrics.cwl/VALIDATION_STRINGENCY", 
                    "default": "STRICT", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "VALIDATION_STRINGENCY=", 
                        "separate": false
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#picard_collectoxogmetrics.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.basename + \".metrics\")"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "$(inputs.INPUT.basename + \".metrics\")", 
                    "prefix": "OUTPUT=", 
                    "separate": false
                }
            ], 
            "baseCommand": [
                "java", 
                "-jar", 
                "/usr/local/bin/picard.jar", 
                "CollectOxoGMetrics"
            ], 
            "id": "#picard_collectoxogmetrics.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/picard_metrics_sqlite:bbb809fe71a61233801e376068c734539ee58e080d704c6ddc759e24ec59eaaf"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#picard_collectoxogmetrics_to_sqlite.cwl/bam", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--bam"
                    }
                }, 
                {
                    "id": "#picard_collectoxogmetrics_to_sqlite.cwl/fasta", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--fasta"
                    }
                }, 
                {
                    "id": "#picard_collectoxogmetrics_to_sqlite.cwl/input_state", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--input_state"
                    }
                }, 
                {
                    "id": "#picard_collectoxogmetrics_to_sqlite.cwl/metric_path", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--metric_path"
                    }
                }, 
                {
                    "id": "#picard_collectoxogmetrics_to_sqlite.cwl/task_uuid", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--task_uuid"
                    }
                }, 
                {
                    "id": "#picard_collectoxogmetrics_to_sqlite.cwl/vcf", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--vcf"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#picard_collectoxogmetrics_to_sqlite.cwl/log", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid+\"_picard_CollectOxoGMetrics.log\")"
                    }
                }, 
                {
                    "id": "#picard_collectoxogmetrics_to_sqlite.cwl/sqlite", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".db\")"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/picard_metrics_sqlite", 
                "--metric_name", 
                "CollectOxoGMetrics"
            ], 
            "id": "#picard_collectoxogmetrics_to_sqlite.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/picard:43e6e7d6cc07dba36889023f23c3d34f4923ee0d76489d3ba0d5e3868d8b3e85
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#picard_collectwgsmetrics.cwl/INPUT", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "inputBinding": {
                        "prefix": "INPUT=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_collectwgsmetrics.cwl/REFERENCE_SEQUENCE", 
                    "type": "File", 
                    "format": "edam:format_1929", 
                    "inputBinding": {
                        "prefix": "REFERENCE_SEQUENCE=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_collectwgsmetrics.cwl/VALIDATION_STRINGENCY", 
                    "default": "STRICT", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "VALIDATION_STRINGENCY=", 
                        "separate": false
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#picard_collectwgsmetrics.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".metrics\")"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "$(inputs.INPUT.nameroot + \".metrics\")", 
                    "prefix": "OUTPUT=", 
                    "separate": false
                }
            ], 
            "baseCommand": [
                "java", 
                "-jar", 
                "/usr/local/bin/picard.jar", 
                "CollectWgsMetrics"
            ], 
            "id": "#picard_collectwgsmetrics.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/picard_metrics_sqlite:bbb809fe71a61233801e376068c734539ee58e080d704c6ddc759e24ec59eaaf"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#picard_collectwgsmetrics_to_sqlite.cwl/bam", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--bam"
                    }
                }, 
                {
                    "id": "#picard_collectwgsmetrics_to_sqlite.cwl/fasta", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--fasta"
                    }
                }, 
                {
                    "id": "#picard_collectwgsmetrics_to_sqlite.cwl/input_state", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--input_state"
                    }
                }, 
                {
                    "id": "#picard_collectwgsmetrics_to_sqlite.cwl/metric_path", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--metric_path"
                    }
                }, 
                {
                    "id": "#picard_collectwgsmetrics_to_sqlite.cwl/task_uuid", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--task_uuid"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#picard_collectwgsmetrics_to_sqlite.cwl/log", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid+\"_picard_CollectWgsMetrics.log\")"
                    }
                }, 
                {
                    "id": "#picard_collectwgsmetrics_to_sqlite.cwl/sqlite", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".db\")"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/picard_metrics_sqlite", 
                "--metric_name", 
                "CollectWgsMetrics"
            ], 
            "id": "#picard_collectwgsmetrics_to_sqlite.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/picard:43e6e7d6cc07dba36889023f23c3d34f4923ee0d76489d3ba0d5e3868d8b3e85
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#picard_markduplicates.cwl/CREATE_INDEX", 
                    "type": "string", 
                    "default": "true", 
                    "inputBinding": {
                        "prefix": "CREATE_INDEX=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_markduplicates.cwl/INPUT", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "inputBinding": {
                        "prefix": "INPUT=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_markduplicates.cwl/TMP_DIR", 
                    "default": ".", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "TMP_DIR=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_markduplicates.cwl/VALIDATION_STRINGENCY", 
                    "default": "STRICT", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "VALIDATION_STRINGENCY=", 
                        "separate": false
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#picard_markduplicates.cwl/OUTPUT", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.basename)"
                    }, 
                    "secondaryFiles": [
                        "^.bai"
                    ]
                }, 
                {
                    "id": "#picard_markduplicates.cwl/METRICS", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.basename + \".metrics\")"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "$(inputs.INPUT.basename)", 
                    "prefix": "OUTPUT=", 
                    "separate": false
                }, 
                {
                    "valueFrom": "$(inputs.INPUT.basename + \".metrics\")", 
                    "prefix": "METRICS_FILE=", 
                    "separate": false
                }
            ], 
            "baseCommand": [
                "java", 
                "-jar", 
                "/usr/local/bin/picard.jar", 
                "MarkDuplicates"
            ], 
            "id": "#picard_markduplicates.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/picard_metrics_sqlite:bbb809fe71a61233801e376068c734539ee58e080d704c6ddc759e24ec59eaaf"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#picard_markduplicates_to_sqlite.cwl/bam", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--bam"
                    }
                }, 
                {
                    "id": "#picard_markduplicates_to_sqlite.cwl/input_state", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--input_state"
                    }
                }, 
                {
                    "id": "#picard_markduplicates_to_sqlite.cwl/metric_path", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--metric_path"
                    }
                }, 
                {
                    "id": "#picard_markduplicates_to_sqlite.cwl/task_uuid", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--task_uuid"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#picard_markduplicates_to_sqlite.cwl/log", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid+\"_picard_MarkDuplicates.log\")"
                    }
                }, 
                {
                    "id": "#picard_markduplicates_to_sqlite.cwl/sqlite", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".db\")"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/picard_metrics_sqlite", 
                "--metric_name", 
                "MarkDuplicates"
            ], 
            "id": "#picard_markduplicates_to_sqlite.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/picard:43e6e7d6cc07dba36889023f23c3d34f4923ee0d76489d3ba0d5e3868d8b3e85
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#picard_mergesamfiles.cwl/ASSUME_SORTED", 
                    "type": "boolean", 
                    "default": false, 
                    "inputBinding": {
                        "prefix": "ASSUME_SORTED=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_mergesamfiles.cwl/CREATE_INDEX", 
                    "type": "string", 
                    "default": "true", 
                    "inputBinding": {
                        "prefix": "CREATE_INDEX=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_mergesamfiles.cwl/INPUT", 
                    "format": "edam:format_2572", 
                    "type": {
                        "type": "array", 
                        "items": "File"
                    }
                }, 
                {
                    "id": "#picard_mergesamfiles.cwl/INTERVALS", 
                    "type": [
                        "null", 
                        "File"
                    ], 
                    "inputBinding": {
                        "prefix": "INTERVALS=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_mergesamfiles.cwl/MERGE_SEQUENCE_DICTIONARIES", 
                    "type": "string", 
                    "default": "false", 
                    "inputBinding": {
                        "prefix": "MERGE_SEQUENCE_DICTIONARIES=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_mergesamfiles.cwl/OUTPUT", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "OUTPUT=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_mergesamfiles.cwl/SORT_ORDER", 
                    "type": "string", 
                    "default": "coordinate", 
                    "inputBinding": {
                        "prefix": "SORT_ORDER=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_mergesamfiles.cwl/TMP_DIR", 
                    "type": "string", 
                    "default": ".", 
                    "inputBinding": {
                        "prefix": "TMP_DIR=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_mergesamfiles.cwl/USE_THREADING", 
                    "type": "string", 
                    "default": "true", 
                    "inputBinding": {
                        "prefix": "USE_THREADING=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_mergesamfiles.cwl/VALIDATION_STRINGENCY", 
                    "type": "string", 
                    "default": "STRICT", 
                    "inputBinding": {
                        "prefix": "VALIDATION_STRINGENCY=", 
                        "separate": false
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#picard_mergesamfiles.cwl/MERGED_OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.OUTPUT)"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "${\n  if (inputs.INPUT.length == 0) {\n    var cmd = ['/usr/bin/touch', inputs.OUTPUT];\n    return cmd\n  }\n  else {\n    var cmd = [\"java\", \"-jar\", \"/usr/local/bin/picard.jar\", \"MergeSamFiles\"];\n    var use_input = [];\n    for (var i = 0; i < inputs.INPUT.length; i++) {\n      var filesize = inputs.INPUT[i].size;\n      if (filesize > 0) {\n        use_input.push(\"INPUT=\" + inputs.INPUT[i].path);\n      }\n    }\n\n    var run_cmd = cmd.concat(use_input);\n    return run_cmd\n  }\n\n}\n"
                }
            ], 
            "baseCommand": [], 
            "id": "#picard_mergesamfiles.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/picard:43e6e7d6cc07dba36889023f23c3d34f4923ee0d76489d3ba0d5e3868d8b3e85
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#picard_sortsam.cwl/CREATE_INDEX", 
                    "type": "string", 
                    "default": "true", 
                    "inputBinding": {
                        "prefix": "CREATE_INDEX=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_sortsam.cwl/INPUT", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "inputBinding": {
                        "prefix": "INPUT=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_sortsam.cwl/OUTPUT", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "OUTPUT=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_sortsam.cwl/SORT_ORDER", 
                    "type": "string", 
                    "default": "coordinate", 
                    "inputBinding": {
                        "prefix": "SORT_ORDER=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_sortsam.cwl/TMP_DIR", 
                    "type": "string", 
                    "default": ".", 
                    "inputBinding": {
                        "prefix": "TMP_DIR=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_sortsam.cwl/VALIDATION_STRINGENCY", 
                    "type": "string", 
                    "default": "STRICT", 
                    "inputBinding": {
                        "prefix": "VALIDATION_STRINGENCY=", 
                        "separate": false
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#picard_sortsam.cwl/SORTED_OUTPUT", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "outputBinding": {
                        "glob": "$(inputs.OUTPUT)"
                    }, 
                    "secondaryFiles": [
                        "^.bai"
                    ]
                }
            ], 
            "baseCommand": [
                "java", 
                "-jar", 
                "/usr/local/bin/picard.jar", 
                "SortSam"
            ], 
            "id": "#picard_sortsam.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/picard:43e6e7d6cc07dba36889023f23c3d34f4923ee0d76489d3ba0d5e3868d8b3e85
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#picard_validatesamfile.cwl/IGNORE_WARNINGS", 
                    "type": "string", 
                    "default": "true", 
                    "inputBinding": {
                        "prefix": "IGNORE_WARNINGS=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_validatesamfile.cwl/INDEX_VALIDATION_STRINGENCY", 
                    "type": "string", 
                    "default": "NONE", 
                    "inputBinding": {
                        "prefix": "INDEX_VALIDATION_STRINGENCY=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_validatesamfile.cwl/INPUT", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "inputBinding": {
                        "prefix": "INPUT=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_validatesamfile.cwl/MAX_OUTPUT", 
                    "type": "int", 
                    "default": 2147483647, 
                    "inputBinding": {
                        "prefix": "MAX_OUTPUT=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_validatesamfile.cwl/MODE", 
                    "type": "string", 
                    "default": "VERBOSE", 
                    "inputBinding": {
                        "prefix": "MODE=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_validatesamfile.cwl/TMP_DIR", 
                    "type": "string", 
                    "default": ".", 
                    "inputBinding": {
                        "prefix": "TMP_DIR=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_validatesamfile.cwl/VALIDATE_INDEX", 
                    "type": "string", 
                    "default": "false", 
                    "inputBinding": {
                        "prefix": "VALIDATE_INDEX=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#picard_validatesamfile.cwl/VALIDATION_STRINGENCY", 
                    "default": "STRICT", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "VALIDATION_STRINGENCY=", 
                        "separate": false
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#picard_validatesamfile.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.basename + \".metrics\")"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "$(inputs.INPUT.basename + \".metrics\")", 
                    "prefix": "OUTPUT=", 
                    "separate": false
                }
            ], 
            "successCodes": [
                0, 
                2, 
                3
            ], 
            "baseCommand": [
                "java", 
                "-jar", 
                "/usr/local/bin/picard.jar", 
                "ValidateSamFile"
            ], 
            "id": "#picard_validatesamfile.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/picard_metrics_sqlite:bbb809fe71a61233801e376068c734539ee58e080d704c6ddc759e24ec59eaaf"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#picard_validatesamfile_to_sqlite.cwl/bam", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--bam"
                    }
                }, 
                {
                    "id": "#picard_validatesamfile_to_sqlite.cwl/input_state", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--input_state"
                    }
                }, 
                {
                    "id": "#picard_validatesamfile_to_sqlite.cwl/metric_path", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--metric_path"
                    }
                }, 
                {
                    "id": "#picard_validatesamfile_to_sqlite.cwl/task_uuid", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--task_uuid"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#picard_validatesamfile_to_sqlite.cwl/log", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid+\"_picard_ValidateSamFile.log\")"
                    }
                }, 
                {
                    "id": "#picard_validatesamfile_to_sqlite.cwl/sqlite", 
                    "type": "File", 
                    "format": "edam:format_3621", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".db\")"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/picard_metrics_sqlite", 
                "--metric_name", 
                "ValidateSamFile"
            ], 
            "id": "#picard_validatesamfile_to_sqlite.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/readgroup_json_db:0b69833722a66236e9519ce1d3955368a645c4bcf26d1f7416bbacbdc5deef9b"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#readgroup_json_db.cwl/json_path", 
                    "type": "File", 
                    "format": "edam:format_3464", 
                    "inputBinding": {
                        "prefix": "--json_path"
                    }
                }, 
                {
                    "id": "#readgroup_json_db.cwl/task_uuid", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--task_uuid"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#readgroup_json_db.cwl/log", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid +\".log\")"
                    }
                }, 
                {
                    "id": "#readgroup_json_db.cwl/output_sqlite", 
                    "type": "File", 
                    "format": "edam:format_3621", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".db\")"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/readgroup_json_db"
            ], 
            "id": "#readgroup_json_db.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "ubuntu:artful-20171019"
                }, 
                {
                    "class": "InitialWorkDirRequirement", 
                    "listing": [
                        {
                            "entryname": "$(inputs.OUTNAME)", 
                            "entry": "$(inputs.INPUT)"
                        }
                    ]
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#rename.cwl/INPUT", 
                    "type": "File"
                }, 
                {
                    "id": "#rename.cwl/OUTNAME", 
                    "type": "string"
                }
            ], 
            "outputs": [
                {
                    "id": "#rename.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.OUTNAME)"
                    }
                }
            ], 
            "baseCommand": [
                "/bin/true"
            ], 
            "id": "#rename.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "ubuntu:artful-20171019"
                }, 
                {
                    "class": "InitialWorkDirRequirement", 
                    "listing": [
                        {
                            "entryname": "$(inputs.fasta.basename)", 
                            "entry": "$(inputs.fasta)"
                        }, 
                        {
                            "entryname": "$(inputs.fasta_amb.basename)", 
                            "entry": "$(inputs.fasta_amb)"
                        }, 
                        {
                            "entryname": "$(inputs.fasta_ann.basename)", 
                            "entry": "$(inputs.fasta_ann)"
                        }, 
                        {
                            "entryname": "$(inputs.fasta_bwt.basename)", 
                            "entry": "$(inputs.fasta_bwt)"
                        }, 
                        {
                            "entryname": "$(inputs.fasta_dict.basename)", 
                            "entry": "$(inputs.fasta_dict)"
                        }, 
                        {
                            "entryname": "$(inputs.fasta_fai.basename)", 
                            "entry": "$(inputs.fasta_fai)"
                        }, 
                        {
                            "entryname": "$(inputs.fasta_pac.basename)", 
                            "entry": "$(inputs.fasta_pac)"
                        }, 
                        {
                            "entryname": "$(inputs.fasta_sa.basename)", 
                            "entry": "$(inputs.fasta_sa)"
                        }
                    ]
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#root_fasta_dnaseq.cwl/fasta", 
                    "type": "File", 
                    "format": "edam:format_1929"
                }, 
                {
                    "id": "#root_fasta_dnaseq.cwl/fasta_amb", 
                    "type": "File"
                }, 
                {
                    "id": "#root_fasta_dnaseq.cwl/fasta_ann", 
                    "type": "File"
                }, 
                {
                    "id": "#root_fasta_dnaseq.cwl/fasta_bwt", 
                    "type": "File"
                }, 
                {
                    "id": "#root_fasta_dnaseq.cwl/fasta_dict", 
                    "type": "File"
                }, 
                {
                    "id": "#root_fasta_dnaseq.cwl/fasta_fai", 
                    "type": "File"
                }, 
                {
                    "id": "#root_fasta_dnaseq.cwl/fasta_pac", 
                    "type": "File"
                }, 
                {
                    "id": "#root_fasta_dnaseq.cwl/fasta_sa", 
                    "type": "File"
                }
            ], 
            "outputs": [
                {
                    "id": "#root_fasta_dnaseq.cwl/output", 
                    "type": "File", 
                    "format": "edam:format_1929", 
                    "outputBinding": {
                        "glob": "$(inputs.fasta.basename)"
                    }, 
                    "secondaryFiles": [
                        ".amb", 
                        ".ann", 
                        ".bwt", 
                        ".fai", 
                        ".pac", 
                        ".sa"
                    ]
                }
            ], 
            "baseCommand": [
                "true"
            ], 
            "id": "#root_fasta_dnaseq.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "ubuntu:artful-20171019"
                }, 
                {
                    "class": "InitialWorkDirRequirement", 
                    "listing": [
                        {
                            "entryname": "$(inputs.vcf.basename)", 
                            "entry": "$(inputs.vcf)"
                        }, 
                        {
                            "entryname": "$(inputs.vcf_index.basename)", 
                            "entry": "$(inputs.vcf_index)"
                        }
                    ]
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#root_vcf.cwl/vcf", 
                    "type": "File", 
                    "format": "edam:format_3016"
                }, 
                {
                    "id": "#root_vcf.cwl/vcf_index", 
                    "type": "File"
                }
            ], 
            "outputs": [
                {
                    "id": "#root_vcf.cwl/output", 
                    "type": "File", 
                    "format": "edam:format_3016", 
                    "outputBinding": {
                        "glob": "$(inputs.vcf.basename)"
                    }, 
                    "secondaryFiles": [
                        ".tbi"
                    ]
                }
            ], 
            "baseCommand": "true", 
            "id": "#root_vcf.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/samtools:6161be62579a6f4fa21e1c200a6bf42585ac602829999d582ecd35825ca3695a"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#samtools_bamtobam.cwl/INPUT", 
                    "format": "edam:format_2572", 
                    "type": "File", 
                    "inputBinding": {
                        "position": 0
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#samtools_bamtobam.cwl/OUTPUT", 
                    "format": "edam:format_2572", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.basename)"
                    }
                }
            ], 
            "stdout": "$(inputs.INPUT.basename)", 
            "baseCommand": [
                "/usr/local/bin/samtools", 
                "view", 
                "-Shb"
            ], 
            "id": "#samtools_bamtobam.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/samtools:6161be62579a6f4fa21e1c200a6bf42585ac602829999d582ecd35825ca3695a"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#samtools_flagstat.cwl/INPUT", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "inputBinding": {
                        "position": 0
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#samtools_flagstat.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".flagstat\")"
                    }
                }
            ], 
            "stdout": "$(inputs.INPUT.nameroot + \".flagstat\")", 
            "baseCommand": [
                "/usr/local/bin/samtools", 
                "flagstat"
            ], 
            "id": "#samtools_flagstat.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/samtools_metrics_sqlite:45b161680b60ab2fcd2fab718632769b9a3329af376f11dac6f673e702f1df7e"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#samtools_flagstat_to_sqlite.cwl/bam", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--bam"
                    }
                }, 
                {
                    "id": "#samtools_flagstat_to_sqlite.cwl/input_state", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--input_state"
                    }
                }, 
                {
                    "id": "#samtools_flagstat_to_sqlite.cwl/metric_path", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--metric_path"
                    }
                }, 
                {
                    "id": "#samtools_flagstat_to_sqlite.cwl/task_uuid", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--task_uuid"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#samtools_flagstat_to_sqlite.cwl/log", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid+\"_samtools_flagstat.log\")"
                    }
                }, 
                {
                    "id": "#samtools_flagstat_to_sqlite.cwl/sqlite", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".db\")"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/samtools_metrics_sqlite", 
                "--metric_name", 
                "flagstat"
            ], 
            "id": "#samtools_flagstat_to_sqlite.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/samtools:6161be62579a6f4fa21e1c200a6bf42585ac602829999d582ecd35825ca3695a"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#samtools_idxstats.cwl/INPUT", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "inputBinding": {
                        "position": 0
                    }, 
                    "secondaryFiles": [
                        "^.bai"
                    ]
                }
            ], 
            "outputs": [
                {
                    "id": "#samtools_idxstats.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".idxstats\")"
                    }
                }
            ], 
            "stdout": "$(inputs.INPUT.nameroot + \".idxstats\")", 
            "baseCommand": [
                "/usr/local/bin/samtools", 
                "idxstats"
            ], 
            "id": "#samtools_idxstats.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/samtools_metrics_sqlite:45b161680b60ab2fcd2fab718632769b9a3329af376f11dac6f673e702f1df7e"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#samtools_idxstats_to_sqlite.cwl/bam", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--bam"
                    }
                }, 
                {
                    "id": "#samtools_idxstats_to_sqlite.cwl/input_state", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--input_state"
                    }
                }, 
                {
                    "id": "#samtools_idxstats_to_sqlite.cwl/metric_path", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--metric_path"
                    }
                }, 
                {
                    "id": "#samtools_idxstats_to_sqlite.cwl/task_uuid", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--task_uuid"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#samtools_idxstats_to_sqlite.cwl/log", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid+\"_samtools_idxstats.log\")"
                    }
                }, 
                {
                    "id": "#samtools_idxstats_to_sqlite.cwl/sqlite", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".db\")"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/samtools_metrics_sqlite", 
                "--metric_name", 
                "idxstats"
            ], 
            "id": "#samtools_idxstats_to_sqlite.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/samtools:6161be62579a6f4fa21e1c200a6bf42585ac602829999d582ecd35825ca3695a"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#samtools_stats.cwl/INPUT", 
                    "type": "File", 
                    "format": "edam:format_2572", 
                    "inputBinding": {
                        "position": 0
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#samtools_stats.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".stats\")"
                    }
                }
            ], 
            "stdout": "$(inputs.INPUT.nameroot + \".stats\")", 
            "baseCommand": [
                "/usr/local/bin/samtools", 
                "stats"
            ], 
            "id": "#samtools_stats.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/samtools_metrics_sqlite:45b161680b60ab2fcd2fab718632769b9a3329af376f11dac6f673e702f1df7e"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#samtools_stats_to_sqlite.cwl/bam", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--bam"
                    }
                }, 
                {
                    "id": "#samtools_stats_to_sqlite.cwl/input_state", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--input_state"
                    }
                }, 
                {
                    "id": "#samtools_stats_to_sqlite.cwl/metric_path", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--metric_path"
                    }
                }, 
                {
                    "id": "#samtools_stats_to_sqlite.cwl/task_uuid", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--task_uuid"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#samtools_stats_to_sqlite.cwl/log", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid+\"_samtools_stats.log\")"
                    }
                }, 
                {
                    "id": "#samtools_stats_to_sqlite.cwl/sqlite", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".db\")"
                    }
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/samtools_metrics_sqlite", 
                "--metric_name", 
                "stats"
            ], 
            "id": "#samtools_stats_to_sqlite.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/samtools:6161be62579a6f4fa21e1c200a6bf42585ac602829999d582ecd35825ca3695a"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#samtools_view.cwl/INPUT", 
                    "format": "edam:format_2572", 
                    "type": "File", 
                    "inputBinding": {
                        "position": 0
                    }
                }, 
                {
                    "id": "#samtools_view.cwl/header_included", 
                    "type": "boolean", 
                    "default": true, 
                    "inputBinding": {
                        "prefix": "-h"
                    }
                }, 
                {
                    "id": "#samtools_view.cwl/output_format", 
                    "type": "string", 
                    "default": "BAM", 
                    "inputBinding": {
                        "prefix": "--output-fmt"
                    }
                }, 
                {
                    "id": "#samtools_view.cwl/threads", 
                    "type": "long", 
                    "default": 1, 
                    "inputBinding": {
                        "prefix": "--threads"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#samtools_view.cwl/OUTPUT", 
                    "format": "edam:format_2572", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "${\n  return inputs.INPUT.nameroot + \".\" + inputs.output_format.toLowerCase();\n}\n"
                    }
                }
            ], 
            "arguments": [
                {
                    "valueFrom": "${\n  return inputs.INPUT.nameroot + \".\" + inputs.output_format.toLowerCase();\n}\n", 
                    "prefix": "-o"
                }
            ], 
            "baseCommand": [
                "/usr/local/bin/samtools", 
                "view"
            ], 
            "id": "#samtools_view.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "ubuntu:artful-20171019"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#sha256sum.cwl/INPUT", 
                    "type": "File", 
                    "inputBinding": {
                        "position": 0
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#sha256sum.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.INPUT.nameroot + \".sha256\")"
                    }
                }
            ], 
            "stdout": "$(inputs.INPUT.nameroot + \".sha256\")", 
            "baseCommand": [
                "sha256sum"
            ], 
            "id": "#sha256sum.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "fedora:26"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }, 
                {
                    "class": "ResourceRequirement", 
                    "coresMin": 1, 
                    "coresMax": 1
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#sort.cwl/INPUT", 
                    "type": "File", 
                    "inputBinding": {
                        "position": 1
                    }
                }, 
                {
                    "id": "#sort.cwl/key", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--key=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#sort.cwl/field-separator", 
                    "type": "string", 
                    "default": " ", 
                    "inputBinding": {
                        "prefix": "--field-separator=", 
                        "separate": false
                    }
                }, 
                {
                    "id": "#sort.cwl/OUTFILE", 
                    "type": "string"
                }
            ], 
            "outputs": [
                {
                    "id": "#sort.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.OUTFILE)"
                    }
                }
            ], 
            "stdout": "$(inputs.OUTFILE)", 
            "baseCommand": [
                "sort"
            ], 
            "id": "#sort.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "ExpressionTool", 
            "inputs": [
                {
                    "id": "#sort_scatter_expression.cwl/INPUT", 
                    "type": {
                        "type": "array", 
                        "items": "File"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#sort_scatter_expression.cwl/OUTPUT", 
                    "type": {
                        "type": "array", 
                        "items": "File"
                    }
                }
            ], 
            "expression": "${\n  var output = inputs.INPUT.sort(function(a,b) { return a.basename > b.basename ? 1 : (a.basename < b.basename ? -1 : 0) });\n  return {'OUTPUT': output}\n}\n", 
            "id": "#sort_scatter_expression.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/sqlite_to_postgres:407f904dd4303ffa496089dc68c456af391724fc697a32372b00f8a6aaa6c82f"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#sqlite_to_postgres_hirate.cwl/ini_section", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--ini_section"
                    }
                }, 
                {
                    "id": "#sqlite_to_postgres_hirate.cwl/postgres_creds_path", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--postgres_creds_path"
                    }
                }, 
                {
                    "id": "#sqlite_to_postgres_hirate.cwl/source_sqlite_path", 
                    "type": "File", 
                    "inputBinding": {
                        "prefix": "--source_sqlite_path"
                    }
                }, 
                {
                    "id": "#sqlite_to_postgres_hirate.cwl/task_uuid", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--task_uuid"
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#sqlite_to_postgres_hirate.cwl/log", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.task_uuid + \".log\")"
                    }
                }
            ], 
            "baseCommand": [
                "sqlite_to_postgres"
            ], 
            "id": "#sqlite_to_postgres_hirate.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/xz:b8f105f87b8d69a0414f8997bd5b586e502d9a1aa74d429314ec97cbddd81ff8"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#tar.cwl/create", 
                    "type": "boolean", 
                    "default": true, 
                    "inputBinding": {
                        "prefix": "--create", 
                        "position": 0
                    }
                }, 
                {
                    "id": "#tar.cwl/file", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--file", 
                        "position": 1
                    }
                }, 
                {
                    "id": "#tar.cwl/xz", 
                    "type": "boolean", 
                    "default": true, 
                    "inputBinding": {
                        "prefix": "--xz", 
                        "position": 2
                    }
                }, 
                {
                    "id": "#tar.cwl/INPUT", 
                    "type": {
                        "type": "array", 
                        "items": "File"
                    }, 
                    "inputBinding": {
                        "position": 3
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#tar.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.file)"
                    }
                }
            ], 
            "baseCommand": [
                "tar"
            ], 
            "id": "#tar.cwl"
        }, 
        {
            "requirements": [
                {
                    "class": "DockerRequirement", 
                    "dockerPull": "quay.io/ncigdc/xz:b8f105f87b8d69a0414f8997bd5b586e502d9a1aa74d429314ec97cbddd81ff8"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "class": "CommandLineTool", 
            "inputs": [
                {
                    "id": "#tar_dir.cwl/create", 
                    "type": "boolean", 
                    "default": true, 
                    "inputBinding": {
                        "prefix": "--create", 
                        "position": 0
                    }
                }, 
                {
                    "id": "#tar_dir.cwl/file", 
                    "type": "string", 
                    "inputBinding": {
                        "prefix": "--file", 
                        "position": 1
                    }
                }, 
                {
                    "id": "#tar_dir.cwl/xz", 
                    "type": "boolean", 
                    "default": false, 
                    "inputBinding": {
                        "prefix": "--xz", 
                        "position": 2
                    }
                }, 
                {
                    "id": "#tar_dir.cwl/INPUT", 
                    "type": "Directory", 
                    "inputBinding": {
                        "position": 3
                    }
                }
            ], 
            "outputs": [
                {
                    "id": "#tar_dir.cwl/OUTPUT", 
                    "type": "File", 
                    "outputBinding": {
                        "glob": "$(inputs.file)"
                    }
                }
            ], 
            "baseCommand": [
                "tar"
            ], 
            "id": "#tar_dir.cwl"
        }, 
        {
            "class": "Workflow", 
            "requirements": [
                {
                    "class": "MultipleInputFeatureRequirement"
                }, 
                {
                    "class": "InlineJavascriptRequirement"
                }, 
                {
                    "class": "StepInputExpressionRequirement"
                }, 
                {
                    "class": "SubworkflowFeatureRequirement"
                }
            ], 
            "inputs": [
                {
                    "id": "#etl.cwl/gdc_token", 
                    "type": "File"
                }, 
                {
                    "id": "#etl.cwl/input_bam_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#etl.cwl/known_snp_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#etl.cwl/known_snp_index_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#etl.cwl/reference_amb_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#etl.cwl/reference_ann_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#etl.cwl/reference_bwt_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#etl.cwl/reference_dict_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#etl.cwl/reference_fa_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#etl.cwl/reference_fai_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#etl.cwl/reference_pac_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#etl.cwl/reference_sa_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#etl.cwl/start_token", 
                    "type": "File"
                }, 
                {
                    "id": "#etl.cwl/thread_count", 
                    "type": "long"
                }, 
                {
                    "id": "#etl.cwl/task_uuid", 
                    "type": "string"
                }, 
                {
                    "id": "#etl.cwl/aws_config", 
                    "type": "File"
                }, 
                {
                    "id": "#etl.cwl/aws_shared_credentials", 
                    "type": "File"
                }, 
                {
                    "id": "#etl.cwl/endpoint_json", 
                    "type": "File"
                }, 
                {
                    "id": "#etl.cwl/load_bucket", 
                    "type": "string"
                }, 
                {
                    "id": "#etl.cwl/s3cfg_section", 
                    "type": "string"
                }
            ], 
            "outputs": [
                {
                    "id": "#etl.cwl/s3_bam_url", 
                    "type": "string", 
                    "outputSource": "#etl.cwl/generate_s3_bam_url/output"
                }, 
                {
                    "id": "#etl.cwl/s3_bai_url", 
                    "type": "string", 
                    "outputSource": "#etl.cwl/generate_s3_bai_url/output"
                }, 
                {
                    "id": "#etl.cwl/s3_mirna_profiling_tar_url", 
                    "type": "string", 
                    "outputSource": "#etl.cwl/generate_s3_mirna_profiling_tar_url/output"
                }, 
                {
                    "id": "#etl.cwl/s3_mirna_profiling_isoforms_quant_url", 
                    "type": "string", 
                    "outputSource": "#etl.cwl/generate_s3_mirna_profiling_isoforms_quant_url/output"
                }, 
                {
                    "id": "#etl.cwl/s3_mirna_profiling_mirnas_quant_url", 
                    "type": "string", 
                    "outputSource": "#etl.cwl/generate_s3_mirna_profiling_mirnas_quant_url/output"
                }, 
                {
                    "id": "#etl.cwl/s3_sqlite_url", 
                    "type": "string", 
                    "outputSource": "#etl.cwl/generate_s3_sqlite_url/output"
                }, 
                {
                    "id": "#etl.cwl/token", 
                    "type": "File", 
                    "outputSource": "#etl.cwl/generate_token/token"
                }
            ], 
            "steps": [
                {
                    "id": "#etl.cwl/extract_bam", 
                    "run": "#gdc_get_object.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/extract_bam/gdc_token", 
                            "source": "#etl.cwl/gdc_token"
                        }, 
                        {
                            "id": "#etl.cwl/extract_bam/gdc_uuid", 
                            "source": "#etl.cwl/input_bam_gdc_id"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/extract_bam/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/extract_known_snp", 
                    "run": "#gdc_get_object.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/extract_known_snp/gdc_token", 
                            "source": "#etl.cwl/gdc_token"
                        }, 
                        {
                            "id": "#etl.cwl/extract_known_snp/gdc_uuid", 
                            "source": "#etl.cwl/known_snp_gdc_id"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/extract_known_snp/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/extract_known_snp_index", 
                    "run": "#gdc_get_object.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/extract_known_snp_index/gdc_token", 
                            "source": "#etl.cwl/gdc_token"
                        }, 
                        {
                            "id": "#etl.cwl/extract_known_snp_index/gdc_uuid", 
                            "source": "#etl.cwl/known_snp_index_gdc_id"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/extract_known_snp_index/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/extract_ref_fa", 
                    "run": "#gdc_get_object.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/extract_ref_fa/gdc_token", 
                            "source": "#etl.cwl/gdc_token"
                        }, 
                        {
                            "id": "#etl.cwl/extract_ref_fa/gdc_uuid", 
                            "source": "#etl.cwl/reference_fa_gdc_id"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/extract_ref_fa/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/extract_ref_fai", 
                    "run": "#gdc_get_object.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/extract_ref_fai/gdc_token", 
                            "source": "#etl.cwl/gdc_token"
                        }, 
                        {
                            "id": "#etl.cwl/extract_ref_fai/gdc_uuid", 
                            "source": "#etl.cwl/reference_fai_gdc_id"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/extract_ref_fai/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/extract_ref_dict", 
                    "run": "#gdc_get_object.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/extract_ref_dict/gdc_token", 
                            "source": "#etl.cwl/gdc_token"
                        }, 
                        {
                            "id": "#etl.cwl/extract_ref_dict/gdc_uuid", 
                            "source": "#etl.cwl/reference_dict_gdc_id"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/extract_ref_dict/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/extract_ref_amb", 
                    "run": "#gdc_get_object.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/extract_ref_amb/gdc_token", 
                            "source": "#etl.cwl/gdc_token"
                        }, 
                        {
                            "id": "#etl.cwl/extract_ref_amb/gdc_uuid", 
                            "source": "#etl.cwl/reference_amb_gdc_id"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/extract_ref_amb/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/extract_ref_ann", 
                    "run": "#gdc_get_object.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/extract_ref_ann/gdc_token", 
                            "source": "#etl.cwl/gdc_token"
                        }, 
                        {
                            "id": "#etl.cwl/extract_ref_ann/gdc_uuid", 
                            "source": "#etl.cwl/reference_ann_gdc_id"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/extract_ref_ann/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/extract_ref_bwt", 
                    "run": "#gdc_get_object.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/extract_ref_bwt/gdc_token", 
                            "source": "#etl.cwl/gdc_token"
                        }, 
                        {
                            "id": "#etl.cwl/extract_ref_bwt/gdc_uuid", 
                            "source": "#etl.cwl/reference_bwt_gdc_id"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/extract_ref_bwt/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/extract_ref_pac", 
                    "run": "#gdc_get_object.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/extract_ref_pac/gdc_token", 
                            "source": "#etl.cwl/gdc_token"
                        }, 
                        {
                            "id": "#etl.cwl/extract_ref_pac/gdc_uuid", 
                            "source": "#etl.cwl/reference_pac_gdc_id"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/extract_ref_pac/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/extract_ref_sa", 
                    "run": "#gdc_get_object.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/extract_ref_sa/gdc_token", 
                            "source": "#etl.cwl/gdc_token"
                        }, 
                        {
                            "id": "#etl.cwl/extract_ref_sa/gdc_uuid", 
                            "source": "#etl.cwl/reference_sa_gdc_id"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/extract_ref_sa/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/root_fasta_files", 
                    "run": "#root_fasta_dnaseq.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/root_fasta_files/fasta", 
                            "source": "#etl.cwl/extract_ref_fa/output"
                        }, 
                        {
                            "id": "#etl.cwl/root_fasta_files/fasta_amb", 
                            "source": "#etl.cwl/extract_ref_amb/output"
                        }, 
                        {
                            "id": "#etl.cwl/root_fasta_files/fasta_ann", 
                            "source": "#etl.cwl/extract_ref_ann/output"
                        }, 
                        {
                            "id": "#etl.cwl/root_fasta_files/fasta_bwt", 
                            "source": "#etl.cwl/extract_ref_bwt/output"
                        }, 
                        {
                            "id": "#etl.cwl/root_fasta_files/fasta_dict", 
                            "source": "#etl.cwl/extract_ref_dict/output"
                        }, 
                        {
                            "id": "#etl.cwl/root_fasta_files/fasta_fai", 
                            "source": "#etl.cwl/extract_ref_fai/output"
                        }, 
                        {
                            "id": "#etl.cwl/root_fasta_files/fasta_pac", 
                            "source": "#etl.cwl/extract_ref_pac/output"
                        }, 
                        {
                            "id": "#etl.cwl/root_fasta_files/fasta_sa", 
                            "source": "#etl.cwl/extract_ref_sa/output"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/root_fasta_files/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/root_known_snp_files", 
                    "run": "#root_vcf.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/root_known_snp_files/vcf", 
                            "source": "#etl.cwl/extract_known_snp/output"
                        }, 
                        {
                            "id": "#etl.cwl/root_known_snp_files/vcf_index", 
                            "source": "#etl.cwl/extract_known_snp_index/output"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/root_known_snp_files/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/transform", 
                    "run": "#transform_mirna.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/transform/input_bam", 
                            "source": "#etl.cwl/extract_bam/output"
                        }, 
                        {
                            "id": "#etl.cwl/transform/known_snp", 
                            "source": "#etl.cwl/root_known_snp_files/output"
                        }, 
                        {
                            "id": "#etl.cwl/transform/reference_sequence", 
                            "source": "#etl.cwl/root_fasta_files/output"
                        }, 
                        {
                            "id": "#etl.cwl/transform/thread_count", 
                            "source": "#etl.cwl/thread_count"
                        }, 
                        {
                            "id": "#etl.cwl/transform/task_uuid", 
                            "source": "#etl.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/transform/merge_all_sqlite_destination_sqlite"
                        }, 
                        {
                            "id": "#etl.cwl/transform/mirna_profiling_mirna_adapter_report_sorted_output"
                        }, 
                        {
                            "id": "#etl.cwl/transform/mirna_profiling_mirna_alignment_stats_features"
                        }, 
                        {
                            "id": "#etl.cwl/transform/mirna_profiling_mirna_expression_matrix_expn_matrix_txt"
                        }, 
                        {
                            "id": "#etl.cwl/transform/mirna_profiling_mirna_expression_matrix_expn_matrix_norm_txt"
                        }, 
                        {
                            "id": "#etl.cwl/transform/mirna_profiling_mirna_expression_matrix_expn_matrix_norm_log_txt"
                        }, 
                        {
                            "id": "#etl.cwl/transform/mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_txt"
                        }, 
                        {
                            "id": "#etl.cwl/transform/mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_norm_txt"
                        }, 
                        {
                            "id": "#etl.cwl/transform/mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_norm_log_txt"
                        }, 
                        {
                            "id": "#etl.cwl/transform/mirna_profiling_mirna_graph_libs_jpgs"
                        }, 
                        {
                            "id": "#etl.cwl/transform/mirna_profiling_mirna_tcga_isoforms_quant"
                        }, 
                        {
                            "id": "#etl.cwl/transform/mirna_profiling_mirna_tcga_mirnas_quant"
                        }, 
                        {
                            "id": "#etl.cwl/transform/picard_markduplicates_output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/tar_mirna_profiling_alignment_stats", 
                    "run": "#tar_dir.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/tar_mirna_profiling_alignment_stats/INPUT", 
                            "source": "#etl.cwl/transform/mirna_profiling_mirna_alignment_stats_features"
                        }, 
                        {
                            "id": "#etl.cwl/tar_mirna_profiling_alignment_stats/file", 
                            "valueFrom": "features.tar"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/tar_mirna_profiling_alignment_stats/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/tar_mirna_profiling_graph_libs", 
                    "run": "#tar_dir.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/tar_mirna_profiling_graph_libs/INPUT", 
                            "source": "#etl.cwl/transform/mirna_profiling_mirna_graph_libs_jpgs"
                        }, 
                        {
                            "id": "#etl.cwl/tar_mirna_profiling_graph_libs/file", 
                            "valueFrom": "graph_libs_jpgs.tar"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/tar_mirna_profiling_graph_libs/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/tar_mirna_profiling", 
                    "run": "#tar.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/tar_mirna_profiling/INPUT", 
                            "source": [
                                "#etl.cwl/transform/mirna_profiling_mirna_adapter_report_sorted_output", 
                                "#etl.cwl/tar_mirna_profiling_alignment_stats/OUTPUT", 
                                "#etl.cwl/tar_mirna_profiling_graph_libs/OUTPUT", 
                                "#etl.cwl/transform/mirna_profiling_mirna_expression_matrix_expn_matrix_txt", 
                                "#etl.cwl/transform/mirna_profiling_mirna_expression_matrix_expn_matrix_norm_txt", 
                                "#etl.cwl/transform/mirna_profiling_mirna_expression_matrix_expn_matrix_norm_log_txt", 
                                "#etl.cwl/transform/mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_txt", 
                                "#etl.cwl/transform/mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_norm_txt", 
                                "#etl.cwl/transform/mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_norm_log_txt", 
                                "#etl.cwl/transform/mirna_profiling_mirna_tcga_isoforms_quant", 
                                "#etl.cwl/transform/mirna_profiling_mirna_tcga_mirnas_quant"
                            ]
                        }, 
                        {
                            "id": "#etl.cwl/tar_mirna_profiling/file", 
                            "source": "#etl.cwl/task_uuid", 
                            "valueFrom": "$(self)_mirna_profiling.tar.xz"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/tar_mirna_profiling/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/rename_isoforms_quant", 
                    "run": "#rename.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/rename_isoforms_quant/INPUT", 
                            "source": "#etl.cwl/transform/mirna_profiling_mirna_tcga_isoforms_quant"
                        }, 
                        {
                            "id": "#etl.cwl/rename_isoforms_quant/OUTNAME", 
                            "source": "#etl.cwl/input_bam_gdc_id", 
                            "valueFrom": "$(self).mirbase21.isoforms.quantification.txt"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/rename_isoforms_quant/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/rename_mirnas_quant", 
                    "run": "#rename.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/rename_mirnas_quant/INPUT", 
                            "source": "#etl.cwl/transform/mirna_profiling_mirna_tcga_mirnas_quant"
                        }, 
                        {
                            "id": "#etl.cwl/rename_mirnas_quant/OUTNAME", 
                            "source": "#etl.cwl/input_bam_gdc_id", 
                            "valueFrom": "$(self).mirbase21.mirnas.quantification.txt"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/rename_mirnas_quant/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/load_bam", 
                    "run": "#aws_s3_put.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/load_bam/aws_config", 
                            "source": "#etl.cwl/aws_config"
                        }, 
                        {
                            "id": "#etl.cwl/load_bam/aws_shared_credentials", 
                            "source": "#etl.cwl/aws_shared_credentials"
                        }, 
                        {
                            "id": "#etl.cwl/load_bam/endpoint_json", 
                            "source": "#etl.cwl/endpoint_json"
                        }, 
                        {
                            "id": "#etl.cwl/load_bam/input", 
                            "source": "#etl.cwl/transform/picard_markduplicates_output"
                        }, 
                        {
                            "id": "#etl.cwl/load_bam/s3cfg_section", 
                            "source": "#etl.cwl/s3cfg_section"
                        }, 
                        {
                            "id": "#etl.cwl/load_bam/s3uri", 
                            "source": "#etl.cwl/load_bucket", 
                            "valueFrom": "$(self + \"/\" + inputs.task_uuid + \"/\")"
                        }, 
                        {
                            "id": "#etl.cwl/load_bam/task_uuid", 
                            "source": "#etl.cwl/task_uuid", 
                            "valueFrom": "$(null)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/load_bam/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/load_bai", 
                    "run": "#aws_s3_put.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/load_bai/aws_config", 
                            "source": "#etl.cwl/aws_config"
                        }, 
                        {
                            "id": "#etl.cwl/load_bai/aws_shared_credentials", 
                            "source": "#etl.cwl/aws_shared_credentials"
                        }, 
                        {
                            "id": "#etl.cwl/load_bai/endpoint_json", 
                            "source": "#etl.cwl/endpoint_json"
                        }, 
                        {
                            "id": "#etl.cwl/load_bai/input", 
                            "source": "#etl.cwl/transform/picard_markduplicates_output", 
                            "valueFrom": "$(self.secondaryFiles[0])"
                        }, 
                        {
                            "id": "#etl.cwl/load_bai/s3cfg_section", 
                            "source": "#etl.cwl/s3cfg_section"
                        }, 
                        {
                            "id": "#etl.cwl/load_bai/s3uri", 
                            "source": "#etl.cwl/load_bucket", 
                            "valueFrom": "$(self + \"/\" + inputs.task_uuid + \"/\")"
                        }, 
                        {
                            "id": "#etl.cwl/load_bai/task_uuid", 
                            "source": "#etl.cwl/task_uuid", 
                            "valueFrom": "$(null)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/load_bai/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/load_sqlite", 
                    "run": "#aws_s3_put.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/load_sqlite/aws_config", 
                            "source": "#etl.cwl/aws_config"
                        }, 
                        {
                            "id": "#etl.cwl/load_sqlite/aws_shared_credentials", 
                            "source": "#etl.cwl/aws_shared_credentials"
                        }, 
                        {
                            "id": "#etl.cwl/load_sqlite/endpoint_json", 
                            "source": "#etl.cwl/endpoint_json"
                        }, 
                        {
                            "id": "#etl.cwl/load_sqlite/input", 
                            "source": "#etl.cwl/transform/merge_all_sqlite_destination_sqlite"
                        }, 
                        {
                            "id": "#etl.cwl/load_sqlite/s3cfg_section", 
                            "source": "#etl.cwl/s3cfg_section"
                        }, 
                        {
                            "id": "#etl.cwl/load_sqlite/s3uri", 
                            "source": "#etl.cwl/load_bucket", 
                            "valueFrom": "$(self + \"/\" + inputs.task_uuid + \"/\")"
                        }, 
                        {
                            "id": "#etl.cwl/load_sqlite/task_uuid", 
                            "source": "#etl.cwl/task_uuid", 
                            "valueFrom": "$(null)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/load_sqlite/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/load_tar_mirna_profiling", 
                    "run": "#aws_s3_put.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/load_tar_mirna_profiling/aws_config", 
                            "source": "#etl.cwl/aws_config"
                        }, 
                        {
                            "id": "#etl.cwl/load_tar_mirna_profiling/aws_shared_credentials", 
                            "source": "#etl.cwl/aws_shared_credentials"
                        }, 
                        {
                            "id": "#etl.cwl/load_tar_mirna_profiling/endpoint_json", 
                            "source": "#etl.cwl/endpoint_json"
                        }, 
                        {
                            "id": "#etl.cwl/load_tar_mirna_profiling/input", 
                            "source": "#etl.cwl/tar_mirna_profiling/OUTPUT"
                        }, 
                        {
                            "id": "#etl.cwl/load_tar_mirna_profiling/s3cfg_section", 
                            "source": "#etl.cwl/s3cfg_section"
                        }, 
                        {
                            "id": "#etl.cwl/load_tar_mirna_profiling/s3uri", 
                            "source": "#etl.cwl/load_bucket", 
                            "valueFrom": "$(self + \"/\" + inputs.task_uuid + \"/\")"
                        }, 
                        {
                            "id": "#etl.cwl/load_tar_mirna_profiling/task_uuid", 
                            "source": "#etl.cwl/task_uuid", 
                            "valueFrom": "$(null)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/load_tar_mirna_profiling/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/load_mirna_profiling_isoforms_quant", 
                    "run": "#aws_s3_put.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/load_mirna_profiling_isoforms_quant/aws_config", 
                            "source": "#etl.cwl/aws_config"
                        }, 
                        {
                            "id": "#etl.cwl/load_mirna_profiling_isoforms_quant/aws_shared_credentials", 
                            "source": "#etl.cwl/aws_shared_credentials"
                        }, 
                        {
                            "id": "#etl.cwl/load_mirna_profiling_isoforms_quant/endpoint_json", 
                            "source": "#etl.cwl/endpoint_json"
                        }, 
                        {
                            "id": "#etl.cwl/load_mirna_profiling_isoforms_quant/input", 
                            "source": "#etl.cwl/rename_isoforms_quant/OUTPUT"
                        }, 
                        {
                            "id": "#etl.cwl/load_mirna_profiling_isoforms_quant/s3cfg_section", 
                            "source": "#etl.cwl/s3cfg_section"
                        }, 
                        {
                            "id": "#etl.cwl/load_mirna_profiling_isoforms_quant/s3uri", 
                            "source": "#etl.cwl/load_bucket", 
                            "valueFrom": "$(self + \"/\" + inputs.task_uuid + \"/\")"
                        }, 
                        {
                            "id": "#etl.cwl/load_mirna_profiling_isoforms_quant/task_uuid", 
                            "source": "#etl.cwl/task_uuid", 
                            "valueFrom": "$(null)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/load_mirna_profiling_isoforms_quant/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/load_mirna_profiling_mirnas_quant", 
                    "run": "#aws_s3_put.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/load_mirna_profiling_mirnas_quant/aws_config", 
                            "source": "#etl.cwl/aws_config"
                        }, 
                        {
                            "id": "#etl.cwl/load_mirna_profiling_mirnas_quant/aws_shared_credentials", 
                            "source": "#etl.cwl/aws_shared_credentials"
                        }, 
                        {
                            "id": "#etl.cwl/load_mirna_profiling_mirnas_quant/endpoint_json", 
                            "source": "#etl.cwl/endpoint_json"
                        }, 
                        {
                            "id": "#etl.cwl/load_mirna_profiling_mirnas_quant/input", 
                            "source": "#etl.cwl/rename_mirnas_quant/OUTPUT"
                        }, 
                        {
                            "id": "#etl.cwl/load_mirna_profiling_mirnas_quant/s3cfg_section", 
                            "source": "#etl.cwl/s3cfg_section"
                        }, 
                        {
                            "id": "#etl.cwl/load_mirna_profiling_mirnas_quant/s3uri", 
                            "source": "#etl.cwl/load_bucket", 
                            "valueFrom": "$(self + \"/\" + inputs.task_uuid + \"/\")"
                        }, 
                        {
                            "id": "#etl.cwl/load_mirna_profiling_mirnas_quant/task_uuid", 
                            "source": "#etl.cwl/task_uuid", 
                            "valueFrom": "$(null)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/load_mirna_profiling_mirnas_quant/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/generate_s3_bam_url", 
                    "run": "#generate_s3load_path.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/generate_s3_bam_url/load_bucket", 
                            "source": "#etl.cwl/load_bucket"
                        }, 
                        {
                            "id": "#etl.cwl/generate_s3_bam_url/filename", 
                            "source": "#etl.cwl/transform/picard_markduplicates_output", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#etl.cwl/generate_s3_bam_url/task_uuid", 
                            "source": "#etl.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/generate_s3_bam_url/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/generate_s3_bai_url", 
                    "run": "#generate_s3load_path.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/generate_s3_bai_url/load_bucket", 
                            "source": "#etl.cwl/load_bucket"
                        }, 
                        {
                            "id": "#etl.cwl/generate_s3_bai_url/filename", 
                            "source": "#etl.cwl/transform/picard_markduplicates_output", 
                            "valueFrom": "$(self.secondaryFiles[0].basename)"
                        }, 
                        {
                            "id": "#etl.cwl/generate_s3_bai_url/task_uuid", 
                            "source": "#etl.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/generate_s3_bai_url/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/generate_s3_mirna_profiling_tar_url", 
                    "run": "#generate_s3load_path.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/generate_s3_mirna_profiling_tar_url/load_bucket", 
                            "source": "#etl.cwl/load_bucket"
                        }, 
                        {
                            "id": "#etl.cwl/generate_s3_mirna_profiling_tar_url/filename", 
                            "source": "#etl.cwl/task_uuid", 
                            "valueFrom": "$(self)_mirna_profiling.tar.xz"
                        }, 
                        {
                            "id": "#etl.cwl/generate_s3_mirna_profiling_tar_url/task_uuid", 
                            "source": "#etl.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/generate_s3_mirna_profiling_tar_url/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/generate_s3_mirna_profiling_isoforms_quant_url", 
                    "run": "#generate_s3load_path.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/generate_s3_mirna_profiling_isoforms_quant_url/load_bucket", 
                            "source": "#etl.cwl/load_bucket"
                        }, 
                        {
                            "id": "#etl.cwl/generate_s3_mirna_profiling_isoforms_quant_url/filename", 
                            "source": "#etl.cwl/input_bam_gdc_id", 
                            "valueFrom": "$(self).mirbase21.isoforms.quantification.txt"
                        }, 
                        {
                            "id": "#etl.cwl/generate_s3_mirna_profiling_isoforms_quant_url/task_uuid", 
                            "source": "#etl.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/generate_s3_mirna_profiling_isoforms_quant_url/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/generate_s3_mirna_profiling_mirnas_quant_url", 
                    "run": "#generate_s3load_path.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/generate_s3_mirna_profiling_mirnas_quant_url/load_bucket", 
                            "source": "#etl.cwl/load_bucket"
                        }, 
                        {
                            "id": "#etl.cwl/generate_s3_mirna_profiling_mirnas_quant_url/filename", 
                            "source": "#etl.cwl/input_bam_gdc_id", 
                            "valueFrom": "$(self).mirbase21.mirnas.quantification.txt"
                        }, 
                        {
                            "id": "#etl.cwl/generate_s3_mirna_profiling_mirnas_quant_url/task_uuid", 
                            "source": "#etl.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/generate_s3_mirna_profiling_mirnas_quant_url/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/generate_s3_sqlite_url", 
                    "run": "#generate_s3load_path.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/generate_s3_sqlite_url/load_bucket", 
                            "source": "#etl.cwl/load_bucket"
                        }, 
                        {
                            "id": "#etl.cwl/generate_s3_sqlite_url/filename", 
                            "source": "#etl.cwl/transform/merge_all_sqlite_destination_sqlite", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#etl.cwl/generate_s3_sqlite_url/task_uuid", 
                            "source": "#etl.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/generate_s3_sqlite_url/output"
                        }
                    ]
                }, 
                {
                    "id": "#etl.cwl/generate_token", 
                    "run": "#generate_load_token.cwl", 
                    "in": [
                        {
                            "id": "#etl.cwl/generate_token/load1", 
                            "source": "#etl.cwl/load_bam/output"
                        }, 
                        {
                            "id": "#etl.cwl/generate_token/load2", 
                            "source": "#etl.cwl/load_bai/output"
                        }, 
                        {
                            "id": "#etl.cwl/generate_token/load3", 
                            "source": "#etl.cwl/load_mirna_profiling_isoforms_quant/output"
                        }, 
                        {
                            "id": "#etl.cwl/generate_token/load4", 
                            "source": "#etl.cwl/load_mirna_profiling_mirnas_quant/output"
                        }, 
                        {
                            "id": "#etl.cwl/generate_token/load5", 
                            "source": "#etl.cwl/load_tar_mirna_profiling/output"
                        }, 
                        {
                            "id": "#etl.cwl/generate_token/load6", 
                            "source": "#etl.cwl/load_sqlite/output"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#etl.cwl/generate_token/token"
                        }
                    ]
                }
            ], 
            "id": "#etl.cwl"
        }, 
        {
            "class": "Workflow", 
            "requirements": [
                {
                    "class": "StepInputExpressionRequirement"
                }, 
                {
                    "class": "MultipleInputFeatureRequirement"
                }
            ], 
            "inputs": [
                {
                    "id": "#integrity.cwl/bai", 
                    "type": "File"
                }, 
                {
                    "id": "#integrity.cwl/bam", 
                    "type": "File"
                }, 
                {
                    "id": "#integrity.cwl/input_state", 
                    "type": "string"
                }, 
                {
                    "id": "#integrity.cwl/task_uuid", 
                    "type": "string"
                }
            ], 
            "outputs": [
                {
                    "id": "#integrity.cwl/merge_sqlite_destination_sqlite", 
                    "type": "File", 
                    "outputSource": "#integrity.cwl/merge_sqlite/destination_sqlite"
                }
            ], 
            "steps": [
                {
                    "id": "#integrity.cwl/bai_ls_l", 
                    "run": "#ls_l.cwl", 
                    "in": [
                        {
                            "id": "#integrity.cwl/bai_ls_l/INPUT", 
                            "source": "#integrity.cwl/bai"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#integrity.cwl/bai_ls_l/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#integrity.cwl/bai_md5sum", 
                    "run": "#md5sum.cwl", 
                    "in": [
                        {
                            "id": "#integrity.cwl/bai_md5sum/INPUT", 
                            "source": "#integrity.cwl/bai"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#integrity.cwl/bai_md5sum/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#integrity.cwl/bai_sha256", 
                    "run": "#sha256sum.cwl", 
                    "in": [
                        {
                            "id": "#integrity.cwl/bai_sha256/INPUT", 
                            "source": "#integrity.cwl/bai"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#integrity.cwl/bai_sha256/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#integrity.cwl/bam_ls_l", 
                    "run": "#ls_l.cwl", 
                    "in": [
                        {
                            "id": "#integrity.cwl/bam_ls_l/INPUT", 
                            "source": "#integrity.cwl/bam"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#integrity.cwl/bam_ls_l/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#integrity.cwl/bam_md5sum", 
                    "run": "#md5sum.cwl", 
                    "in": [
                        {
                            "id": "#integrity.cwl/bam_md5sum/INPUT", 
                            "source": "#integrity.cwl/bam"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#integrity.cwl/bam_md5sum/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#integrity.cwl/bam_sha256", 
                    "run": "#sha256sum.cwl", 
                    "in": [
                        {
                            "id": "#integrity.cwl/bam_sha256/INPUT", 
                            "source": "#integrity.cwl/bam"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#integrity.cwl/bam_sha256/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#integrity.cwl/bai_integrity_to_db", 
                    "run": "#integrity_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#integrity.cwl/bai_integrity_to_db/input_state", 
                            "source": "#integrity.cwl/input_state"
                        }, 
                        {
                            "id": "#integrity.cwl/bai_integrity_to_db/ls_l_path", 
                            "source": "#integrity.cwl/bai_ls_l/OUTPUT"
                        }, 
                        {
                            "id": "#integrity.cwl/bai_integrity_to_db/md5sum_path", 
                            "source": "#integrity.cwl/bai_md5sum/OUTPUT"
                        }, 
                        {
                            "id": "#integrity.cwl/bai_integrity_to_db/sha256sum_path", 
                            "source": "#integrity.cwl/bai_sha256/OUTPUT"
                        }, 
                        {
                            "id": "#integrity.cwl/bai_integrity_to_db/task_uuid", 
                            "source": "#integrity.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#integrity.cwl/bai_integrity_to_db/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#integrity.cwl/bam_integrity_to_db", 
                    "run": "#integrity_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#integrity.cwl/bam_integrity_to_db/input_state", 
                            "source": "#integrity.cwl/input_state"
                        }, 
                        {
                            "id": "#integrity.cwl/bam_integrity_to_db/ls_l_path", 
                            "source": "#integrity.cwl/bam_ls_l/OUTPUT"
                        }, 
                        {
                            "id": "#integrity.cwl/bam_integrity_to_db/md5sum_path", 
                            "source": "#integrity.cwl/bam_md5sum/OUTPUT"
                        }, 
                        {
                            "id": "#integrity.cwl/bam_integrity_to_db/sha256sum_path", 
                            "source": "#integrity.cwl/bam_sha256/OUTPUT"
                        }, 
                        {
                            "id": "#integrity.cwl/bam_integrity_to_db/task_uuid", 
                            "source": "#integrity.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#integrity.cwl/bam_integrity_to_db/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#integrity.cwl/merge_sqlite", 
                    "run": "#merge_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#integrity.cwl/merge_sqlite/source_sqlite", 
                            "source": [
                                "#integrity.cwl/bai_integrity_to_db/OUTPUT", 
                                "#integrity.cwl/bam_integrity_to_db/OUTPUT"
                            ]
                        }, 
                        {
                            "id": "#integrity.cwl/merge_sqlite/task_uuid", 
                            "source": "#integrity.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#integrity.cwl/merge_sqlite/destination_sqlite"
                        }, 
                        {
                            "id": "#integrity.cwl/merge_sqlite/log"
                        }
                    ]
                }
            ], 
            "id": "#integrity.cwl"
        }, 
        {
            "class": "Workflow", 
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "inputs": [
                {
                    "id": "#metrics.cwl/bam", 
                    "type": "File"
                }, 
                {
                    "id": "#metrics.cwl/known_snp", 
                    "type": "File"
                }, 
                {
                    "id": "#metrics.cwl/fasta", 
                    "type": "File"
                }, 
                {
                    "id": "#metrics.cwl/input_state", 
                    "type": "string"
                }, 
                {
                    "id": "#metrics.cwl/parent_bam", 
                    "type": "string"
                }, 
                {
                    "id": "#metrics.cwl/thread_count", 
                    "type": "long"
                }, 
                {
                    "id": "#metrics.cwl/task_uuid", 
                    "type": "string"
                }
            ], 
            "outputs": [
                {
                    "id": "#metrics.cwl/merge_sqlite_destination_sqlite", 
                    "type": "File", 
                    "outputSource": "#metrics.cwl/merge_sqlite/destination_sqlite"
                }
            ], 
            "steps": [
                {
                    "id": "#metrics.cwl/picard_collectmultiplemetrics", 
                    "run": "#picard_collectmultiplemetrics.cwl", 
                    "in": [
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/DB_SNP", 
                            "source": "#metrics.cwl/known_snp"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/INPUT", 
                            "source": "#metrics.cwl/bam"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/REFERENCE_SEQUENCE", 
                            "source": "#metrics.cwl/fasta"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/alignment_summary_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/bait_bias_detail_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/bait_bias_summary_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/base_distribution_by_cycle_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/gc_bias_detail_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/gc_bias_summary_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/insert_size_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/pre_adapter_detail_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/pre_adapter_summary_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/quality_by_cycle_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/quality_distribution_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics/quality_yield_metrics"
                        }
                    ]
                }, 
                {
                    "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite", 
                    "run": "#picard_collectmultiplemetrics_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/bam", 
                            "source": "#metrics.cwl/bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/fasta", 
                            "source": "#metrics.cwl/fasta", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/input_state", 
                            "source": "#metrics.cwl/input_state"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/task_uuid", 
                            "source": "#metrics.cwl/task_uuid"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/vcf", 
                            "source": "#metrics.cwl/known_snp", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/alignment_summary_metrics", 
                            "source": "#metrics.cwl/picard_collectmultiplemetrics/alignment_summary_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/bait_bias_detail_metrics", 
                            "source": "#metrics.cwl/picard_collectmultiplemetrics/bait_bias_detail_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/bait_bias_summary_metrics", 
                            "source": "#metrics.cwl/picard_collectmultiplemetrics/bait_bias_summary_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/base_distribution_by_cycle_metrics", 
                            "source": "#metrics.cwl/picard_collectmultiplemetrics/base_distribution_by_cycle_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/gc_bias_detail_metrics", 
                            "source": "#metrics.cwl/picard_collectmultiplemetrics/gc_bias_detail_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/gc_bias_summary_metrics", 
                            "source": "#metrics.cwl/picard_collectmultiplemetrics/gc_bias_summary_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/insert_size_metrics", 
                            "source": "#metrics.cwl/picard_collectmultiplemetrics/insert_size_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/pre_adapter_detail_metrics", 
                            "source": "#metrics.cwl/picard_collectmultiplemetrics/pre_adapter_detail_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/pre_adapter_summary_metrics", 
                            "source": "#metrics.cwl/picard_collectmultiplemetrics/pre_adapter_summary_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/quality_by_cycle_metrics", 
                            "source": "#metrics.cwl/picard_collectmultiplemetrics/quality_by_cycle_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/quality_distribution_metrics", 
                            "source": "#metrics.cwl/picard_collectmultiplemetrics/quality_distribution_metrics"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/quality_yield_metrics", 
                            "source": "#metrics.cwl/picard_collectmultiplemetrics/quality_yield_metrics"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/log"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#metrics.cwl/picard_collectoxogmetrics", 
                    "run": "#picard_collectoxogmetrics.cwl", 
                    "in": [
                        {
                            "id": "#metrics.cwl/picard_collectoxogmetrics/DB_SNP", 
                            "source": "#metrics.cwl/known_snp"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectoxogmetrics/INPUT", 
                            "source": "#metrics.cwl/bam"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectoxogmetrics/REFERENCE_SEQUENCE", 
                            "source": "#metrics.cwl/fasta"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#metrics.cwl/picard_collectoxogmetrics/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#metrics.cwl/picard_collectoxogmetrics_to_sqlite", 
                    "run": "#picard_collectoxogmetrics_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#metrics.cwl/picard_collectoxogmetrics_to_sqlite/bam", 
                            "source": "#metrics.cwl/bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectoxogmetrics_to_sqlite/fasta", 
                            "source": "#metrics.cwl/fasta", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectoxogmetrics_to_sqlite/input_state", 
                            "source": "#metrics.cwl/input_state"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectoxogmetrics_to_sqlite/metric_path", 
                            "source": "#metrics.cwl/picard_collectoxogmetrics/OUTPUT"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectoxogmetrics_to_sqlite/task_uuid", 
                            "source": "#metrics.cwl/task_uuid"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectoxogmetrics_to_sqlite/vcf", 
                            "source": "#metrics.cwl/known_snp", 
                            "valueFrom": "$(self.basename)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#metrics.cwl/picard_collectoxogmetrics_to_sqlite/log"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectoxogmetrics_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#metrics.cwl/picard_collectwgsmetrics", 
                    "run": "#picard_collectwgsmetrics.cwl", 
                    "in": [
                        {
                            "id": "#metrics.cwl/picard_collectwgsmetrics/INPUT", 
                            "source": "#metrics.cwl/bam"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectwgsmetrics/REFERENCE_SEQUENCE", 
                            "source": "#metrics.cwl/fasta"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#metrics.cwl/picard_collectwgsmetrics/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#metrics.cwl/picard_collectwgsmetrics_to_sqlite", 
                    "run": "#picard_collectwgsmetrics_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#metrics.cwl/picard_collectwgsmetrics_to_sqlite/bam", 
                            "source": "#metrics.cwl/bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectwgsmetrics_to_sqlite/fasta", 
                            "source": "#metrics.cwl/fasta", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectwgsmetrics_to_sqlite/input_state", 
                            "source": "#metrics.cwl/input_state"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectwgsmetrics_to_sqlite/metric_path", 
                            "source": "#metrics.cwl/picard_collectwgsmetrics/OUTPUT"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectwgsmetrics_to_sqlite/task_uuid", 
                            "source": "#metrics.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#metrics.cwl/picard_collectwgsmetrics_to_sqlite/log"
                        }, 
                        {
                            "id": "#metrics.cwl/picard_collectwgsmetrics_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#metrics.cwl/samtools_flagstat", 
                    "run": "#samtools_flagstat.cwl", 
                    "in": [
                        {
                            "id": "#metrics.cwl/samtools_flagstat/INPUT", 
                            "source": "#metrics.cwl/bam"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#metrics.cwl/samtools_flagstat/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#metrics.cwl/samtools_flagstat_to_sqlite", 
                    "run": "#samtools_flagstat_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#metrics.cwl/samtools_flagstat_to_sqlite/bam", 
                            "source": "#metrics.cwl/bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#metrics.cwl/samtools_flagstat_to_sqlite/input_state", 
                            "source": "#metrics.cwl/input_state"
                        }, 
                        {
                            "id": "#metrics.cwl/samtools_flagstat_to_sqlite/metric_path", 
                            "source": "#metrics.cwl/samtools_flagstat/OUTPUT"
                        }, 
                        {
                            "id": "#metrics.cwl/samtools_flagstat_to_sqlite/task_uuid", 
                            "source": "#metrics.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#metrics.cwl/samtools_flagstat_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#metrics.cwl/samtools_idxstats", 
                    "run": "#samtools_idxstats.cwl", 
                    "in": [
                        {
                            "id": "#metrics.cwl/samtools_idxstats/INPUT", 
                            "source": "#metrics.cwl/bam"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#metrics.cwl/samtools_idxstats/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#metrics.cwl/samtools_idxstats_to_sqlite", 
                    "run": "#samtools_idxstats_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#metrics.cwl/samtools_idxstats_to_sqlite/bam", 
                            "source": "#metrics.cwl/bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#metrics.cwl/samtools_idxstats_to_sqlite/input_state", 
                            "source": "#metrics.cwl/input_state"
                        }, 
                        {
                            "id": "#metrics.cwl/samtools_idxstats_to_sqlite/metric_path", 
                            "source": "#metrics.cwl/samtools_idxstats/OUTPUT"
                        }, 
                        {
                            "id": "#metrics.cwl/samtools_idxstats_to_sqlite/task_uuid", 
                            "source": "#metrics.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#metrics.cwl/samtools_idxstats_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#metrics.cwl/samtools_stats", 
                    "run": "#samtools_stats.cwl", 
                    "in": [
                        {
                            "id": "#metrics.cwl/samtools_stats/INPUT", 
                            "source": "#metrics.cwl/bam"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#metrics.cwl/samtools_stats/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#metrics.cwl/samtools_stats_to_sqlite", 
                    "run": "#samtools_stats_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#metrics.cwl/samtools_stats_to_sqlite/bam", 
                            "source": "#metrics.cwl/bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#metrics.cwl/samtools_stats_to_sqlite/input_state", 
                            "source": "#metrics.cwl/input_state"
                        }, 
                        {
                            "id": "#metrics.cwl/samtools_stats_to_sqlite/metric_path", 
                            "source": "#metrics.cwl/samtools_stats/OUTPUT"
                        }, 
                        {
                            "id": "#metrics.cwl/samtools_stats_to_sqlite/task_uuid", 
                            "source": "#metrics.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#metrics.cwl/samtools_stats_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#metrics.cwl/merge_sqlite", 
                    "run": "#merge_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#metrics.cwl/merge_sqlite/source_sqlite", 
                            "source": [
                                "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/sqlite", 
                                "#metrics.cwl/picard_collectoxogmetrics_to_sqlite/sqlite", 
                                "#metrics.cwl/picard_collectwgsmetrics_to_sqlite/sqlite", 
                                "#metrics.cwl/samtools_flagstat_to_sqlite/sqlite", 
                                "#metrics.cwl/samtools_idxstats_to_sqlite/sqlite", 
                                "#metrics.cwl/samtools_stats_to_sqlite/sqlite"
                            ]
                        }, 
                        {
                            "id": "#metrics.cwl/merge_sqlite/task_uuid", 
                            "source": "#metrics.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#metrics.cwl/merge_sqlite/destination_sqlite"
                        }, 
                        {
                            "id": "#metrics.cwl/merge_sqlite/log"
                        }
                    ]
                }
            ], 
            "id": "#metrics.cwl"
        }, 
        {
            "class": "Workflow", 
            "requirements": [
                {
                    "class": "StepInputExpressionRequirement"
                }
            ], 
            "inputs": [
                {
                    "id": "#mirna_profiling.cwl/awk_expression", 
                    "type": "string"
                }, 
                {
                    "id": "#mirna_profiling.cwl/bam", 
                    "type": "File"
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirbase_db", 
                    "type": "string"
                }, 
                {
                    "id": "#mirna_profiling.cwl/species_code", 
                    "type": "string"
                }, 
                {
                    "id": "#mirna_profiling.cwl/project_directory", 
                    "type": "string"
                }, 
                {
                    "id": "#mirna_profiling.cwl/ucsc_database", 
                    "type": "string"
                }
            ], 
            "outputs": [
                {
                    "id": "#mirna_profiling.cwl/mirna_adapter_report_sorted_output", 
                    "type": "File", 
                    "outputSource": "#mirna_profiling.cwl/mirna_adapter_report_sorted/OUTPUT"
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_alignment_stats_features", 
                    "type": "Directory", 
                    "outputSource": "#mirna_profiling.cwl/mirna_alignment_stats/features"
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_expression_matrix_expn_matrix_txt", 
                    "type": "File", 
                    "outputSource": "#mirna_profiling.cwl/mirna_expression_matrix/expn_matrix_txt"
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_expression_matrix_expn_matrix_norm_txt", 
                    "type": "File", 
                    "outputSource": "#mirna_profiling.cwl/mirna_expression_matrix/expn_matrix_norm_txt"
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_expression_matrix_expn_matrix_norm_log_txt", 
                    "type": "File", 
                    "outputSource": "#mirna_profiling.cwl/mirna_expression_matrix/expn_matrix_norm_log_txt"
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_expression_matrix_mimat_expn_matrix_mimat_txt", 
                    "type": "File", 
                    "outputSource": "#mirna_profiling.cwl/mirna_expression_matrix_mimat/expn_matrix_mimat_txt"
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_expression_matrix_mimat_expn_matrix_mimat_norm_txt", 
                    "type": "File", 
                    "outputSource": "#mirna_profiling.cwl/mirna_expression_matrix_mimat/expn_matrix_mimat_norm_txt"
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_expression_matrix_mimat_expn_matrix_mimat_norm_log_txt", 
                    "type": "File", 
                    "outputSource": "#mirna_profiling.cwl/mirna_expression_matrix_mimat/expn_matrix_mimat_norm_log_txt"
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_graph_libs_jpgs", 
                    "type": "Directory", 
                    "outputSource": "#mirna_profiling.cwl/mirna_graph_libs/jpgs"
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_tcga_isoforms_quant", 
                    "type": "File", 
                    "outputSource": "#mirna_profiling.cwl/mirna_tcga/isoforms_quant"
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_tcga_mirnas_quant", 
                    "type": "File", 
                    "outputSource": "#mirna_profiling.cwl/mirna_tcga/mirnas_quant"
                }
            ], 
            "steps": [
                {
                    "id": "#mirna_profiling.cwl/samtools_bamtosam", 
                    "run": "#samtools_view.cwl", 
                    "in": [
                        {
                            "id": "#mirna_profiling.cwl/samtools_bamtosam/INPUT", 
                            "source": "#mirna_profiling.cwl/bam"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/samtools_bamtosam/output_format", 
                            "valueFrom": "SAM"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mirna_profiling.cwl/samtools_bamtosam/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_adapter_report", 
                    "run": "#awk.cwl", 
                    "in": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_adapter_report/INPUT", 
                            "source": "#mirna_profiling.cwl/samtools_bamtosam/OUTPUT"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_adapter_report/EXPRESSION", 
                            "source": "#mirna_profiling.cwl/awk_expression"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_adapter_report/OUTFILE", 
                            "source": "#mirna_profiling.cwl/samtools_bamtosam/OUTPUT", 
                            "valueFrom": "$(self.nameroot)_adapter.report"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_adapter_report/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_adapter_report_sorted", 
                    "run": "#sort.cwl", 
                    "in": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_adapter_report_sorted/INPUT", 
                            "source": "#mirna_profiling.cwl/mirna_adapter_report/OUTPUT"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_adapter_report_sorted/key", 
                            "valueFrom": "1n"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_adapter_report_sorted/OUTFILE", 
                            "source": "#mirna_profiling.cwl/mirna_adapter_report/OUTPUT", 
                            "valueFrom": "$(self.basename)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_adapter_report_sorted/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_annotate", 
                    "run": "#mirna_annotate.cwl", 
                    "in": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_annotate/sam", 
                            "source": "#mirna_profiling.cwl/samtools_bamtosam/OUTPUT"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_annotate/mirbase", 
                            "source": "#mirna_profiling.cwl/mirbase_db"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_annotate/ucsc_database", 
                            "source": "#mirna_profiling.cwl/ucsc_database"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_annotate/species_code", 
                            "source": "#mirna_profiling.cwl/species_code"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_annotate/project_directory", 
                            "source": "#mirna_profiling.cwl/project_directory"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_annotate/output"
                        }
                    ]
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_alignment_stats", 
                    "run": "#mirna_alignment_stats.cwl", 
                    "in": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_alignment_stats/adapter_report", 
                            "source": "#mirna_profiling.cwl/mirna_adapter_report_sorted/OUTPUT"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_alignment_stats/sam", 
                            "source": "#mirna_profiling.cwl/mirna_annotate/output"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_alignment_stats/project_directory", 
                            "source": "#mirna_profiling.cwl/project_directory"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_alignment_stats/features"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_alignment_stats/alignment_stats_csv"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_alignment_stats/chastity_taglengths_csv"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_alignment_stats/crossmapped_txt"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_alignment_stats/filtered_taglengths_csv"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_alignment_stats/isoforms_txt"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_alignment_stats/miRNA_txt"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_alignment_stats/mirna_species_txt"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_alignment_stats/softclip_taglengths_csv"
                        }
                    ]
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_tcga", 
                    "run": "#mirna_tcga.cwl", 
                    "in": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_tcga/genome_version", 
                            "source": "#mirna_profiling.cwl/ucsc_database"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_tcga/mirbase_db", 
                            "source": "#mirna_profiling.cwl/mirbase_db"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_tcga/project_directory", 
                            "source": "#mirna_profiling.cwl/project_directory"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_tcga/species_code", 
                            "source": "#mirna_profiling.cwl/species_code"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_tcga/sam", 
                            "source": "#mirna_profiling.cwl/mirna_annotate/output"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_tcga/stats_miRNA_txt", 
                            "source": "#mirna_profiling.cwl/mirna_alignment_stats/miRNA_txt"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_tcga/stats_crossmapped_txt", 
                            "source": "#mirna_profiling.cwl/mirna_alignment_stats/crossmapped_txt"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_tcga/stats_isoforms_txt", 
                            "source": "#mirna_profiling.cwl/mirna_alignment_stats/isoforms_txt"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_tcga/isoforms_quant"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_tcga/mirnas_quant"
                        }
                    ]
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_expression_matrix", 
                    "run": "#mirna_expression_matrix.cwl", 
                    "in": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix/mirbase_db", 
                            "source": "#mirna_profiling.cwl/mirbase_db"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix/project_db", 
                            "source": "#mirna_profiling.cwl/project_directory"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix/species_code", 
                            "source": "#mirna_profiling.cwl/species_code"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix/stats_mirna_species_txt", 
                            "source": "#mirna_profiling.cwl/mirna_alignment_stats/mirna_species_txt"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix/expn_matrix_txt"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix/expn_matrix_norm_txt"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix/expn_matrix_norm_log_txt"
                        }
                    ]
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_expression_matrix_mimat", 
                    "run": "#mirna_expression_matrix_mimat.cwl", 
                    "in": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix_mimat/mirbase_db", 
                            "source": "#mirna_profiling.cwl/mirbase_db"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix_mimat/project_directory", 
                            "source": "#mirna_profiling.cwl/project_directory"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix_mimat/species_code", 
                            "source": "#mirna_profiling.cwl/species_code"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix_mimat/stats_crossmapped_txt", 
                            "source": "#mirna_profiling.cwl/mirna_alignment_stats/crossmapped_txt"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix_mimat/stats_mirna_txt", 
                            "source": "#mirna_profiling.cwl/mirna_alignment_stats/miRNA_txt"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix_mimat/expn_matrix_mimat_txt"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix_mimat/expn_matrix_mimat_norm_txt"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_expression_matrix_mimat/expn_matrix_mimat_norm_log_txt"
                        }
                    ]
                }, 
                {
                    "id": "#mirna_profiling.cwl/mirna_graph_libs", 
                    "run": "#mirna_graph_libs.cwl", 
                    "in": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_graph_libs/sam", 
                            "source": "#mirna_profiling.cwl/mirna_annotate/output"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_graph_libs/adapter_report", 
                            "source": "#mirna_profiling.cwl/mirna_adapter_report_sorted/OUTPUT"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_graph_libs/alignment_stats_csv", 
                            "source": "#mirna_profiling.cwl/mirna_alignment_stats/alignment_stats_csv"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_graph_libs/chastity_taglengths_csv", 
                            "source": "#mirna_profiling.cwl/mirna_alignment_stats/chastity_taglengths_csv"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_graph_libs/filtered_taglengths_csv", 
                            "source": "#mirna_profiling.cwl/mirna_alignment_stats/filtered_taglengths_csv"
                        }, 
                        {
                            "id": "#mirna_profiling.cwl/mirna_graph_libs/softclip_taglengths_csv", 
                            "source": "#mirna_profiling.cwl/mirna_alignment_stats/softclip_taglengths_csv"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mirna_profiling.cwl/mirna_graph_libs/jpgs"
                        }
                    ]
                }
            ], 
            "id": "#mirna_profiling.cwl"
        }, 
        {
            "class": "Workflow", 
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                }
            ], 
            "inputs": [
                {
                    "id": "#mixed_library_metrics.cwl/bam", 
                    "type": "File"
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/known_snp", 
                    "type": "File"
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/fasta", 
                    "type": "File"
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/input_state", 
                    "type": "string"
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/thread_count", 
                    "type": "long"
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/task_uuid", 
                    "type": "string"
                }
            ], 
            "outputs": [
                {
                    "id": "#mixed_library_metrics.cwl/merge_sqlite_destination_sqlite", 
                    "type": "File", 
                    "outputSource": "#mixed_library_metrics.cwl/merge_sqlite/destination_sqlite"
                }
            ], 
            "steps": [
                {
                    "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics", 
                    "run": "#picard_collectmultiplemetrics.cwl", 
                    "in": [
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/DB_SNP", 
                            "source": "#mixed_library_metrics.cwl/known_snp"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/INPUT", 
                            "source": "#mixed_library_metrics.cwl/bam"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/REFERENCE_SEQUENCE", 
                            "source": "#mixed_library_metrics.cwl/fasta"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/alignment_summary_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/bait_bias_detail_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/bait_bias_summary_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/base_distribution_by_cycle_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/gc_bias_detail_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/gc_bias_summary_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/insert_size_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/pre_adapter_detail_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/pre_adapter_summary_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/quality_by_cycle_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/quality_distribution_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/quality_yield_metrics"
                        }
                    ]
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite", 
                    "run": "#picard_collectmultiplemetrics_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/bam", 
                            "source": "#mixed_library_metrics.cwl/bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/fasta", 
                            "source": "#mixed_library_metrics.cwl/fasta", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/input_state", 
                            "source": "#mixed_library_metrics.cwl/input_state"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/task_uuid", 
                            "source": "#mixed_library_metrics.cwl/task_uuid"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/vcf", 
                            "source": "#mixed_library_metrics.cwl/known_snp", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/alignment_summary_metrics", 
                            "source": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/alignment_summary_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/bait_bias_detail_metrics", 
                            "source": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/bait_bias_detail_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/bait_bias_summary_metrics", 
                            "source": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/bait_bias_summary_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/base_distribution_by_cycle_metrics", 
                            "source": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/base_distribution_by_cycle_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/gc_bias_detail_metrics", 
                            "source": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/gc_bias_detail_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/gc_bias_summary_metrics", 
                            "source": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/gc_bias_summary_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/insert_size_metrics", 
                            "source": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/insert_size_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/pre_adapter_detail_metrics", 
                            "source": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/pre_adapter_detail_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/pre_adapter_summary_metrics", 
                            "source": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/pre_adapter_summary_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/quality_by_cycle_metrics", 
                            "source": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/quality_by_cycle_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/quality_distribution_metrics", 
                            "source": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/quality_distribution_metrics"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/quality_yield_metrics", 
                            "source": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics/quality_yield_metrics"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/log"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/picard_collectoxogmetrics", 
                    "run": "#picard_collectoxogmetrics.cwl", 
                    "in": [
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectoxogmetrics/DB_SNP", 
                            "source": "#mixed_library_metrics.cwl/known_snp"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectoxogmetrics/INPUT", 
                            "source": "#mixed_library_metrics.cwl/bam"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectoxogmetrics/REFERENCE_SEQUENCE", 
                            "source": "#mixed_library_metrics.cwl/fasta"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectoxogmetrics/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/picard_collectoxogmetrics_to_sqlite", 
                    "run": "#picard_collectoxogmetrics_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectoxogmetrics_to_sqlite/bam", 
                            "source": "#mixed_library_metrics.cwl/bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectoxogmetrics_to_sqlite/fasta", 
                            "source": "#mixed_library_metrics.cwl/fasta", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectoxogmetrics_to_sqlite/input_state", 
                            "source": "#mixed_library_metrics.cwl/input_state"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectoxogmetrics_to_sqlite/metric_path", 
                            "source": "#mixed_library_metrics.cwl/picard_collectoxogmetrics/OUTPUT"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectoxogmetrics_to_sqlite/task_uuid", 
                            "source": "#mixed_library_metrics.cwl/task_uuid"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectoxogmetrics_to_sqlite/vcf", 
                            "source": "#mixed_library_metrics.cwl/known_snp", 
                            "valueFrom": "$(self.basename)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectoxogmetrics_to_sqlite/log"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectoxogmetrics_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/picard_collectwgsmetrics", 
                    "run": "#picard_collectwgsmetrics.cwl", 
                    "in": [
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectwgsmetrics/INPUT", 
                            "source": "#mixed_library_metrics.cwl/bam"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectwgsmetrics/REFERENCE_SEQUENCE", 
                            "source": "#mixed_library_metrics.cwl/fasta"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectwgsmetrics/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/picard_collectwgsmetrics_to_sqlite", 
                    "run": "#picard_collectwgsmetrics_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectwgsmetrics_to_sqlite/bam", 
                            "source": "#mixed_library_metrics.cwl/bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectwgsmetrics_to_sqlite/fasta", 
                            "source": "#mixed_library_metrics.cwl/fasta", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectwgsmetrics_to_sqlite/input_state", 
                            "source": "#mixed_library_metrics.cwl/input_state"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectwgsmetrics_to_sqlite/metric_path", 
                            "source": "#mixed_library_metrics.cwl/picard_collectwgsmetrics/OUTPUT"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectwgsmetrics_to_sqlite/task_uuid", 
                            "source": "#mixed_library_metrics.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectwgsmetrics_to_sqlite/log"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/picard_collectwgsmetrics_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/samtools_flagstat", 
                    "run": "#samtools_flagstat.cwl", 
                    "in": [
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_flagstat/INPUT", 
                            "source": "#mixed_library_metrics.cwl/bam"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_flagstat/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/samtools_flagstat_to_sqlite", 
                    "run": "#samtools_flagstat_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_flagstat_to_sqlite/bam", 
                            "source": "#mixed_library_metrics.cwl/bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_flagstat_to_sqlite/input_state", 
                            "source": "#mixed_library_metrics.cwl/input_state"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_flagstat_to_sqlite/metric_path", 
                            "source": "#mixed_library_metrics.cwl/samtools_flagstat/OUTPUT"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_flagstat_to_sqlite/task_uuid", 
                            "source": "#mixed_library_metrics.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_flagstat_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/samtools_idxstats", 
                    "run": "#samtools_idxstats.cwl", 
                    "in": [
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_idxstats/INPUT", 
                            "source": "#mixed_library_metrics.cwl/bam"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_idxstats/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/samtools_idxstats_to_sqlite", 
                    "run": "#samtools_idxstats_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_idxstats_to_sqlite/bam", 
                            "source": "#mixed_library_metrics.cwl/bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_idxstats_to_sqlite/input_state", 
                            "source": "#mixed_library_metrics.cwl/input_state"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_idxstats_to_sqlite/metric_path", 
                            "source": "#mixed_library_metrics.cwl/samtools_idxstats/OUTPUT"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_idxstats_to_sqlite/task_uuid", 
                            "source": "#mixed_library_metrics.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_idxstats_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/samtools_stats", 
                    "run": "#samtools_stats.cwl", 
                    "in": [
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_stats/INPUT", 
                            "source": "#mixed_library_metrics.cwl/bam"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_stats/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/samtools_stats_to_sqlite", 
                    "run": "#samtools_stats_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_stats_to_sqlite/bam", 
                            "source": "#mixed_library_metrics.cwl/bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_stats_to_sqlite/input_state", 
                            "source": "#mixed_library_metrics.cwl/input_state"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_stats_to_sqlite/metric_path", 
                            "source": "#mixed_library_metrics.cwl/samtools_stats/OUTPUT"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_stats_to_sqlite/task_uuid", 
                            "source": "#mixed_library_metrics.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mixed_library_metrics.cwl/samtools_stats_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#mixed_library_metrics.cwl/merge_sqlite", 
                    "run": "#merge_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#mixed_library_metrics.cwl/merge_sqlite/source_sqlite", 
                            "source": [
                                "#mixed_library_metrics.cwl/picard_collectmultiplemetrics_to_sqlite/sqlite", 
                                "#mixed_library_metrics.cwl/picard_collectoxogmetrics_to_sqlite/sqlite", 
                                "#mixed_library_metrics.cwl/picard_collectwgsmetrics_to_sqlite/sqlite", 
                                "#mixed_library_metrics.cwl/samtools_flagstat_to_sqlite/sqlite", 
                                "#mixed_library_metrics.cwl/samtools_idxstats_to_sqlite/sqlite", 
                                "#mixed_library_metrics.cwl/samtools_stats_to_sqlite/sqlite"
                            ]
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/merge_sqlite/task_uuid", 
                            "source": "#mixed_library_metrics.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#mixed_library_metrics.cwl/merge_sqlite/destination_sqlite"
                        }, 
                        {
                            "id": "#mixed_library_metrics.cwl/merge_sqlite/log"
                        }
                    ]
                }
            ], 
            "id": "#mixed_library_metrics.cwl"
        }, 
        {
            "class": "Workflow", 
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                }, 
                {
                    "class": "StepInputExpressionRequirement"
                }, 
                {
                    "class": "SubworkflowFeatureRequirement"
                }
            ], 
            "inputs": [
                {
                    "id": "#main/cwl_workflow_git_hash", 
                    "type": "string"
                }, 
                {
                    "id": "#main/cwl_workflow_git_repo", 
                    "type": "string"
                }, 
                {
                    "id": "#main/cwl_workflow_rel_path", 
                    "type": "string"
                }, 
                {
                    "id": "#main/cwl_task_git_branch", 
                    "type": "string"
                }, 
                {
                    "id": "#main/cwl_task_git_repo", 
                    "type": "string"
                }, 
                {
                    "id": "#main/cwl_task_rel_path", 
                    "type": "string"
                }, 
                {
                    "id": "#main/db_cred", 
                    "type": "File"
                }, 
                {
                    "id": "#main/db_cred_section", 
                    "type": "string"
                }, 
                {
                    "id": "#main/gdc_token", 
                    "type": "File"
                }, 
                {
                    "id": "#main/input_bam_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#main/input_bam_file_size", 
                    "type": "long"
                }, 
                {
                    "id": "#main/input_bam_md5sum", 
                    "type": "string"
                }, 
                {
                    "id": "#main/known_snp_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#main/known_snp_index_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#main/reference_amb_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#main/reference_ann_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#main/reference_bwt_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#main/reference_dict_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#main/reference_fa_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#main/reference_fai_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#main/reference_pac_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#main/reference_sa_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#main/slurm_resource_cores", 
                    "type": "long"
                }, 
                {
                    "id": "#main/slurm_resource_disk_gigabytes", 
                    "type": "long"
                }, 
                {
                    "id": "#main/slurm_resource_mem_megabytes", 
                    "type": "long"
                }, 
                {
                    "id": "#main/status_table", 
                    "type": "string"
                }, 
                {
                    "id": "#main/task_uuid", 
                    "type": "string"
                }, 
                {
                    "id": "#main/thread_count", 
                    "type": "long"
                }, 
                {
                    "id": "#main/aws_config", 
                    "type": "File"
                }, 
                {
                    "id": "#main/aws_shared_credentials", 
                    "type": "File"
                }, 
                {
                    "id": "#main/endpoint_json", 
                    "type": "File"
                }, 
                {
                    "id": "#main/load_bucket", 
                    "type": "string"
                }, 
                {
                    "id": "#main/s3cfg_section", 
                    "type": "string"
                }
            ], 
            "outputs": [], 
            "steps": [
                {
                    "id": "#main/get_hostname", 
                    "run": "#emit_hostname.cwl", 
                    "in": [], 
                    "out": [
                        {
                            "id": "#main/get_hostname/output"
                        }
                    ]
                }, 
                {
                    "id": "#main/get_host_ipaddress", 
                    "run": "#emit_host_ipaddress.cwl", 
                    "in": [], 
                    "out": [
                        {
                            "id": "#main/get_host_ipaddress/output"
                        }
                    ]
                }, 
                {
                    "id": "#main/get_host_macaddress", 
                    "run": "#emit_host_mac.cwl", 
                    "in": [], 
                    "out": [
                        {
                            "id": "#main/get_host_macaddress/output"
                        }
                    ]
                }, 
                {
                    "id": "#main/get_cwl_task_repo_hash", 
                    "run": "#emit_git_hash.cwl", 
                    "in": [
                        {
                            "id": "#main/get_cwl_task_repo_hash/repo", 
                            "source": "#main/cwl_task_git_repo"
                        }, 
                        {
                            "id": "#main/get_cwl_task_repo_hash/branch", 
                            "source": "#main/cwl_task_git_branch"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#main/get_cwl_task_repo_hash/output"
                        }
                    ]
                }, 
                {
                    "id": "#main/status_running", 
                    "run": "#status_postgres.cwl", 
                    "in": [
                        {
                            "id": "#main/status_running/cwl_workflow_git_hash", 
                            "source": "#main/cwl_workflow_git_hash"
                        }, 
                        {
                            "id": "#main/status_running/cwl_workflow_git_repo", 
                            "source": "#main/cwl_workflow_git_repo"
                        }, 
                        {
                            "id": "#main/status_running/cwl_workflow_rel_path", 
                            "source": "#main/cwl_workflow_rel_path"
                        }, 
                        {
                            "id": "#main/status_running/cwl_task_git_branch", 
                            "source": "#main/cwl_task_git_branch"
                        }, 
                        {
                            "id": "#main/status_running/cwl_task_git_hash", 
                            "source": "#main/get_cwl_task_repo_hash/output"
                        }, 
                        {
                            "id": "#main/status_running/cwl_task_git_repo", 
                            "source": "#main/cwl_task_git_repo"
                        }, 
                        {
                            "id": "#main/status_running/cwl_task_rel_path", 
                            "source": "#main/cwl_task_rel_path"
                        }, 
                        {
                            "id": "#main/status_running/db_cred", 
                            "source": "#main/db_cred"
                        }, 
                        {
                            "id": "#main/status_running/db_cred_section", 
                            "source": "#main/db_cred_section"
                        }, 
                        {
                            "id": "#main/status_running/hostname", 
                            "source": "#main/get_hostname/output"
                        }, 
                        {
                            "id": "#main/status_running/host_ipaddress", 
                            "source": "#main/get_host_ipaddress/output"
                        }, 
                        {
                            "id": "#main/status_running/host_macaddress", 
                            "source": "#main/get_host_macaddress/output"
                        }, 
                        {
                            "id": "#main/status_running/input_bam_gdc_id", 
                            "source": "#main/input_bam_gdc_id"
                        }, 
                        {
                            "id": "#main/status_running/input_bam_file_size", 
                            "source": "#main/input_bam_file_size"
                        }, 
                        {
                            "id": "#main/status_running/input_bam_md5sum", 
                            "source": "#main/input_bam_md5sum"
                        }, 
                        {
                            "id": "#main/status_running/known_snp_gdc_id", 
                            "source": "#main/known_snp_gdc_id"
                        }, 
                        {
                            "id": "#main/status_running/known_snp_index_gdc_id", 
                            "source": "#main/known_snp_index_gdc_id"
                        }, 
                        {
                            "id": "#main/status_running/reference_amb_gdc_id", 
                            "source": "#main/reference_amb_gdc_id"
                        }, 
                        {
                            "id": "#main/status_running/reference_ann_gdc_id", 
                            "source": "#main/reference_ann_gdc_id"
                        }, 
                        {
                            "id": "#main/status_running/reference_bwt_gdc_id", 
                            "source": "#main/reference_bwt_gdc_id"
                        }, 
                        {
                            "id": "#main/status_running/reference_dict_gdc_id", 
                            "source": "#main/reference_dict_gdc_id"
                        }, 
                        {
                            "id": "#main/status_running/reference_fa_gdc_id", 
                            "source": "#main/reference_fa_gdc_id"
                        }, 
                        {
                            "id": "#main/status_running/reference_fai_gdc_id", 
                            "source": "#main/reference_fai_gdc_id"
                        }, 
                        {
                            "id": "#main/status_running/reference_pac_gdc_id", 
                            "source": "#main/reference_pac_gdc_id"
                        }, 
                        {
                            "id": "#main/status_running/reference_sa_gdc_id", 
                            "source": "#main/reference_sa_gdc_id"
                        }, 
                        {
                            "id": "#main/status_running/s3_bam_url", 
                            "valueFrom": "NULL"
                        }, 
                        {
                            "id": "#main/status_running/s3_bai_url", 
                            "valueFrom": "NULL"
                        }, 
                        {
                            "id": "#main/status_running/s3_mirna_profiling_tar_url", 
                            "valueFrom": "NULL"
                        }, 
                        {
                            "id": "#main/status_running/s3_mirna_profiling_isoforms_quant_url", 
                            "valueFrom": "NULL"
                        }, 
                        {
                            "id": "#main/status_running/s3_mirna_profiling_mirnas_quant_url", 
                            "valueFrom": "NULL"
                        }, 
                        {
                            "id": "#main/status_running/s3_sqlite_url", 
                            "valueFrom": "NULL"
                        }, 
                        {
                            "id": "#main/status_running/slurm_resource_cores", 
                            "source": "#main/slurm_resource_cores"
                        }, 
                        {
                            "id": "#main/status_running/slurm_resource_disk_gigabytes", 
                            "source": "#main/slurm_resource_disk_gigabytes"
                        }, 
                        {
                            "id": "#main/status_running/slurm_resource_mem_megabytes", 
                            "source": "#main/slurm_resource_mem_megabytes"
                        }, 
                        {
                            "id": "#main/status_running/status", 
                            "valueFrom": "RUNNING"
                        }, 
                        {
                            "id": "#main/status_running/step_token", 
                            "source": "#main/gdc_token"
                        }, 
                        {
                            "id": "#main/status_running/table_name", 
                            "source": "#main/status_table"
                        }, 
                        {
                            "id": "#main/status_running/task_uuid", 
                            "source": "#main/task_uuid"
                        }, 
                        {
                            "id": "#main/status_running/thread_count", 
                            "source": "#main/thread_count"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#main/status_running/token"
                        }
                    ]
                }, 
                {
                    "id": "#main/etl", 
                    "run": "#etl.cwl", 
                    "in": [
                        {
                            "id": "#main/etl/gdc_token", 
                            "source": "#main/gdc_token"
                        }, 
                        {
                            "id": "#main/etl/input_bam_gdc_id", 
                            "source": "#main/input_bam_gdc_id"
                        }, 
                        {
                            "id": "#main/etl/known_snp_gdc_id", 
                            "source": "#main/known_snp_gdc_id"
                        }, 
                        {
                            "id": "#main/etl/known_snp_index_gdc_id", 
                            "source": "#main/known_snp_index_gdc_id"
                        }, 
                        {
                            "id": "#main/etl/reference_amb_gdc_id", 
                            "source": "#main/reference_amb_gdc_id"
                        }, 
                        {
                            "id": "#main/etl/reference_ann_gdc_id", 
                            "source": "#main/reference_ann_gdc_id"
                        }, 
                        {
                            "id": "#main/etl/reference_bwt_gdc_id", 
                            "source": "#main/reference_bwt_gdc_id"
                        }, 
                        {
                            "id": "#main/etl/reference_dict_gdc_id", 
                            "source": "#main/reference_dict_gdc_id"
                        }, 
                        {
                            "id": "#main/etl/reference_fa_gdc_id", 
                            "source": "#main/reference_fa_gdc_id"
                        }, 
                        {
                            "id": "#main/etl/reference_fai_gdc_id", 
                            "source": "#main/reference_fai_gdc_id"
                        }, 
                        {
                            "id": "#main/etl/reference_pac_gdc_id", 
                            "source": "#main/reference_pac_gdc_id"
                        }, 
                        {
                            "id": "#main/etl/reference_sa_gdc_id", 
                            "source": "#main/reference_sa_gdc_id"
                        }, 
                        {
                            "id": "#main/etl/start_token", 
                            "source": "#main/status_running/token"
                        }, 
                        {
                            "id": "#main/etl/thread_count", 
                            "source": "#main/thread_count"
                        }, 
                        {
                            "id": "#main/etl/task_uuid", 
                            "source": "#main/task_uuid"
                        }, 
                        {
                            "id": "#main/etl/aws_config", 
                            "source": "#main/aws_config"
                        }, 
                        {
                            "id": "#main/etl/aws_shared_credentials", 
                            "source": "#main/aws_shared_credentials"
                        }, 
                        {
                            "id": "#main/etl/endpoint_json", 
                            "source": "#main/endpoint_json"
                        }, 
                        {
                            "id": "#main/etl/load_bucket", 
                            "source": "#main/load_bucket"
                        }, 
                        {
                            "id": "#main/etl/s3cfg_section", 
                            "source": "#main/s3cfg_section"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#main/etl/s3_bam_url"
                        }, 
                        {
                            "id": "#main/etl/s3_bai_url"
                        }, 
                        {
                            "id": "#main/etl/s3_mirna_profiling_tar_url"
                        }, 
                        {
                            "id": "#main/etl/s3_mirna_profiling_isoforms_quant_url"
                        }, 
                        {
                            "id": "#main/etl/s3_mirna_profiling_mirnas_quant_url"
                        }, 
                        {
                            "id": "#main/etl/s3_sqlite_url"
                        }, 
                        {
                            "id": "#main/etl/token"
                        }
                    ]
                }, 
                {
                    "id": "#main/status_complete", 
                    "run": "#status_postgres.cwl", 
                    "in": [
                        {
                            "id": "#main/status_complete/cwl_workflow_git_hash", 
                            "source": "#main/cwl_workflow_git_hash"
                        }, 
                        {
                            "id": "#main/status_complete/cwl_workflow_git_repo", 
                            "source": "#main/cwl_workflow_git_repo"
                        }, 
                        {
                            "id": "#main/status_complete/cwl_workflow_rel_path", 
                            "source": "#main/cwl_workflow_rel_path"
                        }, 
                        {
                            "id": "#main/status_complete/cwl_task_git_branch", 
                            "source": "#main/cwl_task_git_branch"
                        }, 
                        {
                            "id": "#main/status_complete/cwl_task_git_hash", 
                            "source": "#main/get_cwl_task_repo_hash/output"
                        }, 
                        {
                            "id": "#main/status_complete/cwl_task_git_repo", 
                            "source": "#main/cwl_task_git_repo"
                        }, 
                        {
                            "id": "#main/status_complete/cwl_task_rel_path", 
                            "source": "#main/cwl_task_rel_path"
                        }, 
                        {
                            "id": "#main/status_complete/db_cred", 
                            "source": "#main/db_cred"
                        }, 
                        {
                            "id": "#main/status_complete/db_cred_section", 
                            "source": "#main/db_cred_section"
                        }, 
                        {
                            "id": "#main/status_complete/hostname", 
                            "source": "#main/get_hostname/output"
                        }, 
                        {
                            "id": "#main/status_complete/host_ipaddress", 
                            "source": "#main/get_host_ipaddress/output"
                        }, 
                        {
                            "id": "#main/status_complete/host_macaddress", 
                            "source": "#main/get_host_macaddress/output"
                        }, 
                        {
                            "id": "#main/status_complete/input_bam_gdc_id", 
                            "source": "#main/input_bam_gdc_id"
                        }, 
                        {
                            "id": "#main/status_complete/input_bam_file_size", 
                            "source": "#main/input_bam_file_size"
                        }, 
                        {
                            "id": "#main/status_complete/input_bam_md5sum", 
                            "source": "#main/input_bam_md5sum"
                        }, 
                        {
                            "id": "#main/status_complete/known_snp_gdc_id", 
                            "source": "#main/known_snp_gdc_id"
                        }, 
                        {
                            "id": "#main/status_complete/known_snp_index_gdc_id", 
                            "source": "#main/known_snp_index_gdc_id"
                        }, 
                        {
                            "id": "#main/status_complete/reference_amb_gdc_id", 
                            "source": "#main/reference_amb_gdc_id"
                        }, 
                        {
                            "id": "#main/status_complete/reference_ann_gdc_id", 
                            "source": "#main/reference_ann_gdc_id"
                        }, 
                        {
                            "id": "#main/status_complete/reference_bwt_gdc_id", 
                            "source": "#main/reference_bwt_gdc_id"
                        }, 
                        {
                            "id": "#main/status_complete/reference_dict_gdc_id", 
                            "source": "#main/reference_dict_gdc_id"
                        }, 
                        {
                            "id": "#main/status_complete/reference_fa_gdc_id", 
                            "source": "#main/reference_fa_gdc_id"
                        }, 
                        {
                            "id": "#main/status_complete/reference_fai_gdc_id", 
                            "source": "#main/reference_fai_gdc_id"
                        }, 
                        {
                            "id": "#main/status_complete/reference_pac_gdc_id", 
                            "source": "#main/reference_pac_gdc_id"
                        }, 
                        {
                            "id": "#main/status_complete/reference_sa_gdc_id", 
                            "source": "#main/reference_sa_gdc_id"
                        }, 
                        {
                            "id": "#main/status_complete/s3_bam_url", 
                            "source": "#main/etl/s3_bam_url"
                        }, 
                        {
                            "id": "#main/status_complete/s3_bai_url", 
                            "source": "#main/etl/s3_bai_url"
                        }, 
                        {
                            "id": "#main/status_complete/s3_mirna_profiling_tar_url", 
                            "source": "#main/etl/s3_mirna_profiling_tar_url"
                        }, 
                        {
                            "id": "#main/status_complete/s3_mirna_profiling_isoforms_quant_url", 
                            "source": "#main/etl/s3_mirna_profiling_isoforms_quant_url"
                        }, 
                        {
                            "id": "#main/status_complete/s3_mirna_profiling_mirnas_quant_url", 
                            "source": "#main/etl/s3_mirna_profiling_mirnas_quant_url"
                        }, 
                        {
                            "id": "#main/status_complete/s3_sqlite_url", 
                            "source": "#main/etl/s3_sqlite_url"
                        }, 
                        {
                            "id": "#main/status_complete/slurm_resource_cores", 
                            "source": "#main/slurm_resource_cores"
                        }, 
                        {
                            "id": "#main/status_complete/slurm_resource_disk_gigabytes", 
                            "source": "#main/slurm_resource_disk_gigabytes"
                        }, 
                        {
                            "id": "#main/status_complete/slurm_resource_mem_megabytes", 
                            "source": "#main/slurm_resource_mem_megabytes"
                        }, 
                        {
                            "id": "#main/status_complete/status", 
                            "valueFrom": "COMPLETE"
                        }, 
                        {
                            "id": "#main/status_complete/step_token", 
                            "source": "#main/etl/token"
                        }, 
                        {
                            "id": "#main/status_complete/table_name", 
                            "source": "#main/status_table"
                        }, 
                        {
                            "id": "#main/status_complete/task_uuid", 
                            "source": "#main/task_uuid"
                        }, 
                        {
                            "id": "#main/status_complete/thread_count", 
                            "source": "#main/thread_count"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#main/status_complete/token"
                        }
                    ]
                }
            ], 
            "id": "#main"
        }, 
        {
            "class": "Workflow", 
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                }, 
                {
                    "class": "MultipleInputFeatureRequirement"
                }, 
                {
                    "class": "StepInputExpressionRequirement"
                }
            ], 
            "inputs": [
                {
                    "id": "#status_postgres.cwl/cwl_workflow_git_hash", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/cwl_workflow_git_repo", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/cwl_workflow_rel_path", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/cwl_task_git_branch", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/cwl_task_git_hash", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/cwl_task_git_repo", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/cwl_task_rel_path", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/db_cred", 
                    "type": "File"
                }, 
                {
                    "id": "#status_postgres.cwl/db_cred_section", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/hostname", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/host_ipaddress", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/host_macaddress", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/input_bam_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/input_bam_file_size", 
                    "type": "long"
                }, 
                {
                    "id": "#status_postgres.cwl/input_bam_md5sum", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/known_snp_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/known_snp_index_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/reference_amb_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/reference_ann_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/reference_bwt_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/reference_dict_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/reference_fa_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/reference_fai_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/reference_pac_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/reference_sa_gdc_id", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/s3_bam_url", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/s3_bai_url", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/s3_mirna_profiling_tar_url", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/s3_mirna_profiling_isoforms_quant_url", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/s3_mirna_profiling_mirnas_quant_url", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/s3_sqlite_url", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/slurm_resource_cores", 
                    "type": "long"
                }, 
                {
                    "id": "#status_postgres.cwl/slurm_resource_disk_gigabytes", 
                    "type": "long"
                }, 
                {
                    "id": "#status_postgres.cwl/slurm_resource_mem_megabytes", 
                    "type": "long"
                }, 
                {
                    "id": "#status_postgres.cwl/status", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/step_token", 
                    "type": "File"
                }, 
                {
                    "id": "#status_postgres.cwl/table_name", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/task_uuid", 
                    "type": "string"
                }, 
                {
                    "id": "#status_postgres.cwl/thread_count", 
                    "type": "long"
                }
            ], 
            "outputs": [
                {
                    "id": "#status_postgres.cwl/token", 
                    "type": "File", 
                    "outputSource": "#status_postgres.cwl/sqlite_to_postgres/log"
                }
            ], 
            "steps": [
                {
                    "id": "#status_postgres.cwl/emit_json", 
                    "run": "#emit_json.cwl", 
                    "in": [
                        {
                            "id": "#status_postgres.cwl/emit_json/string_keys", 
                            "default": [
                                "cwl_workflow_git_hash", 
                                "cwl_workflow_git_repo", 
                                "cwl_workflow_rel_path", 
                                "cwl_task_git_branch", 
                                "cwl_task_git_hash", 
                                "cwl_task_git_repo", 
                                "cwl_task_rel_path", 
                                "hostname", 
                                "host_ipaddress", 
                                "host_macaddress", 
                                "input_bam_gdc_id", 
                                "input_bam_md5sum", 
                                "known_snp_gdc_id", 
                                "known_snp_index_gdc_id", 
                                "reference_amb_gdc_id", 
                                "reference_ann_gdc_id", 
                                "reference_bwt_gdc_id", 
                                "reference_dict_gdc_id", 
                                "reference_fa_gdc_id", 
                                "reference_fai_gdc_id", 
                                "reference_pac_gdc_id", 
                                "reference_sa_gdc_id", 
                                "s3_bam_url", 
                                "s3_bai_url", 
                                "s3_mirna_profiling_tar_url", 
                                "s3_mirna_profiling_isoforms_quant_url", 
                                "s3_mirna_profiling_mirnas_quant_url", 
                                "s3_sqlite_url", 
                                "status", 
                                "task_uuid"
                            ]
                        }, 
                        {
                            "id": "#status_postgres.cwl/emit_json/string_values", 
                            "source": [
                                "#status_postgres.cwl/cwl_workflow_git_hash", 
                                "#status_postgres.cwl/cwl_workflow_git_repo", 
                                "#status_postgres.cwl/cwl_workflow_rel_path", 
                                "#status_postgres.cwl/cwl_task_git_branch", 
                                "#status_postgres.cwl/cwl_task_git_hash", 
                                "#status_postgres.cwl/cwl_task_git_repo", 
                                "#status_postgres.cwl/cwl_task_rel_path", 
                                "#status_postgres.cwl/hostname", 
                                "#status_postgres.cwl/host_ipaddress", 
                                "#status_postgres.cwl/host_macaddress", 
                                "#status_postgres.cwl/input_bam_gdc_id", 
                                "#status_postgres.cwl/input_bam_md5sum", 
                                "#status_postgres.cwl/known_snp_gdc_id", 
                                "#status_postgres.cwl/known_snp_index_gdc_id", 
                                "#status_postgres.cwl/reference_amb_gdc_id", 
                                "#status_postgres.cwl/reference_ann_gdc_id", 
                                "#status_postgres.cwl/reference_bwt_gdc_id", 
                                "#status_postgres.cwl/reference_dict_gdc_id", 
                                "#status_postgres.cwl/reference_fa_gdc_id", 
                                "#status_postgres.cwl/reference_fai_gdc_id", 
                                "#status_postgres.cwl/reference_pac_gdc_id", 
                                "#status_postgres.cwl/reference_sa_gdc_id", 
                                "#status_postgres.cwl/s3_bam_url", 
                                "#status_postgres.cwl/s3_bai_url", 
                                "#status_postgres.cwl/s3_mirna_profiling_tar_url", 
                                "#status_postgres.cwl/s3_mirna_profiling_isoforms_quant_url", 
                                "#status_postgres.cwl/s3_mirna_profiling_mirnas_quant_url", 
                                "#status_postgres.cwl/s3_sqlite_url", 
                                "#status_postgres.cwl/status", 
                                "#status_postgres.cwl/task_uuid"
                            ]
                        }, 
                        {
                            "id": "#status_postgres.cwl/emit_json/long_keys", 
                            "default": [
                                "input_bam_file_size", 
                                "slurm_resource_cores", 
                                "slurm_resource_disk_gigabytes", 
                                "slurm_resource_mem_megabytes", 
                                "thread_count"
                            ]
                        }, 
                        {
                            "id": "#status_postgres.cwl/emit_json/long_values", 
                            "source": [
                                "#status_postgres.cwl/input_bam_file_size", 
                                "#status_postgres.cwl/slurm_resource_cores", 
                                "#status_postgres.cwl/slurm_resource_disk_gigabytes", 
                                "#status_postgres.cwl/slurm_resource_mem_megabytes", 
                                "#status_postgres.cwl/thread_count"
                            ]
                        }, 
                        {
                            "id": "#status_postgres.cwl/emit_json/float_keys", 
                            "default": []
                        }, 
                        {
                            "id": "#status_postgres.cwl/emit_json/float_values", 
                            "default": []
                        }
                    ], 
                    "out": [
                        {
                            "id": "#status_postgres.cwl/emit_json/output"
                        }
                    ]
                }, 
                {
                    "id": "#status_postgres.cwl/json_to_sqlite", 
                    "run": "#json_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#status_postgres.cwl/json_to_sqlite/input_json", 
                            "source": "#status_postgres.cwl/emit_json/output"
                        }, 
                        {
                            "id": "#status_postgres.cwl/json_to_sqlite/task_uuid", 
                            "source": "#status_postgres.cwl/task_uuid"
                        }, 
                        {
                            "id": "#status_postgres.cwl/json_to_sqlite/table_name", 
                            "source": "#status_postgres.cwl/table_name"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#status_postgres.cwl/json_to_sqlite/sqlite"
                        }, 
                        {
                            "id": "#status_postgres.cwl/json_to_sqlite/log"
                        }
                    ]
                }, 
                {
                    "id": "#status_postgres.cwl/sqlite_to_postgres", 
                    "run": "#sqlite_to_postgres_hirate.cwl", 
                    "in": [
                        {
                            "id": "#status_postgres.cwl/sqlite_to_postgres/postgres_creds_path", 
                            "source": "#status_postgres.cwl/db_cred"
                        }, 
                        {
                            "id": "#status_postgres.cwl/sqlite_to_postgres/ini_section", 
                            "source": "#status_postgres.cwl/db_cred_section"
                        }, 
                        {
                            "id": "#status_postgres.cwl/sqlite_to_postgres/source_sqlite_path", 
                            "source": "#status_postgres.cwl/json_to_sqlite/sqlite"
                        }, 
                        {
                            "id": "#status_postgres.cwl/sqlite_to_postgres/task_uuid", 
                            "source": "#status_postgres.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#status_postgres.cwl/sqlite_to_postgres/log"
                        }
                    ]
                }
            ], 
            "id": "#status_postgres.cwl"
        }, 
        {
            "class": "Workflow", 
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                }, 
                {
                    "class": "MultipleInputFeatureRequirement"
                }, 
                {
                    "class": "ScatterFeatureRequirement"
                }, 
                {
                    "class": "StepInputExpressionRequirement"
                }, 
                {
                    "class": "SubworkflowFeatureRequirement"
                }
            ], 
            "inputs": [
                {
                    "id": "#transform_mirna.cwl/input_bam", 
                    "type": "File"
                }, 
                {
                    "id": "#transform_mirna.cwl/known_snp", 
                    "type": "File"
                }, 
                {
                    "id": "#transform_mirna.cwl/reference_sequence", 
                    "type": "File"
                }, 
                {
                    "id": "#transform_mirna.cwl/thread_count", 
                    "type": "long"
                }, 
                {
                    "id": "#transform_mirna.cwl/task_uuid", 
                    "type": "string"
                }
            ], 
            "outputs": [
                {
                    "id": "#transform_mirna.cwl/picard_markduplicates_output", 
                    "type": "File", 
                    "outputSource": "#transform_mirna.cwl/picard_markduplicates/OUTPUT"
                }, 
                {
                    "id": "#transform_mirna.cwl/merge_all_sqlite_destination_sqlite", 
                    "type": "File", 
                    "outputSource": "#transform_mirna.cwl/merge_all_sqlite/destination_sqlite"
                }, 
                {
                    "id": "#transform_mirna.cwl/mirna_profiling_mirna_adapter_report_sorted_output", 
                    "type": "File", 
                    "outputSource": "#transform_mirna.cwl/mirna_profiling/mirna_adapter_report_sorted_output"
                }, 
                {
                    "id": "#transform_mirna.cwl/mirna_profiling_mirna_alignment_stats_features", 
                    "type": "Directory", 
                    "outputSource": "#transform_mirna.cwl/mirna_profiling/mirna_alignment_stats_features"
                }, 
                {
                    "id": "#transform_mirna.cwl/mirna_profiling_mirna_expression_matrix_expn_matrix_txt", 
                    "type": "File", 
                    "outputSource": "#transform_mirna.cwl/mirna_profiling/mirna_expression_matrix_expn_matrix_txt"
                }, 
                {
                    "id": "#transform_mirna.cwl/mirna_profiling_mirna_expression_matrix_expn_matrix_norm_txt", 
                    "type": "File", 
                    "outputSource": "#transform_mirna.cwl/mirna_profiling/mirna_expression_matrix_expn_matrix_norm_txt"
                }, 
                {
                    "id": "#transform_mirna.cwl/mirna_profiling_mirna_expression_matrix_expn_matrix_norm_log_txt", 
                    "type": "File", 
                    "outputSource": "#transform_mirna.cwl/mirna_profiling/mirna_expression_matrix_expn_matrix_norm_log_txt"
                }, 
                {
                    "id": "#transform_mirna.cwl/mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_txt", 
                    "type": "File", 
                    "outputSource": "#transform_mirna.cwl/mirna_profiling/mirna_expression_matrix_mimat_expn_matrix_mimat_txt"
                }, 
                {
                    "id": "#transform_mirna.cwl/mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_norm_txt", 
                    "type": "File", 
                    "outputSource": "#transform_mirna.cwl/mirna_profiling/mirna_expression_matrix_mimat_expn_matrix_mimat_norm_txt"
                }, 
                {
                    "id": "#transform_mirna.cwl/mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_norm_log_txt", 
                    "type": "File", 
                    "outputSource": "#transform_mirna.cwl/mirna_profiling/mirna_expression_matrix_mimat_expn_matrix_mimat_norm_log_txt"
                }, 
                {
                    "id": "#transform_mirna.cwl/mirna_profiling_mirna_graph_libs_jpgs", 
                    "type": "Directory", 
                    "outputSource": "#transform_mirna.cwl/mirna_profiling/mirna_graph_libs_jpgs"
                }, 
                {
                    "id": "#transform_mirna.cwl/mirna_profiling_mirna_tcga_isoforms_quant", 
                    "type": "File", 
                    "outputSource": "#transform_mirna.cwl/mirna_profiling/mirna_tcga_isoforms_quant"
                }, 
                {
                    "id": "#transform_mirna.cwl/mirna_profiling_mirna_tcga_mirnas_quant", 
                    "type": "File", 
                    "outputSource": "#transform_mirna.cwl/mirna_profiling/mirna_tcga_mirnas_quant"
                }
            ], 
            "steps": [
                {
                    "id": "#transform_mirna.cwl/samtools_bamtobam", 
                    "run": "#samtools_bamtobam.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/samtools_bamtobam/INPUT", 
                            "source": "#transform_mirna.cwl/input_bam"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/samtools_bamtobam/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_validatesamfile_original", 
                    "run": "#picard_validatesamfile.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_original/INPUT", 
                            "source": "#transform_mirna.cwl/samtools_bamtobam/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_original/VALIDATION_STRINGENCY", 
                            "valueFrom": "LENIENT"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_original/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_validatesamfile_original_to_sqlite", 
                    "run": "#picard_validatesamfile_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_original_to_sqlite/bam", 
                            "source": "#transform_mirna.cwl/input_bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_original_to_sqlite/input_state", 
                            "valueFrom": "original"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_original_to_sqlite/metric_path", 
                            "source": "#transform_mirna.cwl/picard_validatesamfile_original/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_original_to_sqlite/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_original_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/biobambam_bamtofastq", 
                    "run": "#biobambam2_bamtofastq.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/biobambam_bamtofastq/filename", 
                            "source": "#transform_mirna.cwl/samtools_bamtobam/OUTPUT"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/biobambam_bamtofastq/output_fastq1"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/biobambam_bamtofastq/output_fastq2"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/biobambam_bamtofastq/output_fastq_o1"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/biobambam_bamtofastq/output_fastq_o2"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/biobambam_bamtofastq/output_fastq_s"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/remove_duplicate_fastq1", 
                    "run": "#fastq_remove_duplicate_qname.cwl", 
                    "scatter": "#transform_mirna.cwl/remove_duplicate_fastq1/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/remove_duplicate_fastq1/INPUT", 
                            "source": "#transform_mirna.cwl/biobambam_bamtofastq/output_fastq1"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/remove_duplicate_fastq1/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/remove_duplicate_fastq2", 
                    "run": "#fastq_remove_duplicate_qname.cwl", 
                    "scatter": "#transform_mirna.cwl/remove_duplicate_fastq2/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/remove_duplicate_fastq2/INPUT", 
                            "source": "#transform_mirna.cwl/biobambam_bamtofastq/output_fastq2"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/remove_duplicate_fastq2/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/remove_duplicate_fastq_o1", 
                    "run": "#fastq_remove_duplicate_qname.cwl", 
                    "scatter": "#transform_mirna.cwl/remove_duplicate_fastq_o1/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/remove_duplicate_fastq_o1/INPUT", 
                            "source": "#transform_mirna.cwl/biobambam_bamtofastq/output_fastq_o1"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/remove_duplicate_fastq_o1/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/remove_duplicate_fastq_o2", 
                    "run": "#fastq_remove_duplicate_qname.cwl", 
                    "scatter": "#transform_mirna.cwl/remove_duplicate_fastq_o2/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/remove_duplicate_fastq_o2/INPUT", 
                            "source": "#transform_mirna.cwl/biobambam_bamtofastq/output_fastq_o2"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/remove_duplicate_fastq_o2/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/remove_duplicate_fastq_s", 
                    "run": "#fastq_remove_duplicate_qname.cwl", 
                    "scatter": "#transform_mirna.cwl/remove_duplicate_fastq_s/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/remove_duplicate_fastq_s/INPUT", 
                            "source": "#transform_mirna.cwl/biobambam_bamtofastq/output_fastq_s"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/remove_duplicate_fastq_s/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/sort_scattered_fastq1", 
                    "run": "#sort_scatter_expression.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/sort_scattered_fastq1/INPUT", 
                            "source": "#transform_mirna.cwl/remove_duplicate_fastq1/OUTPUT"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/sort_scattered_fastq1/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/sort_scattered_fastq2", 
                    "run": "#sort_scatter_expression.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/sort_scattered_fastq2/INPUT", 
                            "source": "#transform_mirna.cwl/remove_duplicate_fastq2/OUTPUT"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/sort_scattered_fastq2/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/sort_scattered_fastq_o1", 
                    "run": "#sort_scatter_expression.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/sort_scattered_fastq_o1/INPUT", 
                            "source": "#transform_mirna.cwl/remove_duplicate_fastq_o1/OUTPUT"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/sort_scattered_fastq_o1/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/sort_scattered_fastq_o2", 
                    "run": "#sort_scatter_expression.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/sort_scattered_fastq_o2/INPUT", 
                            "source": "#transform_mirna.cwl/remove_duplicate_fastq_o2/OUTPUT"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/sort_scattered_fastq_o2/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/sort_scattered_fastq_s", 
                    "run": "#sort_scatter_expression.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/sort_scattered_fastq_s/INPUT", 
                            "source": "#transform_mirna.cwl/remove_duplicate_fastq_s/OUTPUT"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/sort_scattered_fastq_s/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/bam_readgroup_to_json", 
                    "run": "#bam_readgroup_to_json.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/bam_readgroup_to_json/INPUT", 
                            "source": "#transform_mirna.cwl/samtools_bamtobam/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bam_readgroup_to_json/MODE", 
                            "valueFrom": "lenient"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/bam_readgroup_to_json/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/readgroup_json_db", 
                    "run": "#readgroup_json_db.cwl", 
                    "scatter": "#transform_mirna.cwl/readgroup_json_db/json_path", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/readgroup_json_db/json_path", 
                            "source": "#transform_mirna.cwl/bam_readgroup_to_json/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/readgroup_json_db/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/readgroup_json_db/log"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/readgroup_json_db/output_sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/merge_readgroup_json_db", 
                    "run": "#merge_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/merge_readgroup_json_db/source_sqlite", 
                            "source": "#transform_mirna.cwl/readgroup_json_db/output_sqlite"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_readgroup_json_db/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/merge_readgroup_json_db/destination_sqlite"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_readgroup_json_db/log"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/fastqc1", 
                    "run": "#fastqc.cwl", 
                    "scatter": "#transform_mirna.cwl/fastqc1/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/fastqc1/INPUT", 
                            "source": "#transform_mirna.cwl/sort_scattered_fastq1/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc1/threads", 
                            "source": "#transform_mirna.cwl/thread_count"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/fastqc1/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/fastqc2", 
                    "run": "#fastqc.cwl", 
                    "scatter": "#transform_mirna.cwl/fastqc2/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/fastqc2/INPUT", 
                            "source": "#transform_mirna.cwl/sort_scattered_fastq2/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc2/threads", 
                            "source": "#transform_mirna.cwl/thread_count"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/fastqc2/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/fastqc_s", 
                    "run": "#fastqc.cwl", 
                    "scatter": "#transform_mirna.cwl/fastqc_s/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_s/INPUT", 
                            "source": "#transform_mirna.cwl/sort_scattered_fastq_s/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc_s/threads", 
                            "source": "#transform_mirna.cwl/thread_count"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_s/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/fastqc_o1", 
                    "run": "#fastqc.cwl", 
                    "scatter": "#transform_mirna.cwl/fastqc_o1/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_o1/INPUT", 
                            "source": "#transform_mirna.cwl/sort_scattered_fastq_o1/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc_o1/threads", 
                            "source": "#transform_mirna.cwl/thread_count"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_o1/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/fastqc_o2", 
                    "run": "#fastqc.cwl", 
                    "scatter": "#transform_mirna.cwl/fastqc_o2/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_o2/INPUT", 
                            "source": "#transform_mirna.cwl/sort_scattered_fastq_o2/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc_o2/threads", 
                            "source": "#transform_mirna.cwl/thread_count"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_o2/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/fastqc_db1", 
                    "run": "#fastqc_db.cwl", 
                    "scatter": "#transform_mirna.cwl/fastqc_db1/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_db1/INPUT", 
                            "source": "#transform_mirna.cwl/fastqc1/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc_db1/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_db1/LOG"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc_db1/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/fastqc_db2", 
                    "run": "#fastqc_db.cwl", 
                    "scatter": "#transform_mirna.cwl/fastqc_db2/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_db2/INPUT", 
                            "source": "#transform_mirna.cwl/fastqc2/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc_db2/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_db2/LOG"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc_db2/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/fastqc_db_s", 
                    "run": "#fastqc_db.cwl", 
                    "scatter": "#transform_mirna.cwl/fastqc_db_s/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_db_s/INPUT", 
                            "source": "#transform_mirna.cwl/fastqc_s/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc_db_s/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_db_s/LOG"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc_db_s/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/fastqc_db_o1", 
                    "run": "#fastqc_db.cwl", 
                    "scatter": "#transform_mirna.cwl/fastqc_db_o1/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_db_o1/INPUT", 
                            "source": "#transform_mirna.cwl/fastqc_o1/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc_db_o1/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_db_o1/LOG"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc_db_o1/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/fastqc_db_o2", 
                    "run": "#fastqc_db.cwl", 
                    "scatter": "#transform_mirna.cwl/fastqc_db_o2/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_db_o2/INPUT", 
                            "source": "#transform_mirna.cwl/fastqc_o2/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc_db_o2/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_db_o2/LOG"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/fastqc_db_o2/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/merge_fastqc_db1_sqlite", 
                    "run": "#merge_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db1_sqlite/source_sqlite", 
                            "source": "#transform_mirna.cwl/fastqc_db1/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db1_sqlite/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db1_sqlite/destination_sqlite"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db1_sqlite/log"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/merge_fastqc_db2_sqlite", 
                    "run": "#merge_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db2_sqlite/source_sqlite", 
                            "source": "#transform_mirna.cwl/fastqc_db2/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db2_sqlite/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db2_sqlite/destination_sqlite"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db2_sqlite/log"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/merge_fastqc_db_s_sqlite", 
                    "run": "#merge_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db_s_sqlite/source_sqlite", 
                            "source": "#transform_mirna.cwl/fastqc_db_s/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db_s_sqlite/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db_s_sqlite/destination_sqlite"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db_s_sqlite/log"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/merge_fastqc_db_o1_sqlite", 
                    "run": "#merge_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db_o1_sqlite/source_sqlite", 
                            "source": "#transform_mirna.cwl/fastqc_db_o1/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db_o1_sqlite/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db_o1_sqlite/destination_sqlite"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db_o1_sqlite/log"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/merge_fastqc_db_o2_sqlite", 
                    "run": "#merge_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db_o2_sqlite/source_sqlite", 
                            "source": "#transform_mirna.cwl/fastqc_db_o2/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db_o2_sqlite/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db_o2_sqlite/destination_sqlite"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_fastqc_db_o2_sqlite/log"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/fastqc_pe_basicstats_json", 
                    "run": "#fastqc_basicstatistics_json.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_pe_basicstats_json/sqlite_path", 
                            "source": "#transform_mirna.cwl/merge_fastqc_db1_sqlite/destination_sqlite"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_pe_basicstats_json/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/fastqc_se_basicstats_json", 
                    "run": "#fastqc_basicstatistics_json.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_se_basicstats_json/sqlite_path", 
                            "source": "#transform_mirna.cwl/merge_fastqc_db_s_sqlite/destination_sqlite"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_se_basicstats_json/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/fastqc_o1_basicstats_json", 
                    "run": "#fastqc_basicstatistics_json.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_o1_basicstats_json/sqlite_path", 
                            "source": "#transform_mirna.cwl/merge_fastqc_db_o1_sqlite/destination_sqlite"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_o1_basicstats_json/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/fastqc_o2_basicstats_json", 
                    "run": "#fastqc_basicstatistics_json.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_o2_basicstats_json/sqlite_path", 
                            "source": "#transform_mirna.cwl/merge_fastqc_db_o2_sqlite/destination_sqlite"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/fastqc_o2_basicstats_json/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/decider_bwa_pe", 
                    "run": "#decider_bwa_expression.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/decider_bwa_pe/fastq_path", 
                            "source": "#transform_mirna.cwl/sort_scattered_fastq1/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/decider_bwa_pe/readgroup_path", 
                            "source": "#transform_mirna.cwl/bam_readgroup_to_json/OUTPUT"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/decider_bwa_pe/output_readgroup_paths"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/decider_bwa_se", 
                    "run": "#decider_bwa_expression.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/decider_bwa_se/fastq_path", 
                            "source": "#transform_mirna.cwl/sort_scattered_fastq_s/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/decider_bwa_se/readgroup_path", 
                            "source": "#transform_mirna.cwl/bam_readgroup_to_json/OUTPUT"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/decider_bwa_se/output_readgroup_paths"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/decider_bwa_o1", 
                    "run": "#decider_bwa_expression.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/decider_bwa_o1/fastq_path", 
                            "source": "#transform_mirna.cwl/sort_scattered_fastq_o1/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/decider_bwa_o1/readgroup_path", 
                            "source": "#transform_mirna.cwl/bam_readgroup_to_json/OUTPUT"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/decider_bwa_o1/output_readgroup_paths"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/decider_bwa_o2", 
                    "run": "#decider_bwa_expression.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/decider_bwa_o2/fastq_path", 
                            "source": "#transform_mirna.cwl/sort_scattered_fastq_o2/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/decider_bwa_o2/readgroup_path", 
                            "source": "#transform_mirna.cwl/bam_readgroup_to_json/OUTPUT"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/decider_bwa_o2/output_readgroup_paths"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/bwa_pe", 
                    "run": "#bwa_pe.cwl", 
                    "scatter": [
                        "#transform_mirna.cwl/bwa_pe/fastq1", 
                        "#transform_mirna.cwl/bwa_pe/fastq2", 
                        "#transform_mirna.cwl/bwa_pe/readgroup_json_path"
                    ], 
                    "scatterMethod": "dotproduct", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/bwa_pe/fasta", 
                            "source": "#transform_mirna.cwl/reference_sequence"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_pe/fastq1", 
                            "source": "#transform_mirna.cwl/sort_scattered_fastq1/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_pe/fastq2", 
                            "source": "#transform_mirna.cwl/sort_scattered_fastq2/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_pe/readgroup_json_path", 
                            "source": "#transform_mirna.cwl/decider_bwa_pe/output_readgroup_paths"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_pe/fastqc_json_path", 
                            "source": "#transform_mirna.cwl/fastqc_pe_basicstats_json/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_pe/thread_count", 
                            "source": "#transform_mirna.cwl/thread_count"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/bwa_pe/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/bwa_se", 
                    "run": "#bwa_se.cwl", 
                    "scatter": [
                        "#transform_mirna.cwl/bwa_se/fastq", 
                        "#transform_mirna.cwl/bwa_se/readgroup_json_path"
                    ], 
                    "scatterMethod": "dotproduct", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/bwa_se/fasta", 
                            "source": "#transform_mirna.cwl/reference_sequence"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_se/fastq", 
                            "source": "#transform_mirna.cwl/sort_scattered_fastq_s/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_se/readgroup_json_path", 
                            "source": "#transform_mirna.cwl/decider_bwa_se/output_readgroup_paths"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_se/fastqc_json_path", 
                            "source": "#transform_mirna.cwl/fastqc_se_basicstats_json/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_se/samse_maxOcc", 
                            "valueFrom": "$(5+5)"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_se/thread_count", 
                            "source": "#transform_mirna.cwl/thread_count"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/bwa_se/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/bwa_o1", 
                    "run": "#bwa_se.cwl", 
                    "scatter": [
                        "#transform_mirna.cwl/bwa_o1/fastq", 
                        "#transform_mirna.cwl/bwa_o1/readgroup_json_path"
                    ], 
                    "scatterMethod": "dotproduct", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/bwa_o1/fasta", 
                            "source": "#transform_mirna.cwl/reference_sequence"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_o1/fastq", 
                            "source": "#transform_mirna.cwl/sort_scattered_fastq_o1/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_o1/readgroup_json_path", 
                            "source": "#transform_mirna.cwl/decider_bwa_o1/output_readgroup_paths"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_o1/fastqc_json_path", 
                            "source": "#transform_mirna.cwl/fastqc_o1_basicstats_json/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_o1/thread_count", 
                            "source": "#transform_mirna.cwl/thread_count"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/bwa_o1/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/bwa_o2", 
                    "run": "#bwa_se.cwl", 
                    "scatter": [
                        "#transform_mirna.cwl/bwa_o2/fastq", 
                        "#transform_mirna.cwl/bwa_o2/readgroup_json_path"
                    ], 
                    "scatterMethod": "dotproduct", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/bwa_o2/fasta", 
                            "source": "#transform_mirna.cwl/reference_sequence"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_o2/fastq", 
                            "source": "#transform_mirna.cwl/sort_scattered_fastq_o2/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_o2/readgroup_json_path", 
                            "source": "#transform_mirna.cwl/decider_bwa_o2/output_readgroup_paths"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_o2/fastqc_json_path", 
                            "source": "#transform_mirna.cwl/fastqc_o2_basicstats_json/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/bwa_o2/thread_count", 
                            "source": "#transform_mirna.cwl/thread_count"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/bwa_o2/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_sortsam_pe", 
                    "run": "#picard_sortsam.cwl", 
                    "scatter": "#transform_mirna.cwl/picard_sortsam_pe/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_sortsam_pe/INPUT", 
                            "source": "#transform_mirna.cwl/bwa_pe/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_sortsam_pe/OUTPUT", 
                            "valueFrom": "$(inputs.INPUT.basename)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_sortsam_pe/SORTED_OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_sortsam_se", 
                    "run": "#picard_sortsam.cwl", 
                    "scatter": "#transform_mirna.cwl/picard_sortsam_se/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_sortsam_se/INPUT", 
                            "source": "#transform_mirna.cwl/bwa_se/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_sortsam_se/OUTPUT", 
                            "valueFrom": "$(inputs.INPUT.basename)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_sortsam_se/SORTED_OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_sortsam_o1", 
                    "run": "#picard_sortsam.cwl", 
                    "scatter": "#transform_mirna.cwl/picard_sortsam_o1/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_sortsam_o1/INPUT", 
                            "source": "#transform_mirna.cwl/bwa_o1/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_sortsam_o1/OUTPUT", 
                            "valueFrom": "$(inputs.INPUT.basename)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_sortsam_o1/SORTED_OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_sortsam_o2", 
                    "run": "#picard_sortsam.cwl", 
                    "scatter": "#transform_mirna.cwl/picard_sortsam_o2/INPUT", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_sortsam_o2/INPUT", 
                            "source": "#transform_mirna.cwl/bwa_o2/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_sortsam_o2/OUTPUT", 
                            "valueFrom": "$(inputs.INPUT.basename)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_sortsam_o2/SORTED_OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/metrics_pe", 
                    "run": "#metrics.cwl", 
                    "scatter": "#transform_mirna.cwl/metrics_pe/bam", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/metrics_pe/bam", 
                            "source": "#transform_mirna.cwl/picard_sortsam_pe/SORTED_OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_pe/known_snp", 
                            "source": "#transform_mirna.cwl/known_snp"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_pe/fasta", 
                            "source": "#transform_mirna.cwl/reference_sequence"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_pe/input_state", 
                            "valueFrom": "sorted_readgroup"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_pe/parent_bam", 
                            "source": "#transform_mirna.cwl/input_bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_pe/thread_count", 
                            "source": "#transform_mirna.cwl/thread_count"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_pe/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/metrics_pe/merge_sqlite_destination_sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/merge_metrics_pe", 
                    "run": "#merge_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/merge_metrics_pe/source_sqlite", 
                            "source": "#transform_mirna.cwl/metrics_pe/merge_sqlite_destination_sqlite"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_metrics_pe/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/merge_metrics_pe/destination_sqlite"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_metrics_pe/log"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/metrics_se", 
                    "run": "#metrics.cwl", 
                    "scatter": "#transform_mirna.cwl/metrics_se/bam", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/metrics_se/bam", 
                            "source": "#transform_mirna.cwl/picard_sortsam_se/SORTED_OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_se/known_snp", 
                            "source": "#transform_mirna.cwl/known_snp"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_se/fasta", 
                            "source": "#transform_mirna.cwl/reference_sequence"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_se/input_state", 
                            "valueFrom": "sorted_readgroup"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_se/parent_bam", 
                            "source": "#transform_mirna.cwl/input_bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_se/thread_count", 
                            "source": "#transform_mirna.cwl/thread_count"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_se/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/metrics_se/merge_sqlite_destination_sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/merge_metrics_se", 
                    "run": "#merge_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/merge_metrics_se/source_sqlite", 
                            "source": "#transform_mirna.cwl/metrics_se/merge_sqlite_destination_sqlite"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_metrics_se/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/merge_metrics_se/destination_sqlite"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_metrics_se/log"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_mergesamfiles_pe", 
                    "run": "#picard_mergesamfiles.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles_pe/INPUT", 
                            "source": "#transform_mirna.cwl/picard_sortsam_pe/SORTED_OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles_pe/OUTPUT", 
                            "source": "#transform_mirna.cwl/input_bam", 
                            "valueFrom": "$(self.basename)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles_pe/MERGED_OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_mergesamfiles_se", 
                    "run": "#picard_mergesamfiles.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles_se/INPUT", 
                            "source": "#transform_mirna.cwl/picard_sortsam_se/SORTED_OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles_se/OUTPUT", 
                            "source": "#transform_mirna.cwl/input_bam", 
                            "valueFrom": "$(self.basename)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles_se/MERGED_OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_mergesamfiles_o1", 
                    "run": "#picard_mergesamfiles.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles_o1/INPUT", 
                            "source": "#transform_mirna.cwl/picard_sortsam_o1/SORTED_OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles_o1/OUTPUT", 
                            "source": "#transform_mirna.cwl/input_bam", 
                            "valueFrom": "$(self.basename)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles_o1/MERGED_OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_mergesamfiles_o2", 
                    "run": "#picard_mergesamfiles.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles_o2/INPUT", 
                            "source": "#transform_mirna.cwl/picard_sortsam_o2/SORTED_OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles_o2/OUTPUT", 
                            "source": "#transform_mirna.cwl/input_bam", 
                            "valueFrom": "$(self.basename)"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles_o2/MERGED_OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_mergesamfiles", 
                    "run": "#picard_mergesamfiles.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles/INPUT", 
                            "source": [
                                "#transform_mirna.cwl/picard_mergesamfiles_pe/MERGED_OUTPUT", 
                                "#transform_mirna.cwl/picard_mergesamfiles_se/MERGED_OUTPUT", 
                                "#transform_mirna.cwl/picard_mergesamfiles_o1/MERGED_OUTPUT", 
                                "#transform_mirna.cwl/picard_mergesamfiles_o2/MERGED_OUTPUT"
                            ]
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles/OUTPUT", 
                            "source": "#transform_mirna.cwl/input_bam", 
                            "valueFrom": "$(self.basename.slice(0,-4) + \"_gdc_realn.bam\")"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_mergesamfiles/MERGED_OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/bam_reheader", 
                    "run": "#bam_reheader.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/bam_reheader/input", 
                            "source": "#transform_mirna.cwl/picard_mergesamfiles/MERGED_OUTPUT"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/bam_reheader/output"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_markduplicates", 
                    "run": "#picard_markduplicates.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_markduplicates/INPUT", 
                            "source": "#transform_mirna.cwl/bam_reheader/output"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_markduplicates/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_markduplicates/METRICS"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_markduplicates_to_sqlite", 
                    "run": "#picard_markduplicates_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_markduplicates_to_sqlite/bam", 
                            "source": "#transform_mirna.cwl/picard_markduplicates/OUTPUT", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_markduplicates_to_sqlite/input_state", 
                            "valueFrom": "markduplicates_readgroups"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_markduplicates_to_sqlite/metric_path", 
                            "source": "#transform_mirna.cwl/picard_markduplicates/METRICS"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_markduplicates_to_sqlite/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_markduplicates_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_validatesamfile_markduplicates", 
                    "run": "#picard_validatesamfile.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_markduplicates/INPUT", 
                            "source": "#transform_mirna.cwl/picard_markduplicates/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_markduplicates/VALIDATION_STRINGENCY", 
                            "valueFrom": "STRICT"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_markduplicates/OUTPUT"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/picard_validatesamfile_markdupl_to_sqlite", 
                    "run": "#picard_validatesamfile_to_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_markdupl_to_sqlite/bam", 
                            "source": "#transform_mirna.cwl/input_bam", 
                            "valueFrom": "$(self.basename)"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_markdupl_to_sqlite/input_state", 
                            "valueFrom": "markduplicates_readgroups"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_markdupl_to_sqlite/metric_path", 
                            "source": "#transform_mirna.cwl/picard_validatesamfile_markduplicates/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_markdupl_to_sqlite/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/picard_validatesamfile_markdupl_to_sqlite/sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/metrics_markduplicates", 
                    "run": "#mixed_library_metrics.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/metrics_markduplicates/bam", 
                            "source": "#transform_mirna.cwl/picard_markduplicates/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_markduplicates/known_snp", 
                            "source": "#transform_mirna.cwl/known_snp"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_markduplicates/fasta", 
                            "source": "#transform_mirna.cwl/reference_sequence"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_markduplicates/input_state", 
                            "valueFrom": "markduplicates_readgroups"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_markduplicates/thread_count", 
                            "source": "#transform_mirna.cwl/thread_count"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/metrics_markduplicates/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/metrics_markduplicates/merge_sqlite_destination_sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/mirna_profiling", 
                    "run": "#mirna_profiling.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/awk_expression", 
                            "valueFrom": "{arr[length($10)]+=1} END {for (i in arr) {print i\" \"arr[i]}}"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/bam", 
                            "source": "#transform_mirna.cwl/picard_markduplicates/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/mirbase_db", 
                            "valueFrom": "mirbase"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/species_code", 
                            "valueFrom": "hsa"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/project_directory", 
                            "valueFrom": "."
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/ucsc_database", 
                            "valueFrom": "hg38"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/mirna_adapter_report_sorted_output"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/mirna_alignment_stats_features"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/mirna_expression_matrix_expn_matrix_txt"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/mirna_expression_matrix_expn_matrix_norm_txt"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/mirna_expression_matrix_expn_matrix_norm_log_txt"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/mirna_expression_matrix_mimat_expn_matrix_mimat_txt"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/mirna_expression_matrix_mimat_expn_matrix_mimat_norm_txt"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/mirna_expression_matrix_mimat_expn_matrix_mimat_norm_log_txt"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/mirna_graph_libs_jpgs"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/mirna_tcga_isoforms_quant"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/mirna_profiling/mirna_tcga_mirnas_quant"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/integrity", 
                    "run": "#integrity.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/integrity/bai", 
                            "source": "#transform_mirna.cwl/picard_markduplicates/OUTPUT", 
                            "valueFrom": "$(self.secondaryFiles[0])"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/integrity/bam", 
                            "source": "#transform_mirna.cwl/picard_markduplicates/OUTPUT"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/integrity/input_state", 
                            "valueFrom": "markduplicates_readgroups"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/integrity/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/integrity/merge_sqlite_destination_sqlite"
                        }
                    ]
                }, 
                {
                    "id": "#transform_mirna.cwl/merge_all_sqlite", 
                    "run": "#merge_sqlite.cwl", 
                    "in": [
                        {
                            "id": "#transform_mirna.cwl/merge_all_sqlite/source_sqlite", 
                            "source": [
                                "#transform_mirna.cwl/picard_validatesamfile_original_to_sqlite/sqlite", 
                                "#transform_mirna.cwl/picard_validatesamfile_markdupl_to_sqlite/sqlite", 
                                "#transform_mirna.cwl/merge_readgroup_json_db/destination_sqlite", 
                                "#transform_mirna.cwl/merge_fastqc_db1_sqlite/destination_sqlite", 
                                "#transform_mirna.cwl/merge_fastqc_db2_sqlite/destination_sqlite", 
                                "#transform_mirna.cwl/merge_fastqc_db_s_sqlite/destination_sqlite", 
                                "#transform_mirna.cwl/merge_fastqc_db_o1_sqlite/destination_sqlite", 
                                "#transform_mirna.cwl/merge_fastqc_db_o2_sqlite/destination_sqlite", 
                                "#transform_mirna.cwl/merge_metrics_pe/destination_sqlite", 
                                "#transform_mirna.cwl/merge_metrics_se/destination_sqlite", 
                                "#transform_mirna.cwl/metrics_markduplicates/merge_sqlite_destination_sqlite", 
                                "#transform_mirna.cwl/picard_markduplicates_to_sqlite/sqlite", 
                                "#transform_mirna.cwl/integrity/merge_sqlite_destination_sqlite"
                            ]
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_all_sqlite/task_uuid", 
                            "source": "#transform_mirna.cwl/task_uuid"
                        }
                    ], 
                    "out": [
                        {
                            "id": "#transform_mirna.cwl/merge_all_sqlite/destination_sqlite"
                        }, 
                        {
                            "id": "#transform_mirna.cwl/merge_all_sqlite/log"
                        }
                    ]
                }
            ], 
            "id": "#transform_mirna.cwl"
        }
    ]
}