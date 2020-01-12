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
  end
end