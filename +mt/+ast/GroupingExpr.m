classdef GroupingExpr < handle
  properties
    BeginType;
    Exprs;
  end
  
  methods
    function obj = GroupingExpr(type, exprs)
      obj.BeginType = type;
      obj.Exprs = exprs;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = grouping_expression( vis, obj );
    end
  end
end