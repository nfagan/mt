classdef AssignmentStatement < handle
  properties
    OfExpr;
    ToExpr;
  end
  
  methods
    function obj = AssignmentStatement(lhs, rhs)
      obj.OfExpr = rhs;
      obj.ToExpr = lhs;
    end
  end
end