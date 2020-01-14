classdef FunctionDefinition < handle
  properties
    Name;
    Inputs;
    Outputs;
    Body;
  end
  
  methods
    function obj = FunctionDefinition(name, inputs, outputs, body)
      obj.Name = name;
      obj.Inputs = inputs;
      obj.Outputs = outputs;
      obj.Body = body;
    end
  end
end