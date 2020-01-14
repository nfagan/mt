classdef Subscript < handle
  properties
    Method;
    Arguments;
  end
  
  methods
    function obj = Subscript(method, exprs)
      obj.Method = method;
      obj.Arguments = exprs;
    end
  end
end