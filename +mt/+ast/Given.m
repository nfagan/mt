classdef Given < handle
  properties
    ParameterNames;
    Declaration;
  end
  
  methods
    function obj = Given(param_names, declaration)
      obj.ParameterNames = param_names;
      obj.Declaration = declaration;
    end
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = given( visitor, obj );
    end
  end
end