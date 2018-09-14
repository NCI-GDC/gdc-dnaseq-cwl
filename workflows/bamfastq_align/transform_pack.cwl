{
    "$graph": [
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/bam_readgroup_to_json:7cb045ba57c027e283fbf42ea566f39b5f4846b1381e69b9e36e32bb978f0c9a"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 1,
                    "tmpdirMax": 1,
                    "outdirMin": 1,
                    "outdirMax": 1
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
                    "dockerPull": "quay.io/ncigdc/bam_reheader:8c48be466efff5ae84b1711c77c66e72e1e3a99830bc882cc6155337c07d8f74"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 10000,
                    "ramMax": 10000,
                    "tmpdirMin": "$(Math.ceil(1.1 * inputs.input.size / 1048576))",
                    "tmpdirMax": "$(Math.ceil(1.1 * inputs.input.size / 1048576))",
                    "outdirMin": "$(Math.ceil(1.1 * inputs.input.size / 1048576))",
                    "outdirMax": "$(Math.ceil(1.1 * inputs.input.size / 1048576))"
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
                    "dockerPull": "quay.io/ncigdc/biobambam:533ed9be5fd34b177b5a906262c615bff1a4cdc2c84b78c2244cbd7283842120"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 2000,
                    "ramMax": 2000,
                    "tmpdirMin": "$(Math.ceil(0.9 * inputs.filename.size / 1048576))",
                    "tmpdirMax": "$(Math.ceil(0.9 * inputs.filename.size / 1048576))",
                    "outdirMin": "$(Math.ceil(0.9 * inputs.filename.size / 1048576))",
                    "outdirMax": "$(Math.ceil(0.9 * inputs.filename.size / 1048576))"
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
                    "dockerPull": "quay.io/ncigdc/bwa:6f48348ec54042c9bb420ea5e28eea8f62a81c15b44800673bdfece1f379591b"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "name": "#readgroup.yml/readgroup_meta",
                            "type": "record",
                            "fields": [
                                {
                                    "name": "#readgroup.yml/readgroup_meta/CN",
                                    "type": "string"
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_meta/DS",
                                    "type": [
                                        "null",
                                        "string"
                                    ]
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_meta/DT",
                                    "type": [
                                        "null",
                                        "string"
                                    ]
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_meta/FO",
                                    "type": [
                                        "null",
                                        "string"
                                    ]
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_meta/ID",
                                    "type": "string"
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_meta/KS",
                                    "type": [
                                        "null",
                                        "string"
                                    ]
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_meta/LB",
                                    "type": "string"
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_meta/PI",
                                    "type": [
                                        "null",
                                        "string"
                                    ]
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_meta/PL",
                                    "type": "string"
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_meta/PM",
                                    "type": [
                                        "null",
                                        "string"
                                    ]
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_meta/PU",
                                    "type": [
                                        "null",
                                        "string"
                                    ]
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_meta/SM",
                                    "type": "string"
                                }
                            ]
                        },
                        {
                            "name": "#readgroup.yml/readgroup_fastq_pe_file",
                            "type": "record",
                            "fields": [
                                {
                                    "name": "#readgroup.yml/readgroup_fastq_pe_file/forward_fastq",
                                    "type": "File"
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_fastq_pe_file/reverse_fastq",
                                    "type": "File"
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_fastq_pe_file/readgroup_meta",
                                    "type": "#readgroup.yml/readgroup_meta"
                                }
                            ]
                        },
                        {
                            "name": "#readgroup.yml/readgroup_fastq_se_file",
                            "type": "record",
                            "fields": [
                                {
                                    "name": "#readgroup.yml/readgroup_fastq_se_file/fastq",
                                    "type": "File"
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_fastq_se_file/readgroup_meta",
                                    "type": "#readgroup.yml/readgroup_meta"
                                }
                            ]
                        },
                        {
                            "name": "#readgroup.yml/readgroups_bam_file",
                            "type": "record",
                            "fields": [
                                {
                                    "name": "#readgroup.yml/readgroups_bam_file/bam",
                                    "type": "File"
                                },
                                {
                                    "name": "#readgroup.yml/readgroups_bam_file/readgroup_meta_list",
                                    "type": {
                                        "type": "array",
                                        "items": "#readgroup.yml/readgroup_meta"
                                    }
                                }
                            ]
                        },
                        {
                            "name": "#readgroup.yml/readgroup_fastq_pe_uuid",
                            "type": "record",
                            "fields": [
                                {
                                    "name": "#readgroup.yml/readgroup_fastq_pe_uuid/forward_fastq_uuid",
                                    "type": "string"
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_fastq_pe_uuid/forward_fastq_file_size",
                                    "type": "long"
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_fastq_pe_uuid/reverse_fastq_uuid",
                                    "type": "string"
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_fastq_pe_uuid/reverse_fastq_file_size",
                                    "type": "long"
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_fastq_pe_uuid/readgroup_meta",
                                    "type": "#readgroup.yml/readgroup_meta"
                                }
                            ]
                        },
                        {
                            "name": "#readgroup.yml/readgroup_fastq_se_uuid",
                            "type": "record",
                            "fields": [
                                {
                                    "name": "#readgroup.yml/readgroup_fastq_se_uuid/fastq_uuid",
                                    "type": "string"
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_fastq_se_uuid/fastq_file_size",
                                    "type": "long"
                                },
                                {
                                    "name": "#readgroup.yml/readgroup_fastq_se_uuid/readgroup_meta",
                                    "type": "#readgroup.yml/readgroup_meta"
                                }
                            ]
                        },
                        {
                            "name": "#readgroup.yml/readgroups_bam_uuid",
                            "type": "record",
                            "fields": [
                                {
                                    "name": "#readgroup.yml/readgroups_bam_uuid/bam_uuid",
                                    "type": "string"
                                },
                                {
                                    "name": "#readgroup.yml/readgroups_bam_uuid/bam_file_size",
                                    "type": "long"
                                },
                                {
                                    "name": "#readgroup.yml/readgroups_bam_uuid/readgroup_meta_list",
                                    "type": {
                                        "type": "array",
                                        "items": "#readgroup.yml/readgroup_meta"
                                    }
                                }
                            ]
                        }
                    ]
                },
                {
                    "class": "ShellCommandRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": "$(inputs.thread_count)",
                    "coresMax": "$(inputs.thread_count)",
                    "ramMin": 10000,
                    "ramMax": 10000,
                    "tmpdirMin": "$(Math.ceil(2 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))",
                    "tmpdirMax": "$(Math.ceil(2 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))",
                    "outdirMin": "$(Math.ceil(2 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))",
                    "outdirMax": "$(Math.ceil(2 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))"
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#bwa_record_pe.cwl/fastq1",
                    "type": "File",
                    "format": "edam:format_2182"
                },
                {
                    "id": "#bwa_record_pe.cwl/fastq2",
                    "type": "File",
                    "format": "edam:format_2182"
                },
                {
                    "id": "#bwa_record_pe.cwl/fasta",
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
                    "id": "#bwa_record_pe.cwl/readgroup_meta",
                    "type": "#readgroup.yml/readgroup_meta"
                },
                {
                    "id": "#bwa_record_pe.cwl/fastqc_json_path",
                    "type": "File",
                    "format": "edam:format_3464",
                    "inputBinding": {
                        "loadContents": true,
                        "valueFrom": "$(null)"
                    }
                },
                {
                    "id": "#bwa_record_pe.cwl/thread_count",
                    "type": "long"
                }
            ],
            "outputs": [
                {
                    "id": "#bwa_record_pe.cwl/OUTPUT",
                    "type": "File",
                    "format": "edam:format_2572",
                    "outputBinding": {
                        "glob": "$(inputs.readgroup_meta['ID'] + \".bam\")"
                    }
                }
            ],
            "arguments": [
                {
                    "valueFrom": "${\n  function to_rg() {\n    var readgroup_str = \"@RG\";\n    var keys = Object.keys(inputs.readgroup_meta).sort();\n    for (var i = 0; i < keys.length; i++) {\n      var key = keys[i];\n      var value = inputs.readgroup_meta[key];\n      if (key.length == 2 && value != null) {\n        readgroup_str = readgroup_str + \"\\\\t\" + key + \":\" + value;\n      }\n    }\n    return readgroup_str\n  }\n\n  function bwa_aln_33(rg_str, outbam) {\n    var cmd = [\n    \"bwa\", \"aln\", \"-t\", inputs.thread_count, inputs.fasta.path, inputs.fastq1.path, \">\", \"aln.sai1\", \"&&\",\n    \"bwa\", \"aln\", \"-t\", inputs.thread_count, inputs.fasta.path, inputs.fastq2.path, \">\", \"aln.sai2\", \"&&\",\n    \"bwa\", \"sampe\", \"-r\", \"\\\"\" + rg_str + \"\\\"\", inputs.fasta.path, \"aln.sai1\", \"aln.sai2\", inputs.fastq1.path, inputs.fastq2.path, \"|\",\n    \"samtools\", \"view\", \"-Shb\", \"-o\", outbam, \"-\"\n    ];\n    return cmd.join(' ')\n  }\n\n  function bwa_aln_64(rg_str, outbam) {\n    var cmd = [\n    \"bwa\", \"aln\", \"-I\",\"-t\", inputs.thread_count, inputs.fasta.path, inputs.fastq1.path, \">\", \"aln.sai1\", \"&&\",\n    \"bwa\", \"aln\", \"-I\", \"-t\", inputs.thread_count, inputs.fasta.path, inputs.fastq2.path, \">\", \"aln.sai2\", \"&&\",\n    \"bwa\", \"sampe\", \"-r\", \"\\\"\" + rg_str + \"\\\"\", inputs.fasta.path, \"aln.sai1\", \"aln.sai2\", inputs.fastq1.path, inputs.fastq2.path, \"|\",\n    \"samtools\", \"view\", \"-Shb\", \"-o\", outbam, \"-\"\n    ];\n    return cmd.join(' ')\n  }\n\n  function bwa_mem(rg_str, outbam) {\n    var cmd = [\n    \"bwa\", \"mem\", \"-t\", inputs.thread_count, \"-T\", \"0\", \"-R\", \"\\\"\" + rg_str + \"\\\"\",\n    inputs.fasta.path, inputs.fastq1.path, inputs.fastq2.path, \"|\",\n    \"samtools\", \"view\", \"-Shb\", \"-o\", outbam, \"-\"\n    ];\n    return cmd.join(' ')\n  }\n\n  var MEM_ALN_CUTOFF = 70;\n  var fastqc_json = JSON.parse(inputs.fastqc_json_path.contents);\n  var readlength = fastqc_json[inputs.fastq1.basename][\"Sequence length\"];\n  var encoding = fastqc_json[inputs.fastq1.basename][\"Encoding\"];\n  var rg_str = to_rg();\n\n  var outbam = inputs.readgroup_meta['ID'] + \".bam\";\n\n  if (encoding == \"Illumina 1.3\" || encoding == \"Illumina 1.5\") {\n    return bwa_aln_64(rg_str, outbam)\n  } else if (encoding == \"Sanger / Illumina 1.9\") {\n    if (readlength < MEM_ALN_CUTOFF) {\n      return bwa_aln_33(rg_str, outbam)\n    }\n    else {\n      return bwa_mem(rg_str, outbam)\n    }\n  } else {\n    return\n  }\n\n}\n"
                }
            ],
            "baseCommand": [
                "bash",
                "-c"
            ],
            "id": "#bwa_record_pe.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/bwa:6f48348ec54042c9bb420ea5e28eea8f62a81c15b44800673bdfece1f379591b"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#readgroup.yml/readgroup_meta"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_uuid"
                        }
                    ]
                },
                {
                    "class": "ShellCommandRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": "$(inputs.thread_count)",
                    "coresMax": "$(inputs.thread_count)",
                    "ramMin": 10000,
                    "ramMax": 10000,
                    "tmpdirMin": "$(Math.ceil(2 * (inputs.fastq.size) / 1048576))",
                    "tmpdirMax": "$(Math.ceil(2 * (inputs.fastq.size) / 1048576))",
                    "outdirMin": "$(Math.ceil(2 * (inputs.fastq.size) / 1048576))",
                    "outdirMax": "$(Math.ceil(2 * (inputs.fastq.size) / 1048576))"
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#bwa_record_se.cwl/fastq",
                    "type": "File",
                    "format": "edam:format_2182"
                },
                {
                    "id": "#bwa_record_se.cwl/fasta",
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
                    "id": "#bwa_record_se.cwl/readgroup_meta",
                    "type": "#readgroup.yml/readgroup_meta"
                },
                {
                    "id": "#bwa_record_se.cwl/fastqc_json_path",
                    "type": "File",
                    "inputBinding": {
                        "loadContents": true,
                        "valueFrom": "$(null)"
                    }
                },
                {
                    "id": "#bwa_record_se.cwl/samse_maxOcc",
                    "type": "long",
                    "default": 3
                },
                {
                    "id": "#bwa_record_se.cwl/thread_count",
                    "type": "long"
                }
            ],
            "outputs": [
                {
                    "id": "#bwa_record_se.cwl/OUTPUT",
                    "type": "File",
                    "format": "edam:format_2572",
                    "outputBinding": {
                        "glob": "$(inputs.readgroup_meta['ID'] + \".bam\")"
                    }
                }
            ],
            "arguments": [
                {
                    "valueFrom": "${\n  function to_rg() {\n    var readgroup_str = \"@RG\";\n    var keys = Object.keys(inputs.readgroup_meta).sort();\n    for (var i = 0; i < keys.length; i++) {\n      var key = keys[i];\n      var value = inputs.readgroup_meta[key];\n      if (key.length == 2 && value != null) {\n        readgroup_str = readgroup_str + \"\\\\t\" + key + \":\" + value;\n      }\n    }\n    return readgroup_str\n  }\n\n  function bwa_aln_33(rg_str, outbam) {\n    var cmd = [\n    \"bwa\", \"aln\", \"-t\", inputs.thread_count, inputs.fasta.path, inputs.fastq.path, \">\", \"aln.sai\", \"&&\",\n    \"bwa\", \"samse\", \"-n\", inputs.samse_maxOcc, \"-r\", \"\\\"\" + rg_str + \"\\\"\", inputs.fasta.path, \"aln.sai\", inputs.fastq.path, \"|\",\n    \"samtools\", \"view\", \"-Shb\", \"-o\", outbam, \"-\"\n    ];\n    return cmd.join(' ')\n  }\n\n  function bwa_aln_64(rg_str, outbam) {\n    var cmd = [\n    \"bwa\", \"aln\", \"-I\",\"-t\", inputs.thread_count, inputs.fasta.path, inputs.fastq.path, \">\", \"aln.sai\", \"&&\",\n    \"bwa\", \"samse\", \"-n\", inputs.samse_maxOcc, \"-r\", \"\\\"\" + rg_str + \"\\\"\", inputs.fasta.path, \"aln.sai\", inputs.fastq.path, \"|\",\n    \"samtools\", \"view\", \"-Shb\", \"-o\", outbam, \"-\"\n    ];\n    return cmd.join(' ')\n  }\n\n  function bwa_mem(rg_str, outbam) {\n    var cmd = [\n    \"bwa\", \"mem\", \"-t\", inputs.thread_count, \"-T\", \"0\", \"-R\", \"\\\"\" + rg_str + \"\\\"\",\n    inputs.fasta.path, inputs.fastq.path, \"|\",\n    \"samtools\", \"view\", \"-Shb\", \"-o\", outbam, \"-\"\n    ];\n    return cmd.join(' ')\n  }\n\n  var MEM_ALN_CUTOFF = 70;\n  var fastqc_json = JSON.parse(inputs.fastqc_json_path.contents);\n  var readlength = fastqc_json[inputs.fastq.basename][\"Sequence length\"];\n  var encoding = fastqc_json[inputs.fastq.basename][\"Encoding\"];\n  var rg_str = to_rg();\n\n  var outbam = inputs.readgroup_meta['ID'] + \".bam\";\n\n  if (encoding == \"Illumina 1.3\" || encoding == \"Illumina 1.5\") {\n    return bwa_aln_64(rg_str, outbam)\n  } else if (encoding == \"Sanger / Illumina 1.9\") {\n    if (readlength < MEM_ALN_CUTOFF) {\n      return bwa_aln_33(rg_str, outbam)\n    }\n    else {\n      return bwa_mem(rg_str, outbam)\n    }\n  } else {\n    return\n  }\n\n}\n"
                }
            ],
            "baseCommand": [
                "bash",
                "-c"
            ],
            "id": "#bwa_record_se.cwl"
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
                    "id": "#decider_conditional_bams.cwl/conditional_bam1",
                    "format": "edam:format_2572",
                    "type": {
                        "type": "array",
                        "items": "File"
                    }
                },
                {
                    "id": "#decider_conditional_bams.cwl/conditional_sqlite1",
                    "format": "edam:format_3621",
                    "type": {
                        "type": "array",
                        "items": "File"
                    }
                },
                {
                    "id": "#decider_conditional_bams.cwl/conditional_bam2",
                    "format": "edam:format_2572",
                    "type": {
                        "type": "array",
                        "items": "File"
                    }
                },
                {
                    "id": "#decider_conditional_bams.cwl/conditional_sqlite2",
                    "format": "edam:format_3621",
                    "type": {
                        "type": "array",
                        "items": "File"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#decider_conditional_bams.cwl/output",
                    "format": "edam:format_2572",
                    "type": "File",
                    "secondaryFiles": [
                        "^.bai"
                    ]
                },
                {
                    "id": "#decider_conditional_bams.cwl/sqlite",
                    "format": "edam:format_3621",
                    "type": "File"
                }
            ],
            "expression": "${\n   if (inputs.conditional_bam1.length == 1 && inputs.conditional_bam2.length == 0)  {\n     var output = inputs.conditional_bam1[0];\n     var sqlite = inputs.conditional_sqlite1[0];\n   }\n   else if (inputs.conditional_bam1.length == 0 && inputs.conditional_bam2.length == 1) {\n     var output = inputs.conditional_bam2[0];\n     var sqlite = inputs.conditional_sqlite2[0];\n   }\n   else {\n     throw \"unhandled\";\n   }\n\n   return {'output': output, 'sqlite': sqlite};\n }\n",
            "id": "#decider_conditional_bams.cwl"
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
                    "id": "#decider_readgroup_expression.cwl/fastq",
                    "format": "edam:format_2182",
                    "type": {
                        "type": "array",
                        "items": "File"
                    }
                },
                {
                    "id": "#decider_readgroup_expression.cwl/readgroup_json",
                    "format": "edam:format_3464",
                    "type": {
                        "type": "array",
                        "items": "File"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#decider_readgroup_expression.cwl/output",
                    "format": "edam:format_3464",
                    "type": {
                        "type": "array",
                        "items": "File"
                    }
                }
            ],
            "expression": "${\n\n   // https://stackoverflow.com/a/9849276/810957\n   function include(arr,obj) {\n     return (arr.indexOf(obj) != -1)\n   }\n\n   // https://stackoverflow.com/a/2548133/810957\n   function endsWith(str, suffix) {\n     return str.indexOf(suffix, str.length - suffix.length) !== -1;\n   }\n\n   // https://stackoverflow.com/questions/3820381/need-a-basename-function-in-javascript#comment29942319_15270931\n   function local_basename(path) {\n     var basename = path.split(/[\\\\/]/).pop();\n     return basename\n   }\n\n   // https://planetozh.com/blog/2008/04/javascript-basename-and-dirname/\n   function local_dirname(path) {\n     return path.replace(/\\\\/g,'/').replace(/\\/[^\\/]*$/, '');\n   }\n\n   function get_slice_number(fastq_name) {\n     if (endsWith(fastq_name, '_1.fq.gz')) {\n       return -8\n     }\n     else if (endsWith(fastq_name, '_s.fq.gz')) {\n       return -8\n     }\n     else if (endsWith(fastq_name, '_o1.fq.gz')) {\n       return -9\n     }\n     else if (endsWith(fastq_name, '_o2.fq.gz')) {\n       return -9\n     }\n     else {\n       throw \"not recognized fastq suffix\"\n     }\n   }\n   \n   // get predicted readgroup basenames from fastq\n   var readgroup_basename_array = [];\n   for (var i = 0; i < inputs.fastq.length; i++) {\n     var fq_path = inputs.fastq[i];\n     var fq_name = local_basename(fq_path.location);\n\n     var slice_number = get_slice_number(fq_name);\n     \n     var readgroup_name = fq_name.slice(0,slice_number) + \".json\";\n     readgroup_basename_array.push(readgroup_name);\n   }\n\n   // find which readgroup items are in predicted basenames\n   var readgroup_array = [];\n   for (var i = 0; i < inputs.readgroup_json.length; i++) {\n     var readgroup = inputs.readgroup_json[i];\n     var readgroup_basename = local_basename(readgroup.location);\n     if (include(readgroup_basename_array, readgroup_basename)) {\n       readgroup_array.push(readgroup);\n     }\n   }\n\n   var readgroup_sorted = readgroup_array.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) });\n   return {'output': readgroup_sorted}\n }\n",
            "id": "#decider_readgroup_expression.cwl"
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
                    "id": "#emit_file_format.cwl/input",
                    "type": "File"
                },
                {
                    "id": "#emit_file_format.cwl/format",
                    "type": "string"
                }
            ],
            "outputs": [
                {
                    "id": "#emit_file_format.cwl/output",
                    "type": "File"
                }
            ],
            "expression": "${\n  var output = inputs.input;\n  output.format = inputs.format;\n  return {'output': output}\n}\n",
            "id": "#emit_file_format.cwl"
        },
        {
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#readgroup.yml/readgroup_meta"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_uuid"
                        }
                    ]
                }
            ],
            "class": "ExpressionTool",
            "inputs": [
                {
                    "id": "#emit_json_readgroup_meta.cwl/input",
                    "type": "File",
                    "inputBinding": {
                        "loadContents": true,
                        "valueFrom": "$(null)"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#emit_json_readgroup_meta.cwl/output",
                    "type": "#readgroup.yml/readgroup_meta"
                }
            ],
            "expression": "${\n  var readgroup = JSON.parse(inputs.input.contents);\n  var output = new Object();\n  for (var i in readgroup) {\n    if (i.length == 2) {\n      if (i == 'PL') {\n        output[i] = readgroup[i].toUpperCase();\n      } else {\n        output[i] = readgroup[i];\n      }\n    }\n  }\n\n  return {'output': output};\n}\n",
            "id": "#emit_json_readgroup_meta.cwl"
        },
        {
            "requirements": [
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#readgroup.yml/readgroup_meta"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_uuid"
                        }
                    ]
                },
                {
                    "class": "InlineJavascriptRequirement"
                }
            ],
            "class": "ExpressionTool",
            "inputs": [
                {
                    "id": "#emit_readgroup_fastq_pe_file.cwl/forward_fastq",
                    "type": "File"
                },
                {
                    "id": "#emit_readgroup_fastq_pe_file.cwl/reverse_fastq",
                    "type": "File"
                },
                {
                    "id": "#emit_readgroup_fastq_pe_file.cwl/readgroup_meta",
                    "type": "#readgroup.yml/readgroup_meta"
                }
            ],
            "outputs": [
                {
                    "id": "#emit_readgroup_fastq_pe_file.cwl/output",
                    "type": "#readgroup.yml/readgroup_fastq_pe_file"
                }
            ],
            "expression": "${\n  var output = { \"forward_fastq\": inputs.forward_fastq,\n                 \"reverse_fastq\": inputs.reverse_fastq,\n                 \"readgroup_meta\": inputs.readgroup_meta\n                 };\n  output.forward_fastq.format = \"edam:format_2182\";\n  output.reverse_fastq.format = \"edam:format_2182\";\n  return {'output': output}\n}\n",
            "id": "#emit_readgroup_fastq_pe_file.cwl"
        },
        {
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#readgroup.yml/readgroup_meta"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_uuid"
                        }
                    ]
                }
            ],
            "class": "ExpressionTool",
            "inputs": [
                {
                    "id": "#emit_readgroup_fastq_se_file.cwl/fastq",
                    "type": "File"
                },
                {
                    "id": "#emit_readgroup_fastq_se_file.cwl/readgroup_meta",
                    "type": "#readgroup.yml/readgroup_meta"
                }
            ],
            "outputs": [
                {
                    "id": "#emit_readgroup_fastq_se_file.cwl/output",
                    "type": "#readgroup.yml/readgroup_fastq_se_file"
                }
            ],
            "expression": "${\n  var output = { \"fastq\": inputs.fastq,\n                 \"readgroup_meta\": inputs.readgroup_meta};\n  output.fastq.format = \"edam:format_2182\";\n  return {'output': output}\n}\n",
            "id": "#emit_readgroup_fastq_se_file.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/fastq_cleaner:428dc9a83e62a74c61d8a5fe907f5d75154f862dc47b755b0f7cfdf1cfd66668"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 2,
                    "coresMax": 2,
                    "ramMin": 2000,
                    "ramMax": 2000,
                    "tmpdirMin": "$(Math.ceil(1.1 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))",
                    "tmpdirMax": "$(Math.ceil(1.1 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))",
                    "outdirMin": "$(Math.ceil(1.1 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))",
                    "outdirMax": "$(Math.ceil(1.1 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))"
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#fastq_cleaner_pe.cwl/fastq1",
                    "type": "File",
                    "format": "edam:format_2182",
                    "inputBinding": {
                        "prefix": "--fastq"
                    }
                },
                {
                    "id": "#fastq_cleaner_pe.cwl/fastq2",
                    "type": "File",
                    "format": "edam:format_2182",
                    "inputBinding": {
                        "prefix": "--fastq2"
                    }
                },
                {
                    "id": "#fastq_cleaner_pe.cwl/reads_in_memory",
                    "type": "long",
                    "default": 500000,
                    "inputBinding": {
                        "prefix": "--reads_in_memory"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#fastq_cleaner_pe.cwl/cleaned_fastq1",
                    "type": "File",
                    "format": "edam:format_2182",
                    "outputBinding": {
                        "glob": "$(inputs.fastq1.basename)"
                    }
                },
                {
                    "id": "#fastq_cleaner_pe.cwl/cleaned_fastq2",
                    "type": "File",
                    "format": "edam:format_2182",
                    "outputBinding": {
                        "glob": "$(inputs.fastq2.basename)"
                    }
                },
                {
                    "id": "#fastq_cleaner_pe.cwl/result_json",
                    "type": "File",
                    "format": "edam:format_3464",
                    "outputBinding": {
                        "glob": "result.json"
                    }
                }
            ],
            "baseCommand": [
                "/usr/local/bin/fastq_cleaner"
            ],
            "id": "#fastq_cleaner_pe.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/fastq_cleaner:428dc9a83e62a74c61d8a5fe907f5d75154f862dc47b755b0f7cfdf1cfd66668"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 2000,
                    "ramMax": 2000,
                    "tmpdirMin": "$(Math.ceil(1.1 * inputs.fastq.size / 1048576))",
                    "tmpdirMax": "$(Math.ceil(1.1 * inputs.fastq.size / 1048576))",
                    "outdirMin": "$(Math.ceil(1.1 * inputs.fastq.size / 1048576))",
                    "outdirMax": "$(Math.ceil(1.1 * inputs.fastq.size / 1048576))"
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#fastq_cleaner_se.cwl/fastq",
                    "type": "File",
                    "format": "edam:format_2182",
                    "inputBinding": {
                        "prefix": "--fastq"
                    }
                },
                {
                    "id": "#fastq_cleaner_se.cwl/reads_in_memory",
                    "type": "long",
                    "default": 500000,
                    "inputBinding": {
                        "prefix": "--reads_in_memory"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#fastq_cleaner_se.cwl/cleaned_fastq",
                    "type": "File",
                    "format": "edam:format_2182",
                    "outputBinding": {
                        "glob": "$(inputs.fastq.basename)"
                    }
                },
                {
                    "id": "#fastq_cleaner_se.cwl/result_json",
                    "type": "File",
                    "format": "edam:format_3464",
                    "outputBinding": {
                        "glob": "result.json"
                    }
                }
            ],
            "baseCommand": [
                "/usr/local/bin/fastq_cleaner"
            ],
            "id": "#fastq_cleaner_se.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/fastqc:27ec215ea82bd62a76ec86f9c8a692010cc0c99169e68d2fa0c0052450321f57"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": "$(inputs.threads)",
                    "coresMax": "$(inputs.threads)",
                    "ramMin": 5000,
                    "ramMax": 5000,
                    "tmpdirMin": 50,
                    "tmpdirMax": 50,
                    "outdirMin": 5,
                    "outdirMax": 5
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
                    "type": "long",
                    "default": 7,
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
                        "glob": "*_fastqc.zip"
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
                    "dockerPull": "quay.io/ncigdc/fastqc_to_json:0ebd446f08d9eb6ed5b069e9ae53ad822236dc56bb1154f9df0e0c22b5724ae7"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 1,
                    "tmpdirMax": 1,
                    "outdirMin": 1,
                    "outdirMax": 1
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
                    "format": "edam:format_3464",
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
                    "dockerPull": "quay.io/ncigdc/fastqc_db:3383ae9c9beaf905682b21cab14d20b3bc4fc738c7e1e126da99dc288ba016ac"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 100,
                    "tmpdirMax": 100,
                    "outdirMin": 10,
                    "outdirMax": 10
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
                    "id": "#fastqc_db.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#fastqc_db.cwl/LOG",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".log\")"
                    }
                },
                {
                    "id": "#fastqc_db.cwl/OUTPUT",
                    "type": "File",
                    "format": "edam:format_3621",
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
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/gatk:3e800f0a95f9c95ba8bad4ad00d823af3917337889181733da96fd9797b81732"
                },
                {
                    "class": "InlineJavascriptRequirement"
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#gatk4_applybqsr.cwl/input",
                    "format": "edam:format_2572",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "--input"
                    },
                    "secondaryFiles": [
                        "^.bai"
                    ]
                },
                {
                    "id": "#gatk4_applybqsr.cwl/bqsr-recal-file",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "--bqsr-recal-file"
                    }
                },
                {
                    "id": "#gatk4_applybqsr.cwl/emit-original-quals",
                    "type": [
                        {
                            "type": "enum",
                            "symbols": [
                                "#gatk4_applybqsr.cwl/emit-original-quals/true",
                                "#gatk4_applybqsr.cwl/emit-original-quals/false"
                            ]
                        }
                    ],
                    "default": "true",
                    "inputBinding": {
                        "prefix": "--emit-original-quals"
                    }
                },
                {
                    "id": "#gatk4_applybqsr.cwl/TMP_DIR",
                    "type": "string",
                    "default": ".",
                    "inputBinding": {
                        "prefix": "--TMP_DIR"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#gatk4_applybqsr.cwl/output_bam",
                    "format": "edam:format_2572",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.input.basename)"
                    },
                    "secondaryFiles": [
                        "^.bai"
                    ]
                }
            ],
            "arguments": [
                {
                    "valueFrom": "$(inputs.input.basename)",
                    "prefix": "--output"
                }
            ],
            "baseCommand": [
                "java",
                "-jar",
                "/usr/local/bin/gatk-package-4.0.7.0-local.jar",
                "ApplyBQSR"
            ],
            "id": "#gatk4_applybqsr.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/gatk:3e800f0a95f9c95ba8bad4ad00d823af3917337889181733da96fd9797b81732"
                },
                {
                    "class": "InlineJavascriptRequirement"
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#gatk4_baserecalibrator.cwl/input",
                    "format": "edam:format_2572",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "--input"
                    },
                    "secondaryFiles": [
                        "^.bai"
                    ]
                },
                {
                    "id": "#gatk4_baserecalibrator.cwl/known-sites",
                    "format": "edam:format_3016",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "--known-sites"
                    },
                    "secondaryFiles": [
                        ".tbi"
                    ]
                },
                {
                    "id": "#gatk4_baserecalibrator.cwl/reference",
                    "format": "edam:format_1929",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "--reference"
                    },
                    "secondaryFiles": [
                        ".fai",
                        "^.dict"
                    ]
                },
                {
                    "id": "#gatk4_baserecalibrator.cwl/TMP_DIR",
                    "type": "string",
                    "default": ".",
                    "inputBinding": {
                        "prefix": "--TMP_DIR"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#gatk4_baserecalibrator.cwl/output_grp",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.input.nameroot + \"_bqsr.grp\")"
                    }
                }
            ],
            "arguments": [
                {
                    "valueFrom": "$(inputs.input.nameroot + \"_bqsr.grp\")",
                    "prefix": "--output",
                    "separate": true
                }
            ],
            "baseCommand": [
                "java",
                "-jar",
                "/usr/local/bin/gatk-package-4.0.7.0-local.jar",
                "BaseRecalibrator"
            ],
            "id": "#gatk4_baserecalibrator.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/gatk:3e800f0a95f9c95ba8bad4ad00d823af3917337889181733da96fd9797b81732"
                },
                {
                    "class": "InlineJavascriptRequirement"
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#gatk4_calculatecontamination.cwl/input",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "--input"
                    }
                },
                {
                    "id": "#gatk4_calculatecontamination.cwl/TMP_DIR",
                    "type": "string",
                    "default": ".",
                    "inputBinding": {
                        "prefix": "--TMP_DIR"
                    }
                },
                {
                    "id": "#gatk4_calculatecontamination.cwl/bam_nameroot",
                    "type": "string"
                }
            ],
            "outputs": [
                {
                    "id": "#gatk4_calculatecontamination.cwl/output",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.bam_nameroot + \"_contamination.table\")"
                    }
                }
            ],
            "arguments": [
                {
                    "valueFrom": "$(inputs.bam_nameroot + \"_contamination.table\")",
                    "prefix": "--output",
                    "separate": true
                }
            ],
            "baseCommand": [
                "java",
                "-jar",
                "/usr/local/bin/gatk-package-4.0.7.0-local.jar",
                "CalculateContamination"
            ],
            "id": "#gatk4_calculatecontamination.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/gatk:3e800f0a95f9c95ba8bad4ad00d823af3917337889181733da96fd9797b81732"
                },
                {
                    "class": "InlineJavascriptRequirement"
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#gatk4_getpileupsummaries.cwl/input",
                    "format": "edam:format_2572",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "--input"
                    },
                    "secondaryFiles": [
                        "^.bai"
                    ]
                },
                {
                    "id": "#gatk4_getpileupsummaries.cwl/TMP_DIR",
                    "type": "string",
                    "default": ".",
                    "inputBinding": {
                        "prefix": "--TMP_DIR"
                    }
                },
                {
                    "id": "#gatk4_getpileupsummaries.cwl/variant",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "--variant"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#gatk4_getpileupsummaries.cwl/output",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.input.nameroot + \"_pileupsummaries.table\")"
                    }
                }
            ],
            "arguments": [
                {
                    "valueFrom": "$(inputs.input.nameroot + \"_pileupsummaries.table\")",
                    "prefix": "--output",
                    "separate": true
                }
            ],
            "baseCommand": [
                "java",
                "-jar",
                "/usr/local/bin/gatk-package-4.0.7.0-local.jar",
                "GetPileupSummaries"
            ],
            "id": "#gatk4_getpileupsummaries.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/picard_metrics_sqlite:e71798322233d02d67db0158aeeef27990d2d400aadfc92c3687ba85555b0cf8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 10,
                    "tmpdirMax": 10,
                    "outdirMin": 10,
                    "outdirMax": 10
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#gatk_calculatecontamination_to_sqlite.cwl/bam",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--bam"
                    }
                },
                {
                    "id": "#gatk_calculatecontamination_to_sqlite.cwl/input_state",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--input_state"
                    }
                },
                {
                    "id": "#gatk_calculatecontamination_to_sqlite.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
                    }
                },
                {
                    "id": "#gatk_calculatecontamination_to_sqlite.cwl/metric_path",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "--metric_path"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#gatk_calculatecontamination_to_sqlite.cwl/log",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid+\"_picard_gatk_CalculateContamination.log\")"
                    }
                },
                {
                    "id": "#gatk_calculatecontamination_to_sqlite.cwl/sqlite",
                    "format": "edam:format_3621",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".db\")"
                    }
                }
            ],
            "baseCommand": [
                "/usr/local/bin/picard_metrics_sqlite",
                "--metric_name",
                "gatk_CalculateContamination"
            ],
            "id": "#gatk_calculatecontamination_to_sqlite.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/integrity_to_sqlite:9b900fd5dedfdcb4b4c9a2034070463aa87b5e28a6e7ec59a0c504aab83c16f3"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 5,
                    "tmpdirMax": 5,
                    "outdirMin": 5,
                    "outdirMax": 5
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
                    "id": "#integrity_to_sqlite.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#integrity_to_sqlite.cwl/LOG",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".log\")"
                    }
                },
                {
                    "id": "#integrity_to_sqlite.cwl/OUTPUT",
                    "format": "edam:format_3621",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".db\")"
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
                    "dockerPull": "quay.io/ncigdc/json-to-sqlite:439b1b7f41fedc927859177a8073ac8b9ab8179b9c474fc274ac415d95b6eb7c"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 10,
                    "tmpdirMax": 10,
                    "outdirMin": 10,
                    "outdirMax": 10
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#json_to_sqlite.cwl/input_json",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "--input_json"
                    }
                },
                {
                    "id": "#json_to_sqlite.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
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
                    "format": "edam:format_3621",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid).db"
                    }
                },
                {
                    "id": "#json_to_sqlite.cwl/log",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid).log"
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
                    "dockerPull": "ubuntu:bionic-20180426"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 500,
                    "ramMax": 500,
                    "tmpdirMin": 1,
                    "tmpdirMax": 1,
                    "outdirMin": 1,
                    "outdirMax": 1
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
                    "dockerPull": "ubuntu:bionic-20180426"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 1,
                    "tmpdirMax": 1,
                    "outdirMin": 1,
                    "outdirMax": 1
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
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#readgroup.yml/readgroup_meta"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_uuid"
                        }
                    ]
                }
            ],
            "class": "ExpressionTool",
            "inputs": [
                {
                    "id": "#merge_pe_fastq_records.cwl/input",
                    "type": {
                        "type": "array",
                        "items": {
                            "type": "array",
                            "items": "#readgroup.yml/readgroup_fastq_pe_file"
                        }
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#merge_pe_fastq_records.cwl/output",
                    "type": {
                        "type": "array",
                        "items": "#readgroup.yml/readgroup_fastq_pe_file"
                    }
                }
            ],
            "expression": "${\n  var output = [];\n  var readgroup_array_str = \"\";\n  for (var i = 0; i < inputs.input.length; i++) {\n    var readgroup_array = inputs.input[i];\n    readgroup_array_str += \" \" + readgroup_array;\n    for (var j = 0; j < readgroup_array.length; j++) {\n      var readgroup = readgroup_array[j];\n      output.push(readgroup);\n    }\n  }\n\n  return {'output': output}\n}\n",
            "id": "#merge_pe_fastq_records.cwl"
        },
        {
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#readgroup.yml/readgroup_meta"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_uuid"
                        }
                    ]
                }
            ],
            "class": "ExpressionTool",
            "inputs": [
                {
                    "id": "#merge_se_fastq_records.cwl/input",
                    "type": {
                        "type": "array",
                        "items": {
                            "type": "array",
                            "items": "#readgroup.yml/readgroup_fastq_se_file"
                        }
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#merge_se_fastq_records.cwl/output",
                    "type": {
                        "type": "array",
                        "items": "#readgroup.yml/readgroup_fastq_se_file"
                    }
                }
            ],
            "expression": "${\n  var output = [];\n  var readgroup_array_str = \"\";\n  for (var i = 0; i < inputs.input.length; i++) {\n    var readgroup_array = inputs.input[i];\n    readgroup_array_str += \" \" + readgroup_array;\n    for (var j = 0; j < readgroup_array.length; j++) {\n      var readgroup = readgroup_array[j];\n      output.push(readgroup);\n    }\n  }\n\n  return {'output': output}\n}\n",
            "id": "#merge_se_fastq_records.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/merge_sqlite:1b3a6f55be8579ecfb4c9c0513c3b710717a8f4cd8e79c88ee8c0f28f604faa3"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": "${\nvar req_space = 0;\nfor (var i = 0; i < inputs.source_sqlite.length; i++) {\n    req_space += inputs.source_sqlite[i].size;\n  }\nreturn Math.ceil(2 * (req_space / 1048576));\n}      \n",
                    "tmpdirMax": "${\nvar req_space = 0;\nfor (var i = 0; i < inputs.source_sqlite.length; i++) {\n    req_space += inputs.source_sqlite[i].size;\n  }\nreturn Math.ceil(2 * (req_space / 1048576));\n}      \n",
                    "outdirMin": "${\nvar req_space = 0;\nfor (var i = 0; i < inputs.source_sqlite.length; i++) {\n    req_space += inputs.source_sqlite[i].size;\n  }\nreturn Math.ceil(req_space / 1048576);\n}      \n",
                    "outdirMax": "${\nvar req_space = 0;\nfor (var i = 0; i < inputs.source_sqlite.length; i++) {\n    req_space += inputs.source_sqlite[i].size;\n  }\nreturn Math.ceil(req_space / 1048576);\n}\n"
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
                    "id": "#merge_sqlite.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#merge_sqlite.cwl/destination_sqlite",
                    "format": "edam:format_3621",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".db\")"
                    }
                },
                {
                    "id": "#merge_sqlite.cwl/log",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".log\")"
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
                    "dockerPull": "quay.io/ncigdc/picard:092d034713aff237cf07ef28c22a46a113d1a59dc7ec6d71beb72295044a46f8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 49152,
                    "ramMax": 49152,
                    "tmpdirMin": 1000,
                    "tmpdirMax": 1000,
                    "outdirMin": 1000,
                    "outdirMax": 1000
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#picard_collecthsmetrics.cwl/BAIT_INTERVALS",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "BAIT_INTERVALS=",
                        "position": 10,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/BAIT_SET_NAME",
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "prefix": "BAIT_SET_NAME=",
                        "position": 11,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/CLIP_OVERLAPPING_READS",
                    "type": "string",
                    "default": "true",
                    "inputBinding": {
                        "prefix": "CLIP_OVERLAPPING_READS=",
                        "position": 12,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/COVERAGE_CAP",
                    "type": "int",
                    "default": 200,
                    "inputBinding": {
                        "prefix": "COVERAGE_CAP=",
                        "position": 13,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/INPUT",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "INPUT=",
                        "position": 14,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/METRIC_ACCUMULATION_LEVEL",
                    "type": {
                        "type": "array",
                        "items": "string",
                        "inputBinding": {
                            "prefix": "METRIC_ACCUMULATION_LEVEL=",
                            "position": 15,
                            "separate": false
                        }
                    },
                    "default": [
                        "ALL_READS",
                        "LIBRARY",
                        "SAMPLE",
                        "READ_GROUP"
                    ]
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/MINIMUM_BASE_QUALITY",
                    "type": "int",
                    "default": 20,
                    "inputBinding": {
                        "prefix": "MINIMUM_BASE_QUALITY=",
                        "position": 16,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/MINIMUM_MAPPING_QUALITY",
                    "type": "int",
                    "default": 20,
                    "inputBinding": {
                        "prefix": "MINIMUM_MAPPING_QUALITY=",
                        "position": 17,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/NEAR_DISTANCE",
                    "type": "int",
                    "default": 250,
                    "inputBinding": {
                        "prefix": "NEAR_DISTANCE=",
                        "position": 18,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/OUTPUT",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "OUTPUT=",
                        "position": 19,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/PER_BASE_COVERAGE",
                    "type": [
                        "null",
                        "File"
                    ],
                    "inputBinding": {
                        "prefix": "PER_BASE_COVERAGE=",
                        "position": 20,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/PER_TARGET_COVERAGE",
                    "type": [
                        "null",
                        "File"
                    ],
                    "inputBinding": {
                        "prefix": "PER_TARGET_COVERAGE=",
                        "position": 21,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/REFERENCE_SEQUENCE",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "REFERENCE_SEQUENCE=",
                        "position": 22,
                        "separate": false
                    },
                    "secondaryFiles": [
                        ".fai"
                    ]
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/SAMPLE_SIZE",
                    "type": "int",
                    "default": 10000,
                    "inputBinding": {
                        "prefix": "SAMPLE_SIZE=",
                        "position": 23,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/TARGET_INTERVALS",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "TARGET_INTERVALS=",
                        "position": 24,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/VALIDATION_STRINGENCY",
                    "default": "STRICT",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "VALIDATION_STRINGENCY=",
                        "position": 25,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecthsmetrics.cwl/java_xmx",
                    "default": "48G",
                    "type": "string",
                    "inputBinding": {
                        "position": -10,
                        "prefix": "-Xmx",
                        "separate": false
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#picard_collecthsmetrics.cwl/METRIC_OUTPUT",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.OUTPUT)"
                    }
                }
            ],
            "arguments": [
                {
                    "valueFrom": "-jar",
                    "position": -9
                },
                {
                    "valueFrom": "/usr/local/bin/picard.jar",
                    "position": -8
                },
                {
                    "valueFrom": "CollectHsMetrics",
                    "position": -7
                }
            ],
            "baseCommand": [
                "java"
            ],
            "id": "#picard_collecthsmetrics.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/picard_metrics_sqlite:e71798322233d02d67db0158aeeef27990d2d400aadfc92c3687ba85555b0cf8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 10,
                    "tmpdirMax": 10,
                    "outdirMin": 10,
                    "outdirMax": 10
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#picard_collecthsmetrics_to_sqlite.cwl/bam",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--bam"
                    }
                },
                {
                    "id": "#picard_collecthsmetrics_to_sqlite.cwl/input_state",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--input_state"
                    }
                },
                {
                    "id": "#picard_collecthsmetrics_to_sqlite.cwl/metric_path",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "--metric_path"
                    }
                },
                {
                    "id": "#picard_collecthsmetrics_to_sqlite.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#picard_collecthsmetrics_to_sqlite.cwl/log",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid+\"_picard_CollectHsMetrics.log\")"
                    }
                },
                {
                    "id": "#picard_collecthsmetrics_to_sqlite.cwl/sqlite",
                    "format": "edam:format_3621",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".db\")"
                    }
                }
            ],
            "baseCommand": [
                "/usr/local/bin/picard_metrics_sqlite",
                "--metric_name",
                "CollectHsMetrics"
            ],
            "id": "#picard_collecthsmetrics_to_sqlite.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/picard:092d034713aff237cf07ef28c22a46a113d1a59dc7ec6d71beb72295044a46f8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 10000,
                    "ramMax": 10000,
                    "tmpdirMin": 10,
                    "tmpdirMax": 10,
                    "outdirMin": 10,
                    "outdirMax": 10
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
                    "id": "#picard_collectmultiplemetrics.cwl/METRIC_ACCUMULATION_LEVEL",
                    "type": {
                        "type": "array",
                        "items": "string",
                        "inputBinding": {
                            "prefix": "METRIC_ACCUMULATION_LEVEL=",
                            "separate": false
                        }
                    },
                    "default": [
                        "ALL_READS",
                        "LIBRARY",
                        "SAMPLE",
                        "READ_GROUP"
                    ]
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
                    "dockerPull": "quay.io/ncigdc/picard_metrics_sqlite:e71798322233d02d67db0158aeeef27990d2d400aadfc92c3687ba85555b0cf8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 10,
                    "tmpdirMax": 10,
                    "outdirMin": 10,
                    "outdirMax": 10
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
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
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
                        "glob": "$(inputs.job_uuid+\"_picard_CollectMultipleMetrics.log\")"
                    }
                },
                {
                    "id": "#picard_collectmultiplemetrics_to_sqlite.cwl/sqlite",
                    "format": "edam:format_3621",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".db\")"
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
                    "dockerPull": "quay.io/ncigdc/picard:092d034713aff237cf07ef28c22a46a113d1a59dc7ec6d71beb72295044a46f8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 10000,
                    "ramMax": 10000,
                    "tmpdirMin": 5,
                    "tmpdirMax": 5,
                    "outdirMin": 5,
                    "outdirMax": 5
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
                        "glob": "$(inputs.INPUT.basename + \".oxometrics\")"
                    }
                }
            ],
            "arguments": [
                {
                    "valueFrom": "$(inputs.INPUT.basename + \".oxometrics\")",
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
                    "dockerPull": "quay.io/ncigdc/picard_metrics_sqlite:e71798322233d02d67db0158aeeef27990d2d400aadfc92c3687ba85555b0cf8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 5,
                    "tmpdirMax": 5,
                    "outdirMin": 5,
                    "outdirMax": 5
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
                    "id": "#picard_collectoxogmetrics_to_sqlite.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
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
                        "glob": "$(inputs.job_uuid+\"_picard_CollectOxoGMetrics.log\")"
                    }
                },
                {
                    "id": "#picard_collectoxogmetrics_to_sqlite.cwl/sqlite",
                    "format": "edam:format_3621",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".db\")"
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
                    "dockerPull": "quay.io/ncigdc/picard:092d034713aff237cf07ef28c22a46a113d1a59dc7ec6d71beb72295044a46f8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 32768,
                    "ramMax": 32768,
                    "tmpdirMin": 1000,
                    "tmpdirMax": 1000,
                    "outdirMin": 1000,
                    "outdirMax": 1000
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/AMPLICON_INTERVALS",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "AMPLICON_INTERVALS=",
                        "position": 10,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/CUSTOM_AMPLICON_SET_NAME",
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "prefix": "CUSTOM_AMPLICON_SET_NAME=",
                        "position": 11,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/CLIP_OVERLAPPING_READS",
                    "type": "string",
                    "default": "true",
                    "inputBinding": {
                        "prefix": "CLIP_OVERLAPPING_READS=",
                        "position": 12,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/COVERAGE_CAP",
                    "type": "long",
                    "default": 200,
                    "inputBinding": {
                        "prefix": "COVERAGE_CAP=",
                        "position": 13,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/INPUT",
                    "type": "File",
                    "format": "edam:format_2572",
                    "inputBinding": {
                        "prefix": "INPUT=",
                        "position": 14,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/METRIC_ACCUMULATION_LEVEL",
                    "type": {
                        "type": "array",
                        "items": "string",
                        "inputBinding": {
                            "prefix": "METRIC_ACCUMULATION_LEVEL=",
                            "position": 15,
                            "separate": false
                        }
                    },
                    "default": [
                        "ALL_READS",
                        "LIBRARY",
                        "SAMPLE",
                        "READ_GROUP"
                    ]
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/MINIMUM_BASE_QUALITY",
                    "type": "long",
                    "default": 20,
                    "inputBinding": {
                        "prefix": "MINIMUM_BASE_QUALITY=",
                        "position": 16,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/MINIMUM_MAPPING_QUALITY",
                    "type": "long",
                    "default": 20,
                    "inputBinding": {
                        "prefix": "MINIMUM_MAPPING_QUALITY=",
                        "position": 17,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/NEAR_DISTANCE",
                    "type": "long",
                    "default": 250,
                    "inputBinding": {
                        "prefix": "NEAR_DISTANCE=",
                        "position": 18,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/OUTPUT",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "OUTPUT=",
                        "position": 19,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/PER_BASE_COVERAGE",
                    "type": [
                        "null",
                        "File"
                    ],
                    "inputBinding": {
                        "prefix": "PER_BASE_COVERAGE=",
                        "position": 20,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/PER_TARGET_COVERAGE",
                    "type": [
                        "null",
                        "File"
                    ],
                    "inputBinding": {
                        "prefix": "PER_TARGET_COVERAGE=",
                        "position": 21,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/REFERENCE_SEQUENCE",
                    "type": "File",
                    "format": "edam:format_1929",
                    "inputBinding": {
                        "prefix": "REFERENCE_SEQUENCE=",
                        "position": 22,
                        "separate": false
                    },
                    "secondaryFiles": [
                        ".fai"
                    ]
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/SAMPLE_SIZE",
                    "type": "long",
                    "default": 10000,
                    "inputBinding": {
                        "prefix": "SAMPLE_SIZE=",
                        "position": 23,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/TARGET_INTERVALS",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "TARGET_INTERVALS=",
                        "position": 24,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/VALIDATION_STRINGENCY",
                    "default": "STRICT",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "VALIDATION_STRINGENCY=",
                        "position": 25,
                        "separate": false
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/java_xmx",
                    "default": "32G",
                    "type": "string",
                    "inputBinding": {
                        "position": -10,
                        "prefix": "-Xmx",
                        "separate": false
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#picard_collecttargetedpcrmetrics.cwl/METRIC_OUTPUT",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.OUTPUT)"
                    }
                }
            ],
            "arguments": [
                {
                    "valueFrom": "-jar",
                    "position": -9
                },
                {
                    "valueFrom": "/usr/local/bin/picard.jar",
                    "position": -8
                },
                {
                    "valueFrom": "CollectTargetedPcrMetrics",
                    "position": -7
                }
            ],
            "baseCommand": [
                "java"
            ],
            "id": "#picard_collecttargetedpcrmetrics.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/picard_metrics_sqlite:e71798322233d02d67db0158aeeef27990d2d400aadfc92c3687ba85555b0cf8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 10,
                    "tmpdirMax": 10,
                    "outdirMin": 10,
                    "outdirMax": 10
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#picard_collecttargetedpcrmetrics_to_sqlite.cwl/bam",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--bam"
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics_to_sqlite.cwl/input_state",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--input_state"
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics_to_sqlite.cwl/metric_path",
                    "type": "File",
                    "inputBinding": {
                        "prefix": "--metric_path"
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics_to_sqlite.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#picard_collecttargetedpcrmetrics_to_sqlite.cwl/log",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid+\"_picard_CollectTargetedPcrMetrics.log\")"
                    }
                },
                {
                    "id": "#picard_collecttargetedpcrmetrics_to_sqlite.cwl/sqlite",
                    "format": "edam:format_3621",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".db\")"
                    }
                }
            ],
            "baseCommand": [
                "/usr/local/bin/picard_metrics_sqlite",
                "--metric_name",
                "CollectTargetedPcrMetrics"
            ],
            "id": "#picard_collecttargetedpcrmetrics_to_sqlite.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/picard:092d034713aff237cf07ef28c22a46a113d1a59dc7ec6d71beb72295044a46f8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 10000,
                    "ramMax": 10000,
                    "tmpdirMin": 10,
                    "tmpdirMax": 10,
                    "outdirMin": 10,
                    "outdirMax": 10
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
                    "dockerPull": "quay.io/ncigdc/picard_metrics_sqlite:e71798322233d02d67db0158aeeef27990d2d400aadfc92c3687ba85555b0cf8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 10,
                    "tmpdirMax": 10,
                    "outdirMin": 10,
                    "outdirMax": 10
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
                    "id": "#picard_collectwgsmetrics_to_sqlite.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#picard_collectwgsmetrics_to_sqlite.cwl/log",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid+\"_picard_CollectWgsMetrics.log\")"
                    }
                },
                {
                    "id": "#picard_collectwgsmetrics_to_sqlite.cwl/sqlite",
                    "format": "edam:format_3621",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".db\")"
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
                    "dockerPull": "quay.io/ncigdc/picard:092d034713aff237cf07ef28c22a46a113d1a59dc7ec6d71beb72295044a46f8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 15000,
                    "ramMax": 15000,
                    "tmpdirMin": "$(Math.ceil(1.1 * inputs.INPUT.size / 1048576))",
                    "tmpdirMax": "$(Math.ceil(1.1 * inputs.INPUT.size / 1048576))",
                    "outdirMin": "$(Math.ceil(1.1 * inputs.INPUT.size / 1048576))",
                    "outdirMax": "$(Math.ceil(1.1 * inputs.INPUT.size / 1048576))"
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
                    "dockerPull": "quay.io/ncigdc/picard_metrics_sqlite:e71798322233d02d67db0158aeeef27990d2d400aadfc92c3687ba85555b0cf8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 1,
                    "tmpdirMax": 1,
                    "outdirMin": 1,
                    "outdirMax": 1
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
                    "id": "#picard_markduplicates_to_sqlite.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#picard_markduplicates_to_sqlite.cwl/log",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid+\"_picard_MarkDuplicates.log\")"
                    }
                },
                {
                    "id": "#picard_markduplicates_to_sqlite.cwl/sqlite",
                    "format": "edam:format_3621",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".db\")"
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
                    "dockerPull": "quay.io/ncigdc/picard:092d034713aff237cf07ef28c22a46a113d1a59dc7ec6d71beb72295044a46f8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 10000,
                    "ramMax": 10000,
                    "tmpdirMin": "${\nvar req_space = 0;\nfor (var i = 0; i < inputs.INPUT.length; i++) {\n  for (var j = 0; j < inputs.INPUT[i].length; j++) {\n    req_space += inputs.INPUT[i][j].size;\n  }\n}\nreturn Math.ceil(2 * req_space / 1048576);\n}      \n",
                    "tmpdirMax": "${\nvar req_space = 0;\nfor (var i = 0; i < inputs.INPUT.length; i++) {\n  for (var j = 0; j < inputs.INPUT[i].length; j++) {\n    req_space += inputs.INPUT[i][j].size;\n  }\n}\nreturn Math.ceil(2 * req_space / 1048576);\n}      \n",
                    "outdirMin": "${\nvar req_space = 0;\nfor (var i = 0; i < inputs.INPUT.length; i++) {\n  for (var j = 0; j < inputs.INPUT[i].length; j++) {\n    req_space += inputs.INPUT[i][j].size;\n  }\n}\nreturn Math.ceil(2 * req_space / 1048576);\n}      \n",
                    "outdirMax": "${\nvar req_space = 0;\nfor (var i = 0; i < inputs.INPUT.length; i++) {\n  for (var j = 0; j < inputs.INPUT[i].length; j++) {\n    req_space += inputs.INPUT[i][j].size;\n  }\n}\nreturn Math.ceil(2 * req_space / 1048576);\n}      \n"
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#picard_mergesamfiles_aoa.cwl/ASSUME_SORTED",
                    "type": "boolean",
                    "default": false,
                    "inputBinding": {
                        "prefix": "ASSUME_SORTED=",
                        "separate": false
                    }
                },
                {
                    "id": "#picard_mergesamfiles_aoa.cwl/CREATE_INDEX",
                    "type": "string",
                    "default": "true",
                    "inputBinding": {
                        "prefix": "CREATE_INDEX=",
                        "separate": false
                    }
                },
                {
                    "id": "#picard_mergesamfiles_aoa.cwl/INPUT",
                    "format": "edam:format_2572",
                    "type": {
                        "type": "array",
                        "items": {
                            "type": "array",
                            "items": "File"
                        }
                    }
                },
                {
                    "id": "#picard_mergesamfiles_aoa.cwl/INTERVALS",
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
                    "id": "#picard_mergesamfiles_aoa.cwl/MERGE_SEQUENCE_DICTIONARIES",
                    "type": "string",
                    "default": "false",
                    "inputBinding": {
                        "prefix": "MERGE_SEQUENCE_DICTIONARIES=",
                        "separate": false
                    }
                },
                {
                    "id": "#picard_mergesamfiles_aoa.cwl/OUTPUT",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "OUTPUT=",
                        "separate": false
                    }
                },
                {
                    "id": "#picard_mergesamfiles_aoa.cwl/SORT_ORDER",
                    "type": "string",
                    "default": "coordinate",
                    "inputBinding": {
                        "prefix": "SORT_ORDER=",
                        "separate": false
                    }
                },
                {
                    "id": "#picard_mergesamfiles_aoa.cwl/TMP_DIR",
                    "type": "string",
                    "default": ".",
                    "inputBinding": {
                        "prefix": "TMP_DIR=",
                        "separate": false
                    }
                },
                {
                    "id": "#picard_mergesamfiles_aoa.cwl/USE_THREADING",
                    "type": "string",
                    "default": "true",
                    "inputBinding": {
                        "prefix": "USE_THREADING=",
                        "separate": false
                    }
                },
                {
                    "id": "#picard_mergesamfiles_aoa.cwl/VALIDATION_STRINGENCY",
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
                    "id": "#picard_mergesamfiles_aoa.cwl/MERGED_OUTPUT",
                    "format": "edam:format_2572",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.OUTPUT)"
                    }
                }
            ],
            "arguments": [
                {
                    "valueFrom": "${\n  var cmd = [\"java\", \"-jar\", \"/usr/local/bin/picard.jar\", \"MergeSamFiles\"];\n  var input_array = [];\n  for (var i = 0; i < inputs.INPUT.length; i++) {\n    for (var j = 0; j < inputs.INPUT[i].length; j++) {\n      var filesize = inputs.INPUT[i][j].size;\n      if (filesize > 0) {\n        input_array.push(\"INPUT=\" + inputs.INPUT[i][j].path);\n      }\n    }\n  }\n\n  if (input_array.length == 0) {\n    var cmd = ['/usr/bin/touch', inputs.OUTPUT];\n    return cmd;\n  }\n  else {\n    var run_cmd = cmd.concat(input_array);\n    return run_cmd;\n  }\n}\n"
                }
            ],
            "baseCommand": [],
            "id": "#picard_mergesamfiles_aoa.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/picard:092d034713aff237cf07ef28c22a46a113d1a59dc7ec6d71beb72295044a46f8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 5000,
                    "ramMax": 5000,
                    "tmpdirMin": 1000,
                    "tmpdirMax": 1000,
                    "outdirMin": 1000,
                    "outdirMax": 1000
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
                    "type": "long",
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
                    "dockerPull": "quay.io/ncigdc/picard_metrics_sqlite:e71798322233d02d67db0158aeeef27990d2d400aadfc92c3687ba85555b0cf8"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 1,
                    "tmpdirMax": 1,
                    "outdirMin": 1,
                    "outdirMax": 1
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
                    "id": "#picard_validatesamfile_to_sqlite.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#picard_validatesamfile_to_sqlite.cwl/log",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid+\"_picard_ValidateSamFile.log\")"
                    }
                },
                {
                    "id": "#picard_validatesamfile_to_sqlite.cwl/sqlite",
                    "format": "edam:format_3621",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".db\")"
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
                    "dockerPull": "quay.io/ncigdc/readgroup_json_db:d1c36c48491afa45c76c23624ecf69b37b4f276019cb6e168364f564452e5b37"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 1,
                    "tmpdirMax": 1,
                    "outdirMin": 1,
                    "outdirMax": 1
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
                    "id": "#readgroup_json_db.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#readgroup_json_db.cwl/log",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid +\".log\")"
                    }
                },
                {
                    "id": "#readgroup_json_db.cwl/output_sqlite",
                    "type": "File",
                    "format": "edam:format_3621",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".db\")"
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
                    "dockerPull": "quay.io/ncigdc/samtools:147bd4cc606a63c7435907d97fea6e94e9ea9ed58c18f390cab8bc40b1992df7"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 5000,
                    "ramMax": 5000,
                    "tmpdirMin": 5,
                    "tmpdirMax": 5,
                    "outdirMin": 5,
                    "outdirMax": 5
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
                    "dockerPull": "quay.io/ncigdc/samtools_metrics_sqlite:f64466282ce61dfc9251e7c32c5130928abf0a68c1f8e00b47d9709c5b3e3321"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 2000,
                    "ramMax": 2000,
                    "tmpdirMin": 5,
                    "tmpdirMax": 5,
                    "outdirMin": 5,
                    "outdirMax": 5
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
                    "id": "#samtools_flagstat_to_sqlite.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#samtools_flagstat_to_sqlite.cwl/log",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid+\"_samtools_flagstat.log\")"
                    }
                },
                {
                    "id": "#samtools_flagstat_to_sqlite.cwl/sqlite",
                    "format": "edam:format_3621",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".db\")"
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
                    "dockerPull": "quay.io/ncigdc/samtools:147bd4cc606a63c7435907d97fea6e94e9ea9ed58c18f390cab8bc40b1992df7"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 5000,
                    "ramMax": 5000,
                    "tmpdirMin": 5,
                    "tmpdirMax": 5,
                    "outdirMin": 5,
                    "outdirMax": 5
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
                    "dockerPull": "quay.io/ncigdc/samtools_metrics_sqlite:f64466282ce61dfc9251e7c32c5130928abf0a68c1f8e00b47d9709c5b3e3321"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 5,
                    "tmpdirMax": 5,
                    "outdirMin": 5,
                    "outdirMax": 5
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
                    "id": "#samtools_idxstats_to_sqlite.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#samtools_idxstats_to_sqlite.cwl/log",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid+\"_samtools_idxstats.log\")"
                    }
                },
                {
                    "id": "#samtools_idxstats_to_sqlite.cwl/sqlite",
                    "format": "edam:format_3621",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".db\")"
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
                    "dockerPull": "quay.io/ncigdc/samtools:147bd4cc606a63c7435907d97fea6e94e9ea9ed58c18f390cab8bc40b1992df7"
                },
                {
                    "class": "InitialWorkDirRequirement",
                    "listing": [
                        {
                            "entryname": "$(inputs.input.basename)",
                            "entry": "$(inputs.input)"
                        }
                    ]
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 5000,
                    "ramMax": 5000,
                    "tmpdirMin": 50,
                    "tmpdirMax": 50,
                    "outdirMin": 50,
                    "outdirMax": 50
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#samtools_index.cwl/input",
                    "type": "File",
                    "format": "edam:format_2572"
                },
                {
                    "id": "#samtools_index.cwl/thread_count",
                    "type": "long",
                    "inputBinding": {
                        "prefix": "-@",
                        "position": 0
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#samtools_index.cwl/output",
                    "type": "File",
                    "format": "edam:format_2572",
                    "outputBinding": {
                        "glob": "$(inputs.input.basename)"
                    },
                    "secondaryFiles": [
                        "^.bai"
                    ]
                }
            ],
            "arguments": [
                {
                    "valueFrom": "$(inputs.input.basename)",
                    "position": 1
                },
                {
                    "valueFrom": "$(inputs.input.nameroot + \".bai\")",
                    "position": 2
                }
            ],
            "baseCommand": [
                "/usr/local/bin/samtools",
                "index"
            ],
            "id": "#samtools_index.cwl"
        },
        {
            "requirements": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "quay.io/ncigdc/samtools:147bd4cc606a63c7435907d97fea6e94e9ea9ed58c18f390cab8bc40b1992df7"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 5000,
                    "ramMax": 5000,
                    "tmpdirMin": 5,
                    "tmpdirMax": 5,
                    "outdirMin": 5,
                    "outdirMax": 5
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
                    "dockerPull": "quay.io/ncigdc/samtools_metrics_sqlite:f64466282ce61dfc9251e7c32c5130928abf0a68c1f8e00b47d9709c5b3e3321"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 5,
                    "tmpdirMax": 5,
                    "outdirMin": 5,
                    "outdirMax": 5
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
                    "id": "#samtools_stats_to_sqlite.cwl/job_uuid",
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--job_uuid"
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#samtools_stats_to_sqlite.cwl/log",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid+\"_samtools_stats.log\")"
                    }
                },
                {
                    "id": "#samtools_stats_to_sqlite.cwl/sqlite",
                    "format": "edam:format_3621",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.job_uuid + \".db\")"
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
                    "dockerPull": "ubuntu:bionic-20180426"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 1000,
                    "ramMax": 1000,
                    "tmpdirMin": 1,
                    "tmpdirMax": 1,
                    "outdirMin": 1,
                    "outdirMax": 1
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
                    "dockerPull": "ubuntu:bionic-20180426"
                },
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "coresMax": 1,
                    "ramMin": 250,
                    "ramMax": 250,
                    "tmpdirMin": 1,
                    "tmpdirMax": 1,
                    "outdirMin": 1,
                    "outdirMax": 1
                }
            ],
            "class": "CommandLineTool",
            "inputs": [
                {
                    "id": "#touch.cwl/input",
                    "type": "string",
                    "inputBinding": {
                        "position": 0
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#touch.cwl/output",
                    "type": "File",
                    "outputBinding": {
                        "glob": "$(inputs.input)"
                    }
                }
            ],
            "baseCommand": [
                "touch"
            ],
            "id": "#touch.cwl"
        },
        {
            "class": "Workflow",
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "name": "#amplicon_kit.yml/amplicon_kit_set_file",
                            "type": "record",
                            "fields": [
                                {
                                    "name": "#amplicon_kit.yml/amplicon_kit_set_file/amplicon_kit_amplicon_file",
                                    "type": "File"
                                },
                                {
                                    "name": "#amplicon_kit.yml/amplicon_kit_set_file/amplicon_kit_target_file",
                                    "type": "File"
                                }
                            ]
                        },
                        {
                            "name": "#amplicon_kit.yml/amplicon_kit_set_uuid",
                            "type": "record",
                            "fields": [
                                {
                                    "name": "#amplicon_kit.yml/amplicon_kit_set_uuid/amplicon_kit_amplicon_uuid",
                                    "type": "string"
                                },
                                {
                                    "name": "#amplicon_kit.yml/amplicon_kit_set_uuid/amplicon_kit_amplicon_file_size",
                                    "type": "long"
                                },
                                {
                                    "name": "#amplicon_kit.yml/amplicon_kit_set_uuid/amplicon_kit_target_uuid",
                                    "type": "string"
                                },
                                {
                                    "name": "#amplicon_kit.yml/amplicon_kit_set_uuid/amplicon_kit_target_file_size",
                                    "type": "long"
                                }
                            ]
                        }
                    ]
                }
            ],
            "inputs": [
                {
                    "id": "#amplicon_metrics.cwl/bam",
                    "type": "File"
                },
                {
                    "id": "#amplicon_metrics.cwl/amplicon_kit_set_file",
                    "type": "#amplicon_kit.yml/amplicon_kit_set_file"
                },
                {
                    "id": "#amplicon_metrics.cwl/fasta",
                    "type": "File",
                    "secondaryFiles": [
                        ".amb",
                        ".ann",
                        ".bwt",
                        ".fai",
                        ".pac",
                        ".sa",
                        "^.dict"
                    ]
                },
                {
                    "id": "#amplicon_metrics.cwl/input_state",
                    "type": "string"
                },
                {
                    "id": "#amplicon_metrics.cwl/job_uuid",
                    "type": "string"
                }
            ],
            "outputs": [
                {
                    "id": "#amplicon_metrics.cwl/sqlite",
                    "type": "File",
                    "outputSource": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics_to_sqlite/sqlite"
                }
            ],
            "steps": [
                {
                    "id": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics",
                    "run": "#picard_collecttargetedpcrmetrics.cwl",
                    "in": [
                        {
                            "id": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics/AMPLICON_INTERVALS",
                            "source": "#amplicon_metrics.cwl/amplicon_kit_set_file",
                            "valueFrom": "$(self.amplicon_kit_amplicon_file)"
                        },
                        {
                            "id": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics/INPUT",
                            "source": "#amplicon_metrics.cwl/bam"
                        },
                        {
                            "id": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics/OUTPUT",
                            "source": "#amplicon_metrics.cwl/bam",
                            "valueFrom": "$(self.basename).pcrmetrics"
                        },
                        {
                            "id": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics/REFERENCE_SEQUENCE",
                            "source": "#amplicon_metrics.cwl/fasta"
                        },
                        {
                            "id": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics/TARGET_INTERVALS",
                            "source": "#amplicon_metrics.cwl/amplicon_kit_set_file",
                            "valueFrom": "$(self.amplicon_kit_target_file)"
                        }
                    ],
                    "out": [
                        {
                            "id": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics/METRIC_OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics_to_sqlite",
                    "run": "#picard_collecttargetedpcrmetrics_to_sqlite.cwl",
                    "in": [
                        {
                            "id": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics_to_sqlite/bam",
                            "source": "#amplicon_metrics.cwl/bam",
                            "valueFrom": "$(self.basename)"
                        },
                        {
                            "id": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics_to_sqlite/input_state",
                            "source": "#amplicon_metrics.cwl/input_state"
                        },
                        {
                            "id": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics_to_sqlite/metric_path",
                            "source": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics/METRIC_OUTPUT"
                        },
                        {
                            "id": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics_to_sqlite/job_uuid",
                            "source": "#amplicon_metrics.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics_to_sqlite/log"
                        },
                        {
                            "id": "#amplicon_metrics.cwl/picard_collecttargetedpcrmetrics_to_sqlite/sqlite"
                        }
                    ]
                }
            ],
            "id": "#amplicon_metrics.cwl"
        },
        {
            "class": "Workflow",
            "requirements": [
                {
                    "class": "ScatterFeatureRequirement"
                },
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#readgroup.yml/readgroup_meta"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_uuid"
                        }
                    ]
                },
                {
                    "class": "StepInputExpressionRequirement"
                }
            ],
            "inputs": [
                {
                    "id": "#bwa_pe.cwl/job_uuid",
                    "type": "string"
                },
                {
                    "id": "#bwa_pe.cwl/reference_sequence",
                    "type": "File",
                    "secondaryFiles": [
                        ".amb",
                        ".ann",
                        ".bwt",
                        ".fai",
                        ".pac",
                        ".sa",
                        "^.dict"
                    ]
                },
                {
                    "id": "#bwa_pe.cwl/readgroup_fastq_pe",
                    "type": "#readgroup.yml/readgroup_fastq_pe_file"
                },
                {
                    "id": "#bwa_pe.cwl/thread_count",
                    "type": "long"
                }
            ],
            "outputs": [
                {
                    "id": "#bwa_pe.cwl/bam",
                    "type": "File",
                    "outputSource": "#bwa_pe.cwl/bwa_pe/OUTPUT"
                },
                {
                    "id": "#bwa_pe.cwl/sqlite",
                    "type": "File",
                    "outputSource": "#bwa_pe.cwl/merge_sqlite/destination_sqlite"
                }
            ],
            "steps": [
                {
                    "id": "#bwa_pe.cwl/fastqc1",
                    "run": "#fastqc.cwl",
                    "in": [
                        {
                            "id": "#bwa_pe.cwl/fastqc1/INPUT",
                            "source": "#bwa_pe.cwl/readgroup_fastq_pe",
                            "valueFrom": "$(self.forward_fastq)"
                        },
                        {
                            "id": "#bwa_pe.cwl/fastqc1/threads",
                            "source": "#bwa_pe.cwl/thread_count"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_pe.cwl/fastqc1/OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#bwa_pe.cwl/fastqc2",
                    "run": "#fastqc.cwl",
                    "in": [
                        {
                            "id": "#bwa_pe.cwl/fastqc2/INPUT",
                            "source": "#bwa_pe.cwl/readgroup_fastq_pe",
                            "valueFrom": "$(self.reverse_fastq)"
                        },
                        {
                            "id": "#bwa_pe.cwl/fastqc2/threads",
                            "source": "#bwa_pe.cwl/thread_count"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_pe.cwl/fastqc2/OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#bwa_pe.cwl/fastqc_db1",
                    "run": "#fastqc_db.cwl",
                    "in": [
                        {
                            "id": "#bwa_pe.cwl/fastqc_db1/INPUT",
                            "source": "#bwa_pe.cwl/fastqc1/OUTPUT"
                        },
                        {
                            "id": "#bwa_pe.cwl/fastqc_db1/job_uuid",
                            "source": "#bwa_pe.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_pe.cwl/fastqc_db1/LOG"
                        },
                        {
                            "id": "#bwa_pe.cwl/fastqc_db1/OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#bwa_pe.cwl/fastqc_db2",
                    "run": "#fastqc_db.cwl",
                    "in": [
                        {
                            "id": "#bwa_pe.cwl/fastqc_db2/INPUT",
                            "source": "#bwa_pe.cwl/fastqc2/OUTPUT"
                        },
                        {
                            "id": "#bwa_pe.cwl/fastqc_db2/job_uuid",
                            "source": "#bwa_pe.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_pe.cwl/fastqc_db2/LOG"
                        },
                        {
                            "id": "#bwa_pe.cwl/fastqc_db2/OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#bwa_pe.cwl/fastqc_basicstats_json",
                    "run": "#fastqc_basicstatistics_json.cwl",
                    "in": [
                        {
                            "id": "#bwa_pe.cwl/fastqc_basicstats_json/sqlite_path",
                            "source": "#bwa_pe.cwl/fastqc_db1/OUTPUT"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_pe.cwl/fastqc_basicstats_json/OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#bwa_pe.cwl/bwa_pe",
                    "run": "#bwa_record_pe.cwl",
                    "in": [
                        {
                            "id": "#bwa_pe.cwl/bwa_pe/fasta",
                            "source": "#bwa_pe.cwl/reference_sequence"
                        },
                        {
                            "id": "#bwa_pe.cwl/bwa_pe/fastq1",
                            "source": "#bwa_pe.cwl/readgroup_fastq_pe",
                            "valueFrom": "$(self.forward_fastq)"
                        },
                        {
                            "id": "#bwa_pe.cwl/bwa_pe/fastq2",
                            "source": "#bwa_pe.cwl/readgroup_fastq_pe",
                            "valueFrom": "$(self.reverse_fastq)"
                        },
                        {
                            "id": "#bwa_pe.cwl/bwa_pe/fastqc_json_path",
                            "source": "#bwa_pe.cwl/fastqc_basicstats_json/OUTPUT"
                        },
                        {
                            "id": "#bwa_pe.cwl/bwa_pe/readgroup_meta",
                            "source": "#bwa_pe.cwl/readgroup_fastq_pe",
                            "valueFrom": "$(self.readgroup_meta)"
                        },
                        {
                            "id": "#bwa_pe.cwl/bwa_pe/thread_count",
                            "source": "#bwa_pe.cwl/thread_count"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_pe.cwl/bwa_pe/OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#bwa_pe.cwl/bam_readgroup_to_json",
                    "run": "#bam_readgroup_to_json.cwl",
                    "in": [
                        {
                            "id": "#bwa_pe.cwl/bam_readgroup_to_json/INPUT",
                            "source": "#bwa_pe.cwl/bwa_pe/OUTPUT"
                        },
                        {
                            "id": "#bwa_pe.cwl/bam_readgroup_to_json/MODE",
                            "valueFrom": "lenient"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_pe.cwl/bam_readgroup_to_json/OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#bwa_pe.cwl/readgroup_json_db",
                    "run": "#readgroup_json_db.cwl",
                    "scatter": "#bwa_pe.cwl/readgroup_json_db/json_path",
                    "in": [
                        {
                            "id": "#bwa_pe.cwl/readgroup_json_db/json_path",
                            "source": "#bwa_pe.cwl/bam_readgroup_to_json/OUTPUT"
                        },
                        {
                            "id": "#bwa_pe.cwl/readgroup_json_db/job_uuid",
                            "source": "#bwa_pe.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_pe.cwl/readgroup_json_db/log"
                        },
                        {
                            "id": "#bwa_pe.cwl/readgroup_json_db/output_sqlite"
                        }
                    ]
                },
                {
                    "id": "#bwa_pe.cwl/merge_readgroup_json_db",
                    "run": "#merge_sqlite.cwl",
                    "in": [
                        {
                            "id": "#bwa_pe.cwl/merge_readgroup_json_db/source_sqlite",
                            "source": "#bwa_pe.cwl/readgroup_json_db/output_sqlite"
                        },
                        {
                            "id": "#bwa_pe.cwl/merge_readgroup_json_db/job_uuid",
                            "source": "#bwa_pe.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_pe.cwl/merge_readgroup_json_db/destination_sqlite"
                        }
                    ]
                },
                {
                    "id": "#bwa_pe.cwl/merge_sqlite",
                    "run": "#merge_sqlite.cwl",
                    "in": [
                        {
                            "id": "#bwa_pe.cwl/merge_sqlite/source_sqlite",
                            "source": [
                                "#bwa_pe.cwl/fastqc_db1/OUTPUT",
                                "#bwa_pe.cwl/fastqc_db2/OUTPUT",
                                "#bwa_pe.cwl/merge_readgroup_json_db/destination_sqlite"
                            ]
                        },
                        {
                            "id": "#bwa_pe.cwl/merge_sqlite/job_uuid",
                            "source": "#bwa_pe.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_pe.cwl/merge_sqlite/destination_sqlite"
                        },
                        {
                            "id": "#bwa_pe.cwl/merge_sqlite/log"
                        }
                    ]
                }
            ],
            "id": "#bwa_pe.cwl"
        },
        {
            "class": "Workflow",
            "requirements": [
                {
                    "class": "ScatterFeatureRequirement"
                },
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#readgroup.yml/readgroup_meta"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_uuid"
                        }
                    ]
                },
                {
                    "class": "StepInputExpressionRequirement"
                }
            ],
            "inputs": [
                {
                    "id": "#bwa_se.cwl/job_uuid",
                    "type": "string"
                },
                {
                    "id": "#bwa_se.cwl/reference_sequence",
                    "type": "File",
                    "secondaryFiles": [
                        ".amb",
                        ".ann",
                        ".bwt",
                        ".fai",
                        ".pac",
                        ".sa",
                        "^.dict"
                    ]
                },
                {
                    "id": "#bwa_se.cwl/readgroup_fastq_se",
                    "type": "#readgroup.yml/readgroup_fastq_se_file"
                },
                {
                    "id": "#bwa_se.cwl/thread_count",
                    "type": "long"
                }
            ],
            "outputs": [
                {
                    "id": "#bwa_se.cwl/bam",
                    "type": "File",
                    "outputSource": "#bwa_se.cwl/bwa_se/OUTPUT"
                },
                {
                    "id": "#bwa_se.cwl/sqlite",
                    "type": "File",
                    "outputSource": "#bwa_se.cwl/merge_sqlite/destination_sqlite"
                }
            ],
            "steps": [
                {
                    "id": "#bwa_se.cwl/fastqc",
                    "run": "#fastqc.cwl",
                    "in": [
                        {
                            "id": "#bwa_se.cwl/fastqc/INPUT",
                            "source": "#bwa_se.cwl/readgroup_fastq_se",
                            "valueFrom": "$(self.fastq)"
                        },
                        {
                            "id": "#bwa_se.cwl/fastqc/threads",
                            "source": "#bwa_se.cwl/thread_count"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_se.cwl/fastqc/OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#bwa_se.cwl/fastqc_db",
                    "run": "#fastqc_db.cwl",
                    "in": [
                        {
                            "id": "#bwa_se.cwl/fastqc_db/INPUT",
                            "source": "#bwa_se.cwl/fastqc/OUTPUT"
                        },
                        {
                            "id": "#bwa_se.cwl/fastqc_db/job_uuid",
                            "source": "#bwa_se.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_se.cwl/fastqc_db/LOG"
                        },
                        {
                            "id": "#bwa_se.cwl/fastqc_db/OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#bwa_se.cwl/fastqc_basicstats_json",
                    "run": "#fastqc_basicstatistics_json.cwl",
                    "in": [
                        {
                            "id": "#bwa_se.cwl/fastqc_basicstats_json/sqlite_path",
                            "source": "#bwa_se.cwl/fastqc_db/OUTPUT"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_se.cwl/fastqc_basicstats_json/OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#bwa_se.cwl/bwa_se",
                    "run": "#bwa_record_se.cwl",
                    "in": [
                        {
                            "id": "#bwa_se.cwl/bwa_se/fasta",
                            "source": "#bwa_se.cwl/reference_sequence"
                        },
                        {
                            "id": "#bwa_se.cwl/bwa_se/fastq",
                            "source": "#bwa_se.cwl/readgroup_fastq_se",
                            "valueFrom": "$(self.fastq)"
                        },
                        {
                            "id": "#bwa_se.cwl/bwa_se/fastqc_json_path",
                            "source": "#bwa_se.cwl/fastqc_basicstats_json/OUTPUT"
                        },
                        {
                            "id": "#bwa_se.cwl/bwa_se/readgroup_meta",
                            "source": "#bwa_se.cwl/readgroup_fastq_se",
                            "valueFrom": "$(self.readgroup_meta)"
                        },
                        {
                            "id": "#bwa_se.cwl/bwa_se/thread_count",
                            "source": "#bwa_se.cwl/thread_count"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_se.cwl/bwa_se/OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#bwa_se.cwl/bam_readgroup_to_json",
                    "run": "#bam_readgroup_to_json.cwl",
                    "in": [
                        {
                            "id": "#bwa_se.cwl/bam_readgroup_to_json/INPUT",
                            "source": "#bwa_se.cwl/bwa_se/OUTPUT"
                        },
                        {
                            "id": "#bwa_se.cwl/bam_readgroup_to_json/MODE",
                            "valueFrom": "lenient"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_se.cwl/bam_readgroup_to_json/OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#bwa_se.cwl/readgroup_json_db",
                    "run": "#readgroup_json_db.cwl",
                    "scatter": "#bwa_se.cwl/readgroup_json_db/json_path",
                    "in": [
                        {
                            "id": "#bwa_se.cwl/readgroup_json_db/json_path",
                            "source": "#bwa_se.cwl/bam_readgroup_to_json/OUTPUT"
                        },
                        {
                            "id": "#bwa_se.cwl/readgroup_json_db/job_uuid",
                            "source": "#bwa_se.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_se.cwl/readgroup_json_db/log"
                        },
                        {
                            "id": "#bwa_se.cwl/readgroup_json_db/output_sqlite"
                        }
                    ]
                },
                {
                    "id": "#bwa_se.cwl/merge_readgroup_json_db",
                    "run": "#merge_sqlite.cwl",
                    "in": [
                        {
                            "id": "#bwa_se.cwl/merge_readgroup_json_db/source_sqlite",
                            "source": "#bwa_se.cwl/readgroup_json_db/output_sqlite"
                        },
                        {
                            "id": "#bwa_se.cwl/merge_readgroup_json_db/job_uuid",
                            "source": "#bwa_se.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_se.cwl/merge_readgroup_json_db/destination_sqlite"
                        }
                    ]
                },
                {
                    "id": "#bwa_se.cwl/merge_sqlite",
                    "run": "#merge_sqlite.cwl",
                    "in": [
                        {
                            "id": "#bwa_se.cwl/merge_sqlite/source_sqlite",
                            "source": [
                                "#bwa_se.cwl/fastqc_db/OUTPUT",
                                "#bwa_se.cwl/merge_readgroup_json_db/destination_sqlite"
                            ]
                        },
                        {
                            "id": "#bwa_se.cwl/merge_sqlite/job_uuid",
                            "source": "#bwa_se.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#bwa_se.cwl/merge_sqlite/destination_sqlite"
                        },
                        {
                            "id": "#bwa_se.cwl/merge_sqlite/log"
                        }
                    ]
                }
            ],
            "id": "#bwa_se.cwl"
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
                    "id": "#conditional_bamindex.cwl/bam",
                    "type": "File"
                },
                {
                    "id": "#conditional_bamindex.cwl/thread_count",
                    "type": "long"
                }
            ],
            "outputs": [
                {
                    "id": "#conditional_bamindex.cwl/output",
                    "type": "File",
                    "outputSource": "#conditional_bamindex.cwl/samtools_index/output"
                },
                {
                    "id": "#conditional_bamindex.cwl/sqlite",
                    "type": "File",
                    "outputSource": "#conditional_bamindex.cwl/format_sqlite/output"
                }
            ],
            "steps": [
                {
                    "id": "#conditional_bamindex.cwl/samtools_index",
                    "run": "#samtools_index.cwl",
                    "in": [
                        {
                            "id": "#conditional_bamindex.cwl/samtools_index/input",
                            "source": "#conditional_bamindex.cwl/bam"
                        },
                        {
                            "id": "#conditional_bamindex.cwl/samtools_index/thread_count",
                            "source": "#conditional_bamindex.cwl/thread_count"
                        }
                    ],
                    "out": [
                        {
                            "id": "#conditional_bamindex.cwl/samtools_index/output"
                        }
                    ]
                },
                {
                    "id": "#conditional_bamindex.cwl/empty_sqlite",
                    "run": "#touch.cwl",
                    "in": [
                        {
                            "id": "#conditional_bamindex.cwl/empty_sqlite/input",
                            "valueFrom": "empty.sqlite"
                        }
                    ],
                    "out": [
                        {
                            "id": "#conditional_bamindex.cwl/empty_sqlite/output"
                        }
                    ]
                },
                {
                    "id": "#conditional_bamindex.cwl/format_sqlite",
                    "run": "#emit_file_format.cwl",
                    "in": [
                        {
                            "id": "#conditional_bamindex.cwl/format_sqlite/input",
                            "source": "#conditional_bamindex.cwl/empty_sqlite/output"
                        },
                        {
                            "id": "#conditional_bamindex.cwl/format_sqlite/format",
                            "valueFrom": "edam:format_2572"
                        }
                    ],
                    "out": [
                        {
                            "id": "#conditional_bamindex.cwl/format_sqlite/output"
                        }
                    ]
                }
            ],
            "id": "#conditional_bamindex.cwl"
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
                    "id": "#conditional_markduplicates.cwl/bam",
                    "type": "File"
                },
                {
                    "id": "#conditional_markduplicates.cwl/job_uuid",
                    "type": "string"
                }
            ],
            "outputs": [
                {
                    "id": "#conditional_markduplicates.cwl/output",
                    "type": "File",
                    "outputSource": "#conditional_markduplicates.cwl/picard_markduplicates/OUTPUT"
                },
                {
                    "id": "#conditional_markduplicates.cwl/sqlite",
                    "type": "File",
                    "outputSource": "#conditional_markduplicates.cwl/picard_markduplicates_to_sqlite/sqlite"
                }
            ],
            "steps": [
                {
                    "id": "#conditional_markduplicates.cwl/picard_markduplicates",
                    "run": "#picard_markduplicates.cwl",
                    "in": [
                        {
                            "id": "#conditional_markduplicates.cwl/picard_markduplicates/INPUT",
                            "source": "#conditional_markduplicates.cwl/bam"
                        }
                    ],
                    "out": [
                        {
                            "id": "#conditional_markduplicates.cwl/picard_markduplicates/OUTPUT"
                        },
                        {
                            "id": "#conditional_markduplicates.cwl/picard_markduplicates/METRICS"
                        }
                    ]
                },
                {
                    "id": "#conditional_markduplicates.cwl/picard_markduplicates_to_sqlite",
                    "run": "#picard_markduplicates_to_sqlite.cwl",
                    "in": [
                        {
                            "id": "#conditional_markduplicates.cwl/picard_markduplicates_to_sqlite/bam",
                            "source": "#conditional_markduplicates.cwl/bam",
                            "valueFrom": "$(self.basename)"
                        },
                        {
                            "id": "#conditional_markduplicates.cwl/picard_markduplicates_to_sqlite/input_state",
                            "valueFrom": "markduplicates_readgroups"
                        },
                        {
                            "id": "#conditional_markduplicates.cwl/picard_markduplicates_to_sqlite/metric_path",
                            "source": "#conditional_markduplicates.cwl/picard_markduplicates/METRICS"
                        },
                        {
                            "id": "#conditional_markduplicates.cwl/picard_markduplicates_to_sqlite/job_uuid",
                            "source": "#conditional_markduplicates.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#conditional_markduplicates.cwl/picard_markduplicates_to_sqlite/sqlite"
                        }
                    ]
                }
            ],
            "id": "#conditional_markduplicates.cwl"
        },
        {
            "class": "Workflow",
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "name": "#capture_kit.yml/capture_kit_set_file",
                            "type": "record",
                            "fields": [
                                {
                                    "name": "#capture_kit.yml/capture_kit_set_file/capture_kit_bait_file",
                                    "type": "File"
                                },
                                {
                                    "name": "#capture_kit.yml/capture_kit_set_file/capture_kit_target_file",
                                    "type": "File"
                                }
                            ]
                        },
                        {
                            "name": "#capture_kit.yml/capture_kit_set_uuid",
                            "type": "record",
                            "fields": [
                                {
                                    "name": "#capture_kit.yml/capture_kit_set_uuid/capture_kit_bait_uuid",
                                    "type": "string"
                                },
                                {
                                    "name": "#capture_kit.yml/capture_kit_set_uuid/capture_kit_bait_file_size",
                                    "type": "long"
                                },
                                {
                                    "name": "#capture_kit.yml/capture_kit_set_uuid/capture_kit_target_uuid",
                                    "type": "string"
                                },
                                {
                                    "name": "#capture_kit.yml/capture_kit_set_uuid/capture_kit_target_file_size",
                                    "type": "long"
                                }
                            ]
                        }
                    ]
                }
            ],
            "inputs": [
                {
                    "id": "#exome_metrics.cwl/bam",
                    "type": "File"
                },
                {
                    "id": "#exome_metrics.cwl/capture_kit_set_file",
                    "type": "#capture_kit.yml/capture_kit_set_file"
                },
                {
                    "id": "#exome_metrics.cwl/fasta",
                    "type": "File",
                    "secondaryFiles": [
                        ".amb",
                        ".ann",
                        ".bwt",
                        ".fai",
                        ".pac",
                        ".sa",
                        "^.dict"
                    ]
                },
                {
                    "id": "#exome_metrics.cwl/input_state",
                    "type": "string"
                },
                {
                    "id": "#exome_metrics.cwl/job_uuid",
                    "type": "string"
                }
            ],
            "outputs": [
                {
                    "id": "#exome_metrics.cwl/sqlite",
                    "type": "File",
                    "outputSource": "#exome_metrics.cwl/picard_collecthsmetrics_to_sqlite/sqlite"
                }
            ],
            "steps": [
                {
                    "id": "#exome_metrics.cwl/picard_collecthsmetrics",
                    "run": "#picard_collecthsmetrics.cwl",
                    "in": [
                        {
                            "id": "#exome_metrics.cwl/picard_collecthsmetrics/BAIT_INTERVALS",
                            "source": "#exome_metrics.cwl/capture_kit_set_file",
                            "valueFrom": "$(self.capture_kit_bait_file)"
                        },
                        {
                            "id": "#exome_metrics.cwl/picard_collecthsmetrics/INPUT",
                            "source": "#exome_metrics.cwl/bam"
                        },
                        {
                            "id": "#exome_metrics.cwl/picard_collecthsmetrics/OUTPUT",
                            "source": "#exome_metrics.cwl/bam",
                            "valueFrom": "$(self.basename).hsmetrics"
                        },
                        {
                            "id": "#exome_metrics.cwl/picard_collecthsmetrics/REFERENCE_SEQUENCE",
                            "source": "#exome_metrics.cwl/fasta"
                        },
                        {
                            "id": "#exome_metrics.cwl/picard_collecthsmetrics/TARGET_INTERVALS",
                            "source": "#exome_metrics.cwl/capture_kit_set_file",
                            "valueFrom": "$(self.capture_kit_target_file)"
                        }
                    ],
                    "out": [
                        {
                            "id": "#exome_metrics.cwl/picard_collecthsmetrics/METRIC_OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#exome_metrics.cwl/picard_collecthsmetrics_to_sqlite",
                    "run": "#picard_collecthsmetrics_to_sqlite.cwl",
                    "in": [
                        {
                            "id": "#exome_metrics.cwl/picard_collecthsmetrics_to_sqlite/bam",
                            "source": "#exome_metrics.cwl/bam",
                            "valueFrom": "$(self.basename)"
                        },
                        {
                            "id": "#exome_metrics.cwl/picard_collecthsmetrics_to_sqlite/input_state",
                            "source": "#exome_metrics.cwl/input_state"
                        },
                        {
                            "id": "#exome_metrics.cwl/picard_collecthsmetrics_to_sqlite/metric_path",
                            "source": "#exome_metrics.cwl/picard_collecthsmetrics/METRIC_OUTPUT"
                        },
                        {
                            "id": "#exome_metrics.cwl/picard_collecthsmetrics_to_sqlite/job_uuid",
                            "source": "#exome_metrics.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#exome_metrics.cwl/picard_collecthsmetrics_to_sqlite/log"
                        },
                        {
                            "id": "#exome_metrics.cwl/picard_collecthsmetrics_to_sqlite/sqlite"
                        }
                    ]
                }
            ],
            "id": "#exome_metrics.cwl"
        },
        {
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ScatterFeatureRequirement"
                },
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#readgroup.yml/readgroup_meta"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_uuid"
                        }
                    ]
                }
            ],
            "class": "Workflow",
            "inputs": [
                {
                    "id": "#fastq_clean_pe.cwl/input",
                    "type": "#readgroup.yml/readgroup_fastq_pe_file"
                },
                {
                    "id": "#fastq_clean_pe.cwl/job_uuid",
                    "type": "string"
                }
            ],
            "outputs": [
                {
                    "id": "#fastq_clean_pe.cwl/output",
                    "type": "#readgroup.yml/readgroup_fastq_pe_file",
                    "outputSource": "#fastq_clean_pe.cwl/emit_readgroup_fastq_pe_file/output"
                },
                {
                    "id": "#fastq_clean_pe.cwl/sqlite",
                    "type": "File",
                    "outputSource": "#fastq_clean_pe.cwl/json_to_sqlite/sqlite"
                }
            ],
            "steps": [
                {
                    "id": "#fastq_clean_pe.cwl/fastq_cleaner_pe",
                    "run": "#fastq_cleaner_pe.cwl",
                    "in": [
                        {
                            "id": "#fastq_clean_pe.cwl/fastq_cleaner_pe/fastq1",
                            "source": "#fastq_clean_pe.cwl/input",
                            "valueFrom": "$(self.forward_fastq)"
                        },
                        {
                            "id": "#fastq_clean_pe.cwl/fastq_cleaner_pe/fastq2",
                            "source": "#fastq_clean_pe.cwl/input",
                            "valueFrom": "$(self.reverse_fastq)"
                        }
                    ],
                    "out": [
                        {
                            "id": "#fastq_clean_pe.cwl/fastq_cleaner_pe/cleaned_fastq1"
                        },
                        {
                            "id": "#fastq_clean_pe.cwl/fastq_cleaner_pe/cleaned_fastq2"
                        },
                        {
                            "id": "#fastq_clean_pe.cwl/fastq_cleaner_pe/result_json"
                        }
                    ]
                },
                {
                    "id": "#fastq_clean_pe.cwl/emit_readgroup_fastq_pe_file",
                    "run": "#emit_readgroup_fastq_pe_file.cwl",
                    "in": [
                        {
                            "id": "#fastq_clean_pe.cwl/emit_readgroup_fastq_pe_file/forward_fastq",
                            "source": "#fastq_clean_pe.cwl/fastq_cleaner_pe/cleaned_fastq1"
                        },
                        {
                            "id": "#fastq_clean_pe.cwl/emit_readgroup_fastq_pe_file/reverse_fastq",
                            "source": "#fastq_clean_pe.cwl/fastq_cleaner_pe/cleaned_fastq2"
                        },
                        {
                            "id": "#fastq_clean_pe.cwl/emit_readgroup_fastq_pe_file/readgroup_meta",
                            "source": "#fastq_clean_pe.cwl/input",
                            "valueFrom": "$(self.readgroup_meta)"
                        }
                    ],
                    "out": [
                        {
                            "id": "#fastq_clean_pe.cwl/emit_readgroup_fastq_pe_file/output"
                        }
                    ]
                },
                {
                    "id": "#fastq_clean_pe.cwl/json_to_sqlite",
                    "run": "#json_to_sqlite.cwl",
                    "in": [
                        {
                            "id": "#fastq_clean_pe.cwl/json_to_sqlite/input_json",
                            "source": "#fastq_clean_pe.cwl/fastq_cleaner_pe/result_json"
                        },
                        {
                            "id": "#fastq_clean_pe.cwl/json_to_sqlite/job_uuid",
                            "source": "#fastq_clean_pe.cwl/job_uuid"
                        },
                        {
                            "id": "#fastq_clean_pe.cwl/json_to_sqlite/table_name",
                            "valueFrom": "fastq_cleaner_pe"
                        }
                    ],
                    "out": [
                        {
                            "id": "#fastq_clean_pe.cwl/json_to_sqlite/sqlite"
                        },
                        {
                            "id": "#fastq_clean_pe.cwl/json_to_sqlite/log"
                        }
                    ]
                }
            ],
            "id": "#fastq_clean_pe.cwl"
        },
        {
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "class": "ScatterFeatureRequirement"
                },
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#readgroup.yml/readgroup_meta"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_uuid"
                        }
                    ]
                }
            ],
            "class": "Workflow",
            "inputs": [
                {
                    "id": "#fastq_clean_se.cwl/input",
                    "type": "#readgroup.yml/readgroup_fastq_se_file"
                },
                {
                    "id": "#fastq_clean_se.cwl/job_uuid",
                    "type": "string"
                }
            ],
            "outputs": [
                {
                    "id": "#fastq_clean_se.cwl/output",
                    "type": "#readgroup.yml/readgroup_fastq_se_file",
                    "outputSource": "#fastq_clean_se.cwl/emit_readgroup_fastq_se_file/output"
                },
                {
                    "id": "#fastq_clean_se.cwl/sqlite",
                    "type": "File",
                    "outputSource": "#fastq_clean_se.cwl/json_to_sqlite/sqlite"
                }
            ],
            "steps": [
                {
                    "id": "#fastq_clean_se.cwl/fastq_cleaner_se",
                    "run": "#fastq_cleaner_se.cwl",
                    "in": [
                        {
                            "id": "#fastq_clean_se.cwl/fastq_cleaner_se/fastq",
                            "source": "#fastq_clean_se.cwl/input",
                            "valueFrom": "$(self.forward_fastq)"
                        }
                    ],
                    "out": [
                        {
                            "id": "#fastq_clean_se.cwl/fastq_cleaner_se/cleaned_fastq"
                        },
                        {
                            "id": "#fastq_clean_se.cwl/fastq_cleaner_se/result_json"
                        }
                    ]
                },
                {
                    "id": "#fastq_clean_se.cwl/emit_readgroup_fastq_se_file",
                    "run": "#emit_readgroup_fastq_se_file.cwl",
                    "in": [
                        {
                            "id": "#fastq_clean_se.cwl/emit_readgroup_fastq_se_file/fastq",
                            "source": "#fastq_clean_se.cwl/fastq_cleaner_se/cleaned_fastq"
                        },
                        {
                            "id": "#fastq_clean_se.cwl/emit_readgroup_fastq_se_file/readgroup_meta",
                            "source": "#fastq_clean_se.cwl/input",
                            "valueFrom": "$(self.readgroup_meta)"
                        }
                    ],
                    "out": [
                        {
                            "id": "#fastq_clean_se.cwl/emit_readgroup_fastq_se_file/output"
                        }
                    ]
                },
                {
                    "id": "#fastq_clean_se.cwl/json_to_sqlite",
                    "run": "#json_to_sqlite.cwl",
                    "in": [
                        {
                            "id": "#fastq_clean_se.cwl/json_to_sqlite/input_json",
                            "source": "#fastq_clean_se.cwl/fastq_cleaner_se/result_json"
                        },
                        {
                            "id": "#fastq_clean_se.cwl/json_to_sqlite/job_uuid",
                            "source": "#fastq_clean_se.cwl/job_uuid"
                        },
                        {
                            "id": "#fastq_clean_se.cwl/json_to_sqlite/table_name",
                            "valueFrom": "fastq_cleaner_se"
                        }
                    ],
                    "out": [
                        {
                            "id": "#fastq_clean_se.cwl/json_to_sqlite/sqlite"
                        },
                        {
                            "id": "#fastq_clean_se.cwl/json_to_sqlite/log"
                        }
                    ]
                }
            ],
            "id": "#fastq_clean_se.cwl"
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
                    "id": "#integrity.cwl/job_uuid",
                    "type": "string"
                }
            ],
            "outputs": [
                {
                    "id": "#integrity.cwl/sqlite",
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
                            "id": "#integrity.cwl/bai_integrity_to_db/job_uuid",
                            "source": "#integrity.cwl/job_uuid"
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
                            "id": "#integrity.cwl/bam_integrity_to_db/job_uuid",
                            "source": "#integrity.cwl/job_uuid"
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
                            "id": "#integrity.cwl/merge_sqlite/job_uuid",
                            "source": "#integrity.cwl/job_uuid"
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
                },
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#amplicon_kit.yml/amplicon_kit_set_file"
                        },
                        {
                            "$import": "#amplicon_kit.yml/amplicon_kit_set_uuid"
                        },
                        {
                            "$import": "#capture_kit.yml/capture_kit_set_file"
                        },
                        {
                            "$import": "#capture_kit.yml/capture_kit_set_uuid"
                        }
                    ]
                },
                {
                    "class": "SubworkflowFeatureRequirement"
                }
            ],
            "inputs": [
                {
                    "id": "#metrics.cwl/bam",
                    "type": "File",
                    "secondaryFiles": [
                        "^.bai"
                    ]
                },
                {
                    "id": "#metrics.cwl/amplicon_kit_set_file_list",
                    "type": {
                        "type": "array",
                        "items": "#amplicon_kit.yml/amplicon_kit_set_file"
                    }
                },
                {
                    "id": "#metrics.cwl/capture_kit_set_file_list",
                    "type": {
                        "type": "array",
                        "items": "#capture_kit.yml/capture_kit_set_file"
                    }
                },
                {
                    "id": "#metrics.cwl/common_biallelic_vcf",
                    "type": "File",
                    "secondaryFiles": [
                        ".tbi"
                    ]
                },
                {
                    "id": "#metrics.cwl/fasta",
                    "type": "File",
                    "secondaryFiles": [
                        ".amb",
                        ".ann",
                        ".bwt",
                        ".fai",
                        ".pac",
                        ".sa",
                        "^.dict"
                    ]
                },
                {
                    "id": "#metrics.cwl/input_state",
                    "type": "string"
                },
                {
                    "id": "#metrics.cwl/job_uuid",
                    "type": "string"
                },
                {
                    "id": "#metrics.cwl/known_snp",
                    "type": "File",
                    "secondaryFiles": [
                        ".tbi"
                    ]
                }
            ],
            "outputs": [
                {
                    "id": "#metrics.cwl/sqlite",
                    "type": "File",
                    "outputSource": "#metrics.cwl/merge_sqlite/destination_sqlite"
                }
            ],
            "steps": [
                {
                    "id": "#metrics.cwl/amplicon_metrics",
                    "run": "#amplicon_metrics.cwl",
                    "scatter": "#metrics.cwl/amplicon_metrics/amplicon_kit_set_file",
                    "in": [
                        {
                            "id": "#metrics.cwl/amplicon_metrics/bam",
                            "source": "#metrics.cwl/bam"
                        },
                        {
                            "id": "#metrics.cwl/amplicon_metrics/amplicon_kit_set_file",
                            "source": "#metrics.cwl/amplicon_kit_set_file_list"
                        },
                        {
                            "id": "#metrics.cwl/amplicon_metrics/fasta",
                            "source": "#metrics.cwl/fasta"
                        },
                        {
                            "id": "#metrics.cwl/amplicon_metrics/input_state",
                            "source": "#metrics.cwl/input_state"
                        },
                        {
                            "id": "#metrics.cwl/amplicon_metrics/job_uuid",
                            "source": "#metrics.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#metrics.cwl/amplicon_metrics/sqlite"
                        }
                    ]
                },
                {
                    "id": "#metrics.cwl/exome_metrics",
                    "run": "#exome_metrics.cwl",
                    "scatter": "#metrics.cwl/exome_metrics/capture_kit_set_file",
                    "in": [
                        {
                            "id": "#metrics.cwl/exome_metrics/bam",
                            "source": "#metrics.cwl/bam"
                        },
                        {
                            "id": "#metrics.cwl/exome_metrics/capture_kit_set_file",
                            "source": "#metrics.cwl/capture_kit_set_file_list"
                        },
                        {
                            "id": "#metrics.cwl/exome_metrics/fasta",
                            "source": "#metrics.cwl/fasta"
                        },
                        {
                            "id": "#metrics.cwl/exome_metrics/input_state",
                            "source": "#metrics.cwl/input_state"
                        },
                        {
                            "id": "#metrics.cwl/exome_metrics/job_uuid",
                            "source": "#metrics.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#metrics.cwl/exome_metrics/sqlite"
                        }
                    ]
                },
                {
                    "id": "#metrics.cwl/merge_exome_sqlite",
                    "run": "#merge_sqlite.cwl",
                    "in": [
                        {
                            "id": "#metrics.cwl/merge_exome_sqlite/source_sqlite",
                            "source": "#metrics.cwl/exome_metrics/sqlite"
                        },
                        {
                            "id": "#metrics.cwl/merge_exome_sqlite/job_uuid",
                            "source": "#metrics.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#metrics.cwl/merge_exome_sqlite/destination_sqlite"
                        },
                        {
                            "id": "#metrics.cwl/merge_exome_sqlite/log"
                        }
                    ]
                },
                {
                    "id": "#metrics.cwl/merge_amplicon_sqlite",
                    "run": "#merge_sqlite.cwl",
                    "in": [
                        {
                            "id": "#metrics.cwl/merge_amplicon_sqlite/source_sqlite",
                            "source": "#metrics.cwl/amplicon_metrics/sqlite"
                        },
                        {
                            "id": "#metrics.cwl/merge_amplicon_sqlite/job_uuid",
                            "source": "#metrics.cwl/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#metrics.cwl/merge_amplicon_sqlite/destination_sqlite"
                        },
                        {
                            "id": "#metrics.cwl/merge_amplicon_sqlite/log"
                        }
                    ]
                },
                {
                    "id": "#metrics.cwl/gatk_getpileupsummaries",
                    "run": "#gatk4_getpileupsummaries.cwl",
                    "in": [
                        {
                            "id": "#metrics.cwl/gatk_getpileupsummaries/input",
                            "source": "#metrics.cwl/bam"
                        },
                        {
                            "id": "#metrics.cwl/gatk_getpileupsummaries/variant",
                            "source": "#metrics.cwl/common_biallelic_vcf"
                        }
                    ],
                    "out": [
                        {
                            "id": "#metrics.cwl/gatk_getpileupsummaries/output"
                        }
                    ]
                },
                {
                    "id": "#metrics.cwl/gatk_calculatecontamination",
                    "run": "#gatk4_calculatecontamination.cwl",
                    "in": [
                        {
                            "id": "#metrics.cwl/gatk_calculatecontamination/input",
                            "source": "#metrics.cwl/gatk_getpileupsummaries/output"
                        },
                        {
                            "id": "#metrics.cwl/gatk_calculatecontamination/bam_nameroot",
                            "source": "#metrics.cwl/bam",
                            "valueFrom": "$(self.nameroot)"
                        }
                    ],
                    "out": [
                        {
                            "id": "#metrics.cwl/gatk_calculatecontamination/output"
                        }
                    ]
                },
                {
                    "id": "#metrics.cwl/gatk_calculatecontamination_to_sqlite",
                    "run": "#gatk_calculatecontamination_to_sqlite.cwl",
                    "in": [
                        {
                            "id": "#metrics.cwl/gatk_calculatecontamination_to_sqlite/bam",
                            "source": "#metrics.cwl/bam",
                            "valueFrom": "$(self.basename)"
                        },
                        {
                            "id": "#metrics.cwl/gatk_calculatecontamination_to_sqlite/input_state",
                            "source": "#metrics.cwl/input_state"
                        },
                        {
                            "id": "#metrics.cwl/gatk_calculatecontamination_to_sqlite/job_uuid",
                            "source": "#metrics.cwl/job_uuid"
                        },
                        {
                            "id": "#metrics.cwl/gatk_calculatecontamination_to_sqlite/metric_path",
                            "source": "#metrics.cwl/gatk_calculatecontamination/output"
                        }
                    ],
                    "out": [
                        {
                            "id": "#metrics.cwl/gatk_calculatecontamination_to_sqlite/sqlite"
                        }
                    ]
                },
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
                            "id": "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/job_uuid",
                            "source": "#metrics.cwl/job_uuid"
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
                            "id": "#metrics.cwl/picard_collectoxogmetrics_to_sqlite/job_uuid",
                            "source": "#metrics.cwl/job_uuid"
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
                            "id": "#metrics.cwl/picard_collectwgsmetrics_to_sqlite/job_uuid",
                            "source": "#metrics.cwl/job_uuid"
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
                            "id": "#metrics.cwl/samtools_flagstat_to_sqlite/job_uuid",
                            "source": "#metrics.cwl/job_uuid"
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
                            "id": "#metrics.cwl/samtools_idxstats_to_sqlite/job_uuid",
                            "source": "#metrics.cwl/job_uuid"
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
                            "id": "#metrics.cwl/samtools_stats_to_sqlite/job_uuid",
                            "source": "#metrics.cwl/job_uuid"
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
                                "#metrics.cwl/gatk_calculatecontamination_to_sqlite/sqlite",
                                "#metrics.cwl/merge_exome_sqlite/destination_sqlite",
                                "#metrics.cwl/merge_amplicon_sqlite/destination_sqlite",
                                "#metrics.cwl/picard_collectmultiplemetrics_to_sqlite/sqlite",
                                "#metrics.cwl/picard_collectoxogmetrics_to_sqlite/sqlite",
                                "#metrics.cwl/picard_collectwgsmetrics_to_sqlite/sqlite",
                                "#metrics.cwl/samtools_flagstat_to_sqlite/sqlite",
                                "#metrics.cwl/samtools_idxstats_to_sqlite/sqlite",
                                "#metrics.cwl/samtools_stats_to_sqlite/sqlite"
                            ]
                        },
                        {
                            "id": "#metrics.cwl/merge_sqlite/job_uuid",
                            "source": "#metrics.cwl/job_uuid"
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
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#readgroup.yml/readgroup_meta"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_uuid"
                        }
                    ]
                }
            ],
            "inputs": [
                {
                    "id": "#readgroup_fastq_pe.cwl/forward_fastq",
                    "type": "File"
                },
                {
                    "id": "#readgroup_fastq_pe.cwl/reverse_fastq",
                    "type": "File"
                },
                {
                    "id": "#readgroup_fastq_pe.cwl/readgroup_json",
                    "type": "File"
                }
            ],
            "outputs": [
                {
                    "id": "#readgroup_fastq_pe.cwl/output",
                    "type": "#readgroup.yml/readgroup_fastq_pe_file",
                    "outputSource": "#readgroup_fastq_pe.cwl/emit_readgroup_fastq_pe/output"
                }
            ],
            "steps": [
                {
                    "id": "#readgroup_fastq_pe.cwl/emit_json_readgroup_meta",
                    "run": "#emit_json_readgroup_meta.cwl",
                    "in": [
                        {
                            "id": "#readgroup_fastq_pe.cwl/emit_json_readgroup_meta/input",
                            "source": "#readgroup_fastq_pe.cwl/readgroup_json"
                        }
                    ],
                    "out": [
                        {
                            "id": "#readgroup_fastq_pe.cwl/emit_json_readgroup_meta/output"
                        }
                    ]
                },
                {
                    "id": "#readgroup_fastq_pe.cwl/emit_readgroup_fastq_pe",
                    "run": "#emit_readgroup_fastq_pe_file.cwl",
                    "in": [
                        {
                            "id": "#readgroup_fastq_pe.cwl/emit_readgroup_fastq_pe/forward_fastq",
                            "source": "#readgroup_fastq_pe.cwl/forward_fastq"
                        },
                        {
                            "id": "#readgroup_fastq_pe.cwl/emit_readgroup_fastq_pe/reverse_fastq",
                            "source": "#readgroup_fastq_pe.cwl/reverse_fastq"
                        },
                        {
                            "id": "#readgroup_fastq_pe.cwl/emit_readgroup_fastq_pe/readgroup_meta",
                            "source": "#readgroup_fastq_pe.cwl/emit_json_readgroup_meta/output"
                        }
                    ],
                    "out": [
                        {
                            "id": "#readgroup_fastq_pe.cwl/emit_readgroup_fastq_pe/output"
                        }
                    ]
                }
            ],
            "id": "#readgroup_fastq_pe.cwl"
        },
        {
            "class": "Workflow",
            "requirements": [
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#readgroup.yml/readgroup_meta"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_uuid"
                        }
                    ]
                }
            ],
            "inputs": [
                {
                    "id": "#readgroup_fastq_se.cwl/fastq",
                    "type": "File"
                },
                {
                    "id": "#readgroup_fastq_se.cwl/readgroup_json",
                    "type": "File"
                }
            ],
            "outputs": [
                {
                    "id": "#readgroup_fastq_se.cwl/output",
                    "type": "#readgroup.yml/readgroup_fastq_se_file",
                    "outputSource": "#readgroup_fastq_se.cwl/emit_readgroup_fastq_se/output"
                }
            ],
            "steps": [
                {
                    "id": "#readgroup_fastq_se.cwl/emit_json_readgroup_meta",
                    "run": "#emit_json_readgroup_meta.cwl",
                    "in": [
                        {
                            "id": "#readgroup_fastq_se.cwl/emit_json_readgroup_meta/input",
                            "source": "#readgroup_fastq_se.cwl/readgroup_json"
                        }
                    ],
                    "out": [
                        {
                            "id": "#readgroup_fastq_se.cwl/emit_json_readgroup_meta/output"
                        }
                    ]
                },
                {
                    "id": "#readgroup_fastq_se.cwl/emit_readgroup_fastq_se",
                    "run": "#emit_readgroup_fastq_se_file.cwl",
                    "in": [
                        {
                            "id": "#readgroup_fastq_se.cwl/emit_readgroup_fastq_se/fastq",
                            "source": "#readgroup_fastq_se.cwl/fastq"
                        },
                        {
                            "id": "#readgroup_fastq_se.cwl/emit_readgroup_fastq_se/readgroup_meta",
                            "source": "#readgroup_fastq_se.cwl/emit_json_readgroup_meta/output"
                        }
                    ],
                    "out": [
                        {
                            "id": "#readgroup_fastq_se.cwl/emit_readgroup_fastq_se/output"
                        }
                    ]
                }
            ],
            "id": "#readgroup_fastq_se.cwl"
        },
        {
            "class": "Workflow",
            "requirements": [
                {
                    "class": "ScatterFeatureRequirement"
                },
                {
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#readgroup.yml/readgroup_meta"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_uuid"
                        }
                    ]
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
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroups_bam_file",
                    "type": "#readgroup.yml/readgroups_bam_file"
                }
            ],
            "outputs": [
                {
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/pe_file_list",
                    "type": {
                        "type": "array",
                        "items": "#readgroup.yml/readgroup_fastq_pe_file"
                    },
                    "outputSource": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_pe/output"
                },
                {
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/se_file_list",
                    "type": {
                        "type": "array",
                        "items": "#readgroup.yml/readgroup_fastq_se_file"
                    },
                    "outputSource": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_se/output"
                },
                {
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/o1_file_list",
                    "type": {
                        "type": "array",
                        "items": "#readgroup.yml/readgroup_fastq_se_file"
                    },
                    "outputSource": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_o1/output"
                },
                {
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/o2_file_list",
                    "type": {
                        "type": "array",
                        "items": "#readgroup.yml/readgroup_fastq_se_file"
                    },
                    "outputSource": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_o2/output"
                }
            ],
            "steps": [
                {
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq",
                    "run": "#biobambam2_bamtofastq.cwl",
                    "in": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/filename",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroups_bam_file",
                            "valueFrom": "$(self.bam)"
                        }
                    ],
                    "out": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/output_fastq1"
                        },
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/output_fastq2"
                        },
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/output_fastq_o1"
                        },
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/output_fastq_o2"
                        },
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/output_fastq_s"
                        }
                    ]
                },
                {
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/bam_readgroup_to_json",
                    "run": "#bam_readgroup_to_json.cwl",
                    "in": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/bam_readgroup_to_json/INPUT",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroups_bam_file",
                            "valueFrom": "$(self.bam)"
                        },
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/bam_readgroup_to_json/MODE",
                            "valueFrom": "lenient"
                        }
                    ],
                    "out": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/bam_readgroup_to_json/OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_pe",
                    "run": "#decider_readgroup_expression.cwl",
                    "in": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_pe/fastq",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/output_fastq1"
                        },
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_pe/readgroup_json",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/bam_readgroup_to_json/OUTPUT"
                        }
                    ],
                    "out": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_pe/output"
                        }
                    ]
                },
                {
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_se",
                    "run": "#decider_readgroup_expression.cwl",
                    "in": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_se/fastq",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/output_fastq_s"
                        },
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_se/readgroup_json",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/bam_readgroup_to_json/OUTPUT"
                        }
                    ],
                    "out": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_se/output"
                        }
                    ]
                },
                {
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_o1",
                    "run": "#decider_readgroup_expression.cwl",
                    "in": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_o1/fastq",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/output_fastq_o1"
                        },
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_o1/readgroup_json",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/bam_readgroup_to_json/OUTPUT"
                        }
                    ],
                    "out": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_o1/output"
                        }
                    ]
                },
                {
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_o2",
                    "run": "#decider_readgroup_expression.cwl",
                    "in": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_o2/fastq",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/output_fastq_o2"
                        },
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_o2/readgroup_json",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/bam_readgroup_to_json/OUTPUT"
                        }
                    ],
                    "out": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_o2/output"
                        }
                    ]
                },
                {
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_pe",
                    "run": "#readgroup_fastq_pe.cwl",
                    "scatter": [
                        "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_pe/forward_fastq",
                        "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_pe/reverse_fastq",
                        "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_pe/readgroup_json"
                    ],
                    "scatterMethod": "dotproduct",
                    "in": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_pe/forward_fastq",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/output_fastq1"
                        },
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_pe/reverse_fastq",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/output_fastq2"
                        },
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_pe/readgroup_json",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_pe/output"
                        }
                    ],
                    "out": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_pe/output"
                        }
                    ]
                },
                {
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_se",
                    "run": "#readgroup_fastq_se.cwl",
                    "scatter": [
                        "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_se/fastq",
                        "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_se/readgroup_json"
                    ],
                    "scatterMethod": "dotproduct",
                    "in": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_se/fastq",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/output_fastq_s"
                        },
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_se/readgroup_json",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_se/output"
                        }
                    ],
                    "out": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_se/output"
                        }
                    ]
                },
                {
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_o1",
                    "run": "#readgroup_fastq_se.cwl",
                    "scatter": [
                        "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_o1/fastq",
                        "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_o1/readgroup_json"
                    ],
                    "scatterMethod": "dotproduct",
                    "in": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_o1/fastq",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/output_fastq_o1"
                        },
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_o1/readgroup_json",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_o1/output"
                        }
                    ],
                    "out": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_o1/output"
                        }
                    ]
                },
                {
                    "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_o2",
                    "run": "#readgroup_fastq_se.cwl",
                    "scatter": [
                        "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_o2/fastq",
                        "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_o2/readgroup_json"
                    ],
                    "scatterMethod": "dotproduct",
                    "in": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_o2/fastq",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/biobambam_bamtofastq/output_fastq_o2"
                        },
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_o2/readgroup_json",
                            "source": "#readgroups_bam_to_readgroups_fastq_lists.cwl/decider_readgroup_o2/output"
                        }
                    ],
                    "out": [
                        {
                            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl/readgroup_fastq_o2/output"
                        }
                    ]
                }
            ],
            "id": "#readgroups_bam_to_readgroups_fastq_lists.cwl"
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
                    "class": "SchemaDefRequirement",
                    "types": [
                        {
                            "$import": "#amplicon_kit.yml/amplicon_kit_set_file"
                        },
                        {
                            "$import": "#amplicon_kit.yml/amplicon_kit_set_uuid"
                        },
                        {
                            "$import": "#capture_kit.yml/capture_kit_set_file"
                        },
                        {
                            "$import": "#capture_kit.yml/capture_kit_set_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_meta"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_file"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_pe_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroup_fastq_se_uuid"
                        },
                        {
                            "$import": "#readgroup.yml/readgroups_bam_uuid"
                        }
                    ]
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
                    "id": "#main/bam_name",
                    "type": "string"
                },
                {
                    "id": "#main/job_uuid",
                    "type": "string"
                },
                {
                    "id": "#main/amplicon_kit_set_file_list",
                    "type": {
                        "type": "array",
                        "items": "#amplicon_kit.yml/amplicon_kit_set_file"
                    }
                },
                {
                    "id": "#main/capture_kit_set_file_list",
                    "type": {
                        "type": "array",
                        "items": "#capture_kit.yml/capture_kit_set_file"
                    }
                },
                {
                    "id": "#main/readgroup_fastq_pe_file_list",
                    "type": {
                        "type": "array",
                        "items": "#readgroup.yml/readgroup_fastq_pe_file"
                    }
                },
                {
                    "id": "#main/readgroup_fastq_se_file_list",
                    "type": {
                        "type": "array",
                        "items": "#readgroup.yml/readgroup_fastq_se_file"
                    }
                },
                {
                    "id": "#main/readgroups_bam_file_list",
                    "type": {
                        "type": "array",
                        "items": "#readgroup.yml/readgroups_bam_file"
                    }
                },
                {
                    "id": "#main/common_biallelic_vcf",
                    "type": "File",
                    "secondaryFiles": [
                        ".tbi"
                    ]
                },
                {
                    "id": "#main/known_snp",
                    "type": "File",
                    "secondaryFiles": [
                        ".tbi"
                    ]
                },
                {
                    "id": "#main/run_bamindex",
                    "type": {
                        "type": "array",
                        "items": "long"
                    }
                },
                {
                    "id": "#main/run_markduplicates",
                    "type": {
                        "type": "array",
                        "items": "long"
                    }
                },
                {
                    "id": "#main/reference_sequence",
                    "type": "File",
                    "secondaryFiles": [
                        ".amb",
                        ".ann",
                        ".bwt",
                        ".fai",
                        ".pac",
                        ".sa",
                        "^.dict"
                    ]
                },
                {
                    "id": "#main/thread_count",
                    "type": "long"
                }
            ],
            "outputs": [
                {
                    "id": "#main/output_bam",
                    "type": "File",
                    "outputSource": "#main/gatk_applybqsr/output_bam"
                },
                {
                    "id": "#main/sqlite",
                    "type": "File",
                    "outputSource": "#main/merge_all_sqlite/destination_sqlite"
                }
            ],
            "steps": [
                {
                    "id": "#main/fastq_clean_pe",
                    "run": "#fastq_clean_pe.cwl",
                    "scatter": "#main/fastq_clean_pe/input",
                    "in": [
                        {
                            "id": "#main/fastq_clean_pe/input",
                            "source": "#main/readgroup_fastq_pe_file_list"
                        },
                        {
                            "id": "#main/fastq_clean_pe/job_uuid",
                            "source": "#main/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/fastq_clean_pe/output"
                        },
                        {
                            "id": "#main/fastq_clean_pe/sqlite"
                        }
                    ]
                },
                {
                    "id": "#main/fastq_clean_se",
                    "run": "#fastq_clean_se.cwl",
                    "scatter": "#main/fastq_clean_se/input",
                    "in": [
                        {
                            "id": "#main/fastq_clean_se/input",
                            "source": "#main/readgroup_fastq_se_file_list"
                        },
                        {
                            "id": "#main/fastq_clean_se/job_uuid",
                            "source": "#main/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/fastq_clean_se/output"
                        },
                        {
                            "id": "#main/fastq_clean_se/sqlite"
                        }
                    ]
                },
                {
                    "id": "#main/merge_sqlite_fastq_clean_pe",
                    "run": "#merge_sqlite.cwl",
                    "in": [
                        {
                            "id": "#main/merge_sqlite_fastq_clean_pe/source_sqlite",
                            "source": "#main/fastq_clean_pe/sqlite"
                        },
                        {
                            "id": "#main/merge_sqlite_fastq_clean_pe/job_uuid",
                            "source": "#main/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/merge_sqlite_fastq_clean_pe/destination_sqlite"
                        },
                        {
                            "id": "#main/merge_sqlite_fastq_clean_pe/log"
                        }
                    ]
                },
                {
                    "id": "#main/merge_sqlite_fastq_clean_se",
                    "run": "#merge_sqlite.cwl",
                    "in": [
                        {
                            "id": "#main/merge_sqlite_fastq_clean_se/source_sqlite",
                            "source": "#main/fastq_clean_se/sqlite"
                        },
                        {
                            "id": "#main/merge_sqlite_fastq_clean_se/job_uuid",
                            "source": "#main/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/merge_sqlite_fastq_clean_se/destination_sqlite"
                        },
                        {
                            "id": "#main/merge_sqlite_fastq_clean_se/log"
                        }
                    ]
                },
                {
                    "id": "#main/readgroups_bam_to_readgroups_fastq_lists",
                    "run": "#readgroups_bam_to_readgroups_fastq_lists.cwl",
                    "scatter": "#main/readgroups_bam_to_readgroups_fastq_lists/readgroups_bam_file",
                    "in": [
                        {
                            "id": "#main/readgroups_bam_to_readgroups_fastq_lists/readgroups_bam_file",
                            "source": "#main/readgroups_bam_file_list"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/readgroups_bam_to_readgroups_fastq_lists/pe_file_list"
                        },
                        {
                            "id": "#main/readgroups_bam_to_readgroups_fastq_lists/se_file_list"
                        },
                        {
                            "id": "#main/readgroups_bam_to_readgroups_fastq_lists/o1_file_list"
                        },
                        {
                            "id": "#main/readgroups_bam_to_readgroups_fastq_lists/o2_file_list"
                        }
                    ]
                },
                {
                    "id": "#main/merge_bam_pe_fastq_records",
                    "run": "#merge_pe_fastq_records.cwl",
                    "in": [
                        {
                            "id": "#main/merge_bam_pe_fastq_records/input",
                            "source": "#main/readgroups_bam_to_readgroups_fastq_lists/pe_file_list"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/merge_bam_pe_fastq_records/output"
                        }
                    ]
                },
                {
                    "id": "#main/merge_pe_fastq_records",
                    "run": "#merge_pe_fastq_records.cwl",
                    "in": [
                        {
                            "id": "#main/merge_pe_fastq_records/input",
                            "source": [
                                "#main/merge_bam_pe_fastq_records/output",
                                "#main/fastq_clean_pe/output"
                            ]
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/merge_pe_fastq_records/output"
                        }
                    ]
                },
                {
                    "id": "#main/merge_bam_se_fastq_records",
                    "run": "#merge_se_fastq_records.cwl",
                    "in": [
                        {
                            "id": "#main/merge_bam_se_fastq_records/input",
                            "source": "#main/readgroups_bam_to_readgroups_fastq_lists/se_file_list"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/merge_bam_se_fastq_records/output"
                        }
                    ]
                },
                {
                    "id": "#main/merge_se_fastq_records",
                    "run": "#merge_se_fastq_records.cwl",
                    "in": [
                        {
                            "id": "#main/merge_se_fastq_records/input",
                            "source": [
                                "#main/merge_bam_se_fastq_records/output",
                                "#main/fastq_clean_se/output"
                            ]
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/merge_se_fastq_records/output"
                        }
                    ]
                },
                {
                    "id": "#main/merge_o1_fastq_records",
                    "run": "#merge_se_fastq_records.cwl",
                    "in": [
                        {
                            "id": "#main/merge_o1_fastq_records/input",
                            "source": "#main/readgroups_bam_to_readgroups_fastq_lists/o1_file_list"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/merge_o1_fastq_records/output"
                        }
                    ]
                },
                {
                    "id": "#main/merge_o2_fastq_records",
                    "run": "#merge_se_fastq_records.cwl",
                    "in": [
                        {
                            "id": "#main/merge_o2_fastq_records/input",
                            "source": "#main/readgroups_bam_to_readgroups_fastq_lists/o2_file_list"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/merge_o2_fastq_records/output"
                        }
                    ]
                },
                {
                    "id": "#main/bwa_pe",
                    "run": "#bwa_pe.cwl",
                    "scatter": "#main/bwa_pe/readgroup_fastq_pe",
                    "in": [
                        {
                            "id": "#main/bwa_pe/job_uuid",
                            "source": "#main/job_uuid"
                        },
                        {
                            "id": "#main/bwa_pe/reference_sequence",
                            "source": "#main/reference_sequence"
                        },
                        {
                            "id": "#main/bwa_pe/readgroup_fastq_pe",
                            "source": "#main/merge_pe_fastq_records/output"
                        },
                        {
                            "id": "#main/bwa_pe/thread_count",
                            "source": "#main/thread_count"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/bwa_pe/bam"
                        },
                        {
                            "id": "#main/bwa_pe/sqlite"
                        }
                    ]
                },
                {
                    "id": "#main/bwa_se",
                    "run": "#bwa_se.cwl",
                    "scatter": "#main/bwa_se/readgroup_fastq_se",
                    "in": [
                        {
                            "id": "#main/bwa_se/job_uuid",
                            "source": "#main/job_uuid"
                        },
                        {
                            "id": "#main/bwa_se/reference_sequence",
                            "source": "#main/reference_sequence"
                        },
                        {
                            "id": "#main/bwa_se/readgroup_fastq_se",
                            "source": "#main/merge_se_fastq_records/output"
                        },
                        {
                            "id": "#main/bwa_se/thread_count",
                            "source": "#main/thread_count"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/bwa_se/bam"
                        },
                        {
                            "id": "#main/bwa_se/sqlite"
                        }
                    ]
                },
                {
                    "id": "#main/bwa_o1",
                    "run": "#bwa_se.cwl",
                    "scatter": "#main/bwa_o1/readgroup_fastq_se",
                    "in": [
                        {
                            "id": "#main/bwa_o1/job_uuid",
                            "source": "#main/job_uuid"
                        },
                        {
                            "id": "#main/bwa_o1/reference_sequence",
                            "source": "#main/reference_sequence"
                        },
                        {
                            "id": "#main/bwa_o1/readgroup_fastq_se",
                            "source": "#main/merge_o1_fastq_records/output"
                        },
                        {
                            "id": "#main/bwa_o1/thread_count",
                            "source": "#main/thread_count"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/bwa_o1/bam"
                        },
                        {
                            "id": "#main/bwa_o1/sqlite"
                        }
                    ]
                },
                {
                    "id": "#main/bwa_o2",
                    "run": "#bwa_se.cwl",
                    "scatter": "#main/bwa_o2/readgroup_fastq_se",
                    "in": [
                        {
                            "id": "#main/bwa_o2/job_uuid",
                            "source": "#main/job_uuid"
                        },
                        {
                            "id": "#main/bwa_o2/reference_sequence",
                            "source": "#main/reference_sequence"
                        },
                        {
                            "id": "#main/bwa_o2/readgroup_fastq_se",
                            "source": "#main/merge_o2_fastq_records/output"
                        },
                        {
                            "id": "#main/bwa_o2/thread_count",
                            "source": "#main/thread_count"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/bwa_o2/bam"
                        },
                        {
                            "id": "#main/bwa_o2/sqlite"
                        }
                    ]
                },
                {
                    "id": "#main/merge_sqlite_bwa_pe",
                    "run": "#merge_sqlite.cwl",
                    "in": [
                        {
                            "id": "#main/merge_sqlite_bwa_pe/source_sqlite",
                            "source": "#main/bwa_pe/sqlite"
                        },
                        {
                            "id": "#main/merge_sqlite_bwa_pe/job_uuid",
                            "source": "#main/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/merge_sqlite_bwa_pe/destination_sqlite"
                        },
                        {
                            "id": "#main/merge_sqlite_bwa_pe/log"
                        }
                    ]
                },
                {
                    "id": "#main/merge_sqlite_bwa_se",
                    "run": "#merge_sqlite.cwl",
                    "in": [
                        {
                            "id": "#main/merge_sqlite_bwa_se/source_sqlite",
                            "source": "#main/bwa_se/sqlite"
                        },
                        {
                            "id": "#main/merge_sqlite_bwa_se/job_uuid",
                            "source": "#main/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/merge_sqlite_bwa_se/destination_sqlite"
                        },
                        {
                            "id": "#main/merge_sqlite_bwa_se/log"
                        }
                    ]
                },
                {
                    "id": "#main/picard_mergesamfiles",
                    "run": "#picard_mergesamfiles_aoa.cwl",
                    "in": [
                        {
                            "id": "#main/picard_mergesamfiles/INPUT",
                            "source": [
                                "#main/bwa_pe/bam",
                                "#main/bwa_se/bam",
                                "#main/bwa_o1/bam",
                                "#main/bwa_o2/bam"
                            ]
                        },
                        {
                            "id": "#main/picard_mergesamfiles/OUTPUT",
                            "source": "#main/bam_name"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/picard_mergesamfiles/MERGED_OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#main/bam_reheader",
                    "run": "#bam_reheader.cwl",
                    "in": [
                        {
                            "id": "#main/bam_reheader/input",
                            "source": "#main/picard_mergesamfiles/MERGED_OUTPUT"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/bam_reheader/output"
                        }
                    ]
                },
                {
                    "id": "#main/conditional_markduplicates",
                    "run": "#conditional_markduplicates.cwl",
                    "scatter": "#main/conditional_markduplicates/run_markduplicates",
                    "in": [
                        {
                            "id": "#main/conditional_markduplicates/bam",
                            "source": "#main/bam_reheader/output"
                        },
                        {
                            "id": "#main/conditional_markduplicates/job_uuid",
                            "source": "#main/job_uuid"
                        },
                        {
                            "id": "#main/conditional_markduplicates/run_markduplicates",
                            "source": "#main/run_markduplicates"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/conditional_markduplicates/output"
                        },
                        {
                            "id": "#main/conditional_markduplicates/sqlite"
                        }
                    ]
                },
                {
                    "id": "#main/conditional_index",
                    "run": "#conditional_bamindex.cwl",
                    "scatter": "#main/conditional_index/run_bamindex",
                    "in": [
                        {
                            "id": "#main/conditional_index/bam",
                            "source": "#main/bam_reheader/output"
                        },
                        {
                            "id": "#main/conditional_index/run_bamindex",
                            "source": "#main/run_bamindex"
                        },
                        {
                            "id": "#main/conditional_index/thread_count",
                            "source": "#main/thread_count"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/conditional_index/output"
                        },
                        {
                            "id": "#main/conditional_index/sqlite"
                        }
                    ]
                },
                {
                    "id": "#main/decide_markduplicates_index",
                    "run": "#decider_conditional_bams.cwl",
                    "in": [
                        {
                            "id": "#main/decide_markduplicates_index/conditional_bam1",
                            "source": "#main/conditional_markduplicates/output"
                        },
                        {
                            "id": "#main/decide_markduplicates_index/conditional_sqlite1",
                            "source": "#main/conditional_markduplicates/sqlite"
                        },
                        {
                            "id": "#main/decide_markduplicates_index/conditional_bam2",
                            "source": "#main/conditional_index/output"
                        },
                        {
                            "id": "#main/decide_markduplicates_index/conditional_sqlite2",
                            "source": "#main/conditional_index/sqlite"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/decide_markduplicates_index/output"
                        },
                        {
                            "id": "#main/decide_markduplicates_index/sqlite"
                        }
                    ]
                },
                {
                    "id": "#main/gatk_baserecalibrator",
                    "run": "#gatk4_baserecalibrator.cwl",
                    "in": [
                        {
                            "id": "#main/gatk_baserecalibrator/input",
                            "source": "#main/decide_markduplicates_index/output"
                        },
                        {
                            "id": "#main/gatk_baserecalibrator/known-sites",
                            "source": "#main/known_snp"
                        },
                        {
                            "id": "#main/gatk_baserecalibrator/reference",
                            "source": "#main/reference_sequence"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/gatk_baserecalibrator/output_grp"
                        }
                    ]
                },
                {
                    "id": "#main/gatk_applybqsr",
                    "run": "#gatk4_applybqsr.cwl",
                    "in": [
                        {
                            "id": "#main/gatk_applybqsr/input",
                            "source": "#main/decide_markduplicates_index/output"
                        },
                        {
                            "id": "#main/gatk_applybqsr/bqsr-recal-file",
                            "source": "#main/gatk_baserecalibrator/output_grp"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/gatk_applybqsr/output_bam"
                        }
                    ]
                },
                {
                    "id": "#main/picard_validatesamfile_bqsr",
                    "run": "#picard_validatesamfile.cwl",
                    "in": [
                        {
                            "id": "#main/picard_validatesamfile_bqsr/INPUT",
                            "source": "#main/gatk_applybqsr/output_bam"
                        },
                        {
                            "id": "#main/picard_validatesamfile_bqsr/VALIDATION_STRINGENCY",
                            "valueFrom": "STRICT"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/picard_validatesamfile_bqsr/OUTPUT"
                        }
                    ]
                },
                {
                    "id": "#main/picard_validatesamfile_bqsr_to_sqlite",
                    "run": "#picard_validatesamfile_to_sqlite.cwl",
                    "in": [
                        {
                            "id": "#main/picard_validatesamfile_bqsr_to_sqlite/bam",
                            "source": "#main/gatk_applybqsr/output_bam",
                            "valueFrom": "$(self.basename)"
                        },
                        {
                            "id": "#main/picard_validatesamfile_bqsr_to_sqlite/input_state",
                            "valueFrom": "gatk_applybqsr_readgroups"
                        },
                        {
                            "id": "#main/picard_validatesamfile_bqsr_to_sqlite/metric_path",
                            "source": "#main/picard_validatesamfile_bqsr/OUTPUT"
                        },
                        {
                            "id": "#main/picard_validatesamfile_bqsr_to_sqlite/job_uuid",
                            "source": "#main/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/picard_validatesamfile_bqsr_to_sqlite/sqlite"
                        }
                    ]
                },
                {
                    "id": "#main/metrics",
                    "run": "#metrics.cwl",
                    "in": [
                        {
                            "id": "#main/metrics/bam",
                            "source": "#main/gatk_applybqsr/output_bam"
                        },
                        {
                            "id": "#main/metrics/amplicon_kit_set_file_list",
                            "source": "#main/amplicon_kit_set_file_list"
                        },
                        {
                            "id": "#main/metrics/capture_kit_set_file_list",
                            "source": "#main/capture_kit_set_file_list"
                        },
                        {
                            "id": "#main/metrics/common_biallelic_vcf",
                            "source": "#main/common_biallelic_vcf"
                        },
                        {
                            "id": "#main/metrics/fasta",
                            "source": "#main/reference_sequence"
                        },
                        {
                            "id": "#main/metrics/input_state",
                            "valueFrom": "gatk_applybqsr_readgroups"
                        },
                        {
                            "id": "#main/metrics/job_uuid",
                            "source": "#main/job_uuid"
                        },
                        {
                            "id": "#main/metrics/known_snp",
                            "source": "#main/known_snp"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/metrics/sqlite"
                        }
                    ]
                },
                {
                    "id": "#main/integrity",
                    "run": "#integrity.cwl",
                    "in": [
                        {
                            "id": "#main/integrity/bai",
                            "source": "#main/gatk_applybqsr/output_bam",
                            "valueFrom": "$(self.secondaryFiles[0])"
                        },
                        {
                            "id": "#main/integrity/bam",
                            "source": "#main/gatk_applybqsr/output_bam"
                        },
                        {
                            "id": "#main/integrity/input_state",
                            "valueFrom": "gatk_applybqsr_readgroups"
                        },
                        {
                            "id": "#main/integrity/job_uuid",
                            "source": "#main/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/integrity/sqlite"
                        }
                    ]
                },
                {
                    "id": "#main/merge_all_sqlite",
                    "run": "#merge_sqlite.cwl",
                    "in": [
                        {
                            "id": "#main/merge_all_sqlite/source_sqlite",
                            "source": [
                                "#main/merge_sqlite_fastq_clean_pe/destination_sqlite",
                                "#main/merge_sqlite_fastq_clean_se/destination_sqlite",
                                "#main/merge_sqlite_bwa_pe/destination_sqlite",
                                "#main/merge_sqlite_bwa_se/destination_sqlite",
                                "#main/decide_markduplicates_index/sqlite",
                                "#main/picard_validatesamfile_bqsr_to_sqlite/sqlite",
                                "#main/metrics/sqlite",
                                "#main/integrity/sqlite"
                            ]
                        },
                        {
                            "id": "#main/merge_all_sqlite/job_uuid",
                            "source": "#main/job_uuid"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/merge_all_sqlite/destination_sqlite"
                        },
                        {
                            "id": "#main/merge_all_sqlite/log"
                        }
                    ]
                }
            ],
            "id": "#main"
        }
    ],
    "cwlVersion": "v1.0"
}