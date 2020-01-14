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
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = function_type( visitor, obj );
    end
  end
end