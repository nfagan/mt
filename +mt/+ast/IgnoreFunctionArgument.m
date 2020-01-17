classdef IgnoreFunctionArgument
  methods
    function obj = IgnoreFunctionArgument()
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = ignore_function_argument( vis, obj );
    end
  end
end