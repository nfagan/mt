classdef AssignmentStmt < handle
  properties
    OfExpr;
    ToExpr;
  end
  
  methods
    function obj = AssignmentStmt(lhs, rhs)
      obj.OfExpr = rhs;
      obj.ToExpr = lhs;
    end
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = assignment_statement( visitor, obj );
    end
  end
end