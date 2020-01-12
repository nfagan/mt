classdef TypeIdentifier < handle
  properties
    Identifier;
    Arguments;
  end
  
  methods
    function obj = TypeIdentifier(ident, args)
      obj.Identifier = ident;
      obj.Arguments = args;
    end
  end
end