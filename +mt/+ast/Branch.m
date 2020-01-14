classdef Branch < handle
  properties
    Type;
    Condition;
    Block;
  end
  
  methods
    function obj = Branch(type, cond, block)
      obj.Type = type;
      obj.Condition = cond;
      obj.Block = block;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = branch( vis, obj );
    end
  end
end