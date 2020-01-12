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
    
    [errs, tree] = parse(obj, tokens, text)
  end
  
  methods (Access = private)
    errs = function_definition(obj)
    [errs, node] = t_begin(obj)
    [errs, node] = begin(obj)
    [errs, node] = type_info(obj)
    [errs, node] = given(obj)
    [errs, node] = let(obj)
    [errs, idents] = char_identifier_sequence(obj, term)
    
    [errs, node] = type_specifier(obj)
    [errs, node] = single_type_specifier(obj)
    [errs, nodes] = multiple_type_specifiers(obj, term)
    [errs, node] = function_type_specifier(obj)
    
    function err = make_error_if_unexpected_current_token(obj, allowed_types)
      tok = peek( obj.Iterator );
      type = mt.token.type( tok );
      
      if ( ~ismember(type, allowed_types) )
        err = make_error_expected_token_type( obj, tok, allowed_types );
      else
        err = mt.AstGenerator.empty_error();
      end
    end
    
    function err = make_error_expected_token_type(obj, received_token, expected_types)
      expected_typenames = strjoin( mt.token.typenames(expected_types), ', ');
      msg = sprintf( ...
        'Expected to receive one of these types:\n\n%s\n\nInstead, received: "%s".' ...
        , expected_typenames ...
        , mt.token.to_string(received_token, obj.Text, obj.TokenTypes) ...
      );
    
    	start = mt.token.start( received_token );
      stop = mt.token.stop( received_token );
      
      err = mt.ParseError.with_message_context( msg, start, stop, obj.Text );
    end
  end
  
  methods (Access = private, Static = true)
    function err = empty_error()
      err = [];
%       err = mt.ParseError.empty();
    end
  end
end