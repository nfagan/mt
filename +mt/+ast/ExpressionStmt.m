classdef ExpressionStmt < handle
  properties
    Expr;
  end
  
  methods
    function obj = ExpressionStmt(expr)
      obj.Expr = expr;
    end
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = expression_statement( visitor, obj );
    end
  end
end