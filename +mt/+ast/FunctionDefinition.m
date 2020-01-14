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
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = function_definition( visitor, obj );
    end
  end
end