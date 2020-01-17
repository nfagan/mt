classdef Return
  methods
    function obj = Return()
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = return_statement( vis, obj );
    end
  end
end