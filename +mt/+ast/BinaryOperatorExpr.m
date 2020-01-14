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
  end
end