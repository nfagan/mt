classdef GroupingExprComponent < handle
  properties
    Expr;
    Delimiter;
  end
  
  methods
    function obj = GroupingExprComponent(expr, delim)
      obj.Expr = expr;
      obj.Delimiter = delim;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = grouping_expression_component( vis, obj );
    end
  end
end