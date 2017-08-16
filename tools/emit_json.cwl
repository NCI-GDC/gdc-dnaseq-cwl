#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: float_keys
    type:
      type: array
      items: string

  - id: float_values
    type:
      type: array
      items: float

  - id: long_keys
    type:
      type: array
      items: string

  - id: long_values
    type:
      type: array
      items: long

  - id: string_keys
    type:
      type: array
      items: string

  - id: string_values
    type:
      type: array
      items: string

outputs:
  - id: output
    type: string

expression: |
  ${
  
    var OutputObject = {};
    for (var i = 0; i < inputs.string_keys.length; i++) {
      var key = inputs.string_keys[i];
      var value = inputs.string_values[i];
      OutputObject[key] = value;
    }

    for (var i = 0; i < inputs.long_keys.length; i++) {
      var key = inputs.long_keys[i];
      var value = parseInt(inputs.long_values[i]);
      OutputObject[key] = value;
    }

    for (var i = 0; i < inputs.float_keys.length; i++) {
      var key = inputs.float_keys[i];
      var value = parseFloat(inputs.float_values[i]);
      OutputObject[key] = value;
    }

    return {'output': JSON.stringify(OutputObject)}
    //return {'output': OutputObject}
  }



