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
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = type_identifier( visitor, obj );
    end
  end
end