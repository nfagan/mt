classdef AstGenerator < handle
  properties (Access = private)
    TokenTypes;
    Iterator;
    Text;
  end
  
  methods
    function obj = AstGenerator()
      obj.TokenTypes = mt.token.types.all();
    end
    
    errs = parse(obj, tokens, text)
  end
  
  methods (Access = private)
    errs = function_definition(obj)
    
    function err = make_error_expected_token_type(obj, received_token, expected_types)
      expected_typenames = strjoin( mt.token.typenames(expected_types), ', ');
      msg = sprintf( ...
        'Expected to receive one of these types:\n\n%s\n\nInstead, received: "%s".' ...
        , expected_typenames ...
        , mt.token.to_string(received_token, obj.Text, obj.TokenTypes) ...
      );
    
      err = mt.ParseError.with_message_context( msg, received_token, obj.Text );
    end
  end
  
  methods (Access = private, Static = true)
    function err = empty_error()
      err = mt.ParseError.empty();
    end
  end
end