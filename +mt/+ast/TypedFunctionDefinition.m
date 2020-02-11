classdef TypedFunctionDefinition < handle
  properties
    Type;
    Definition;
  end
  
  methods
    function obj = TypedFunctionDefinition(type, def)
      obj.Type = type;
      obj.Definition = def;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = typed_function_definition( vis, obj );
    end
  end
end