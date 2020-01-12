classdef FunctionType < handle
  properties
    Inputs;
    Outputs;
  end
  
  methods
    function obj = FunctionType(inputs, outputs)
      obj.Inputs = inputs;
      obj.Outputs = outputs;
    end
  end
end