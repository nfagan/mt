classdef EndIndexExpr
  methods
    function obj = EndIndexExpr()
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = end_index_expr( vis, obj );
    end
  end
end