classdef CharLiteralExpr < handle
  properties
    Value;
  end
  
  methods
    function obj = CharLiteralExpr(val)
      obj.Value = val;
    end
  end
  
  methods (Static = true)
    function obj = from_token_text(token, text, types)
      lex = mt.token.lexeme( token, text, types );
      obj = mt.ast.CharLiteralExpr( lex );
    end
  end
end