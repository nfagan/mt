classdef FunctionReferenceExpr < handle
  properties
    Identifier;
  end
  
  methods
    function obj = FunctionReferenceExpr(ident)
      obj.Identifier = ident;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = function_reference_expr( vis, obj );
    end
  end
end