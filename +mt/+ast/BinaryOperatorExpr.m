classdef BinaryOperatorExpr < handle
  properties
    OperatorType;
    LeftExpr;
    RightExpr;
  end
  
  methods
    function obj = BinaryOperatorExpr(op, lhs, rhs)
      obj.OperatorType = op;
      obj.LeftExpr = lhs;
      obj.RightExpr = rhs;
    end
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = binary_operator_expr( visitor, obj );
    end
  end
end