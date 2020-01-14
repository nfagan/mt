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
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = identifier_reference_expr( visitor, obj );
    end
  end
end