classdef TryStmt < handle
  properties
    TryBlock;
    CatchExpr;
    CatchBlock;
  end
  
  methods
    function obj = TryStmt(try_block, catch_expr, catch_block)
      obj.TryBlock = try_block;
      obj.CatchExpr = catch_expr;
      obj.CatchBlock = catch_block;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = try_statement( vis, obj );
    end
  end
end