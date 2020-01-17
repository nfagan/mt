classdef LiteralFieldReferenceExpr < handle
  properties
    Identifier;
  end
  
  methods
    function obj = LiteralFieldReferenceExpr(ident)
      obj.Identifier = ident;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = literal_field_reference_expr( vis, obj );
    end
  end
end