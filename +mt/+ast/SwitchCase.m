classdef SwitchCase < handle
  properties
    Expr;
    Block;
  end
  
  methods
    function obj = SwitchCase(expr, block)
      obj.Expr = expr;
      obj.Block = block;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = switch_case( vis, obj );
    end
  end
end