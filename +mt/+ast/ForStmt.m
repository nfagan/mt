classdef ForStmt < handle
  properties
    LoopType;
    LoopVariableIdentifier;
    LoopVariableExpr;
    Body;
  end
  
  methods
    function obj = ForStmt(loop_type, ident, expr, body)
      obj.LoopType = loop_type;
      obj.LoopVariableIdentifier = ident;
      obj.LoopVariableExpr = expr;
      obj.Body = body;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = for_statement( vis, obj );
    end
  end
end