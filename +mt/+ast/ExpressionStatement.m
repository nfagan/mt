classdef ExpressionStatement < handle
  properties
    Expr;
  end
  
  methods
    function obj = ExpressionStatement(expr)
      obj.Expr = expr;
    end
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = expression_statement( visitor, obj );
    end
  end
end