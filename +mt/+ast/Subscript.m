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
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = subscript( visitor, obj );
    end
  end
end