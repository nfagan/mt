classdef Let < handle
  properties
    Identifier;
    EqualToType;
  end
  
  methods
    function obj = Let(ident, equal_to)
      obj.Identifier = ident;
      obj.EqualToType = equal_to;
    end
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = let( visitor, obj );
    end
  end
end