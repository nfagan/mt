classdef AnonymousFunctionExpr < handle
  properties
    InputIdentifiers;
    Expr;
  end
  
  methods
    function obj = AnonymousFunctionExpr(inputs, expr)
      obj.InputIdentifiers = inputs;
      obj.Expr = expr;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = anonymous_function_expr( vis, obj );
    end
  end
end