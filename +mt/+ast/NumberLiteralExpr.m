classdef NumberLiteralExpr < handle
  properties
    Value;
  end
  
  methods
    function obj = NumberLiteralExpr(val)
      obj.Value = val;
    end
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = number_literal_expr( visitor, obj );
    end
  end
  
  methods (Static = true)
    function obj = from_token_text(token, text, types)
      lex = mt.token.lexeme( token, text, types );
      val = str2double( lex );
      
      assert( ~isnan(val) && isscalar(val) ...
        , 'Failed to convert lexeme "%s" to scalar, non-NaN number.', lex );
      
      obj = mt.ast.NumberLiteralExpr( val );
    end
  end
end