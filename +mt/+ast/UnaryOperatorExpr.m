classdef UnaryOperatorExpr < handle
  properties
    OperatorType;
    Fixity;
    Expr;
  end
  
  methods
    function obj = UnaryOperatorExpr(op, fixity, expr)
      obj.OperatorType = op;
      obj.Fixity = fixity;
      obj.Expr = expr;
    end
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = unary_operator_expr( visitor, obj );
    end
  end
end