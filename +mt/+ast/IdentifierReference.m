classdef IdentifierReference < handle
  properties
    Identifier;
    Subscript;
  end
  
  methods
    function obj = IdentifierReference(ident, sub)
      obj.Identifier = ident;
      obj.Subscript = sub;
    end
  end
end