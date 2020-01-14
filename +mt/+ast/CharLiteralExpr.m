classdef CharLiteralExpr < handle
  properties
    Value;
  end
  
  methods
    function obj = CharLiteralExpr(val)
      obj.Value = val;
    end
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = char_literal_expr( visitor, obj );
    end
  end
  
  methods (Static = true)
    function obj = from_token_text(token, text, types)
      lex = mt.token.lexeme( token, text, types );
      obj = mt.ast.CharLiteralExpr( lex );
    end
  end
end