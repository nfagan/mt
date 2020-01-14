classdef ExpressionStatement < handle
  properties
    Expr;
  end
  
  methods
    function obj = ExpressionStatement(expr)
      obj.Expr = expr;
    end
  end
end