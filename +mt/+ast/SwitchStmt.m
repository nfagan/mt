classdef SwitchStmt < handle
  properties
    SwitchExpr;
    CaseBlocks;
    OtherwiseBlock;
  end
  
  methods
    function obj = SwitchStmt(expr, cases, otherwise_block)
      obj.SwitchExpr = expr;
      obj.CaseBlocks = cases;
      obj.OtherwiseBlock = otherwise_block;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = switch_statement( vis, obj );
    end
  end
end