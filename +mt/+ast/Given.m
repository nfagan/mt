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
  end
end