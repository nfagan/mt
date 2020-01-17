classdef DynamicFieldReferenceExpr < handle
  properties
    Expr;
  end
  
  methods
    function obj = DynamicFieldReferenceExpr(expr)
      obj.Expr = expr;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = dynamic_field_reference_expr( vis, obj );
    end
  end
end