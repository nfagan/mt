classdef WhileStmt < handle
  properties
    ConditionExpr;
    Body;
  end
  
  methods
    function obj = WhileStmt(cond, body)
      obj.ConditionExpr = cond;
      obj.Body = body;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = while_statement( vis, obj );
    end
  end
end