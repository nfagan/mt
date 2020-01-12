classdef Scanner < handle
  properties (Access = private)
    I;
    Tokens;
    TokenTypes;
    Eof;
    Text;
    PunctuationToTokenType
  end
  
  methods
    function obj = Scanner()
      import mt.Scanner;
      
      obj.TokenTypes = mt.token.types.all();
      obj.PunctuationToTokenType = Scanner.make_punctuation_map( obj.TokenTypes );
    end
    
    [errs, tokens] = scan(obj, text)
    
    function disp_tokens(obj)
      mt.token.disp( obj.Tokens, obj.Text, obj.TokenTypes );
    end
    
    function ts = tokens(obj)
      ts = obj.Tokens;
    end
    
    function t = nth_token(obj, i)
      t = obj.Tokens(i, :);
    end
    
    function n = num_tokens(obj)
      n = size( obj.Tokens, 1 );
    end
  end
  
  methods (Access = private)
    begin_scan(obj, text)
    errs = main_scan(obj)
    merge_compound_tokens(obj)
    handle_comment(obj)
    
    function add_token(obj, token)
      obj.Tokens(end+1, :) = token;
    end
    
    function conditional_add_token(obj, token)
      if ( ~isempty(token) )
        add_token( obj, token );
      end
    end
    
    function errs = conditional_add_token_check_err(obj, token, errs, err)
      if ( isempty(err) )
        add_token( obj, token );
      else
        errs = [ errs, err ];
      end
    end
    
    function token = check_punctuation_token(obj)
      token = [];
      c = peek( obj );
      
      if ( isKey(obj.PunctuationToTokenType, c) )
        token = make_token( obj, obj.I, obj.I, obj.PunctuationToTokenType(c) );
      end
    end
    
    function token = check_whitespace_token(obj)
      import mt.Scanner;
      
      token = [];
      
      if ( peek(obj) == Scanner.new_line() )
        token = make_token( obj, obj.I, obj.I, obj.TokenTypes.new_line );
      end
    end
    
    function [err, token] = string_literal_token(obj, type, terminator)
      start = obj.I + 1;
      err = [];
      
      while ( obj.I < obj.Eof )
        if ( peek_next(obj) == terminator && peek_n(obj, 2) ~= terminator )
          break;
        end
        
        advance( obj );
      end
      
      if ( obj.I >= obj.Eof )
        token = [];
        err = make_error_unterminated_string_literal( obj, start-1 );
        
      else
        stop = obj.I;
        token = make_token( obj, start, stop, type );

        % Consume '.
        advance( obj );
      end
    end
    
    function token = numeric_token(obj)
      import mt.Scanner;
      
      start = obj.I;
      dot = false;
      
      while ( true )
        c = peek_next( obj );
        
        if ( c == '.' && ~dot )
          dot = true;
        elseif ( ~Scanner.is_digit(c) )
          break;
        end
        
        advance( obj );
      end
      
      token = make_token( obj, start, obj.I, obj.TokenTypes.number_literal );
    end
    
    function token = identifier_or_keyword_token(obj)
      import mt.Scanner;
      
      start = obj.I;
      
      while ( Scanner.is_identifier_component(peek_next(obj)) )
        advance( obj );
      end
      
      stop = obj.I;
      lexeme = obj.Text(start:stop);
      
      if ( Scanner.is_keyword(lexeme) )
        token_type = obj.TokenTypes.(lexeme);
      else
        token_type = obj.TokenTypes.identifier;
      end
      
      token = make_token( obj, start, stop, token_type );
    end

    function consume_whitespace_to_new_line(obj)
      import mt.Scanner;
      
      while ( obj.I < obj.Eof )
        c = peek( obj );
        
        if ( ~Scanner.is_whitespace(c) || c == Scanner.new_line )
          return
        end
                
        advance( obj );
      end
    end
    
    function err = make_error_unterminated_string_literal(obj, string_start)
      msg = 'Unterminated string literal.';
      err = mt.ParseError.with_message_context( ...
        msg, string_start, string_start, obj.Text ...
      );
    end
    
    function t = make_token(obj, start, stop, type)
      t = [ start, stop, type ];
    end
    
    function advance(obj)
      obj.I = obj.I + 1;
    end
    
    function advance_n(obj, n)
      obj.I = obj.I + n;
    end
    
    function c = peek_next(obj)
      if ( obj.I + 1 >= obj.Eof )
        c = 0;
      else
        c = obj.Text(obj.I + 1);
      end
    end
    
    function c = peek_n(obj, n)
      if ( obj.I + n >= obj.Eof )
        c = 0;
      else
        c = obj.Text(obj.I + n);
      end
    end
    
    function c = peek_prev(obj)
      if ( obj.I == 1 || obj.I-1 >= obj.Eof )
        c = 0;
      else
        c = obj.Text(obj.I - 1);
      end
    end
    
    function c = peek(obj)
      if ( obj.I >= obj.Eof )
        c = 0;
      else
        c = obj.Text(obj.I);
      end
    end
  end
  
  methods (Access = private, Static = true)
    function e = empty_error()
      e = mt.ParseError.empty();
    end
    
    function c = apostrophe()
      c = '''';
    end

    function c = new_line()
      c = char( 10 ); %#ok
    end
    
    function tf = is_grouping_component(c)
      tf = c == '(' || c == ')' || c == '{' || c == '}' || c == '[' || c == ']';
    end

    function tf = is_terminal_grouping_component(c)
      tf = c == ')' || c == '}' || c == ']';
    end
    
    function tf = is_whitespace(a)
      tf = isstrprop( a, 'wspace' );
    end

    function tf = is_digit(a)
      tf = a >= '0' && a <= '9';
    end

    function tf = is_alpha(a)
      tf = (a >= 'A' && a <= 'Z') || (a >= 'a' && a <= 'z');
    end

    function tf = is_identifier_component(a)
      import mt.Scanner;
      
      tf = Scanner.is_alpha_numeric( a ) || a == '_';
    end
    
    function tf = is_alpha_numeric(a)
      tf = (a >= 'A' && a <= 'Z') || (a >= 'a' && a <= 'z') || (a >= '0' && a <= '9');
    end
    
    function tf = is_keyword(str)
      tf = iskeyword( str ) || ismember( str, {'import'} );
    end

    function tf = is_transposable(c)
      import mt.Scanner;
      
      tf = c == Scanner.apostrophe() || c == '.' || Scanner.is_digit( c ) || ...
        Scanner.is_identifier_component(c) || Scanner.is_terminal_grouping_component( c );
    end
    
    function m = make_punctuation_map(types)
      import mt.Scanner;
      
      punct = { ...
          '{', '}', '[', ']', '(', ')', '.', ',', ';', ':', Scanner.apostrophe(), '"' ...
        , '=', '~', '<', '>', '@' ...
        , '+', '-', '*', '/', '\' ...
        , '&', '|', '^', '?' ...
      };

      types = [ ...
          types.l_brace, types.r_brace, types.l_bracket, types.r_bracket ...
        , types.l_parens, types.r_parens, types.period, types.comma, types.semicolon ...
        , types.colon, types.apostrophe, types.quote, types.equal, types.not ...
        , types.less, types.greater, types.at ...
        , types.plus, types.minus, types.star, types.b_slash, types.f_slash ...
        , types.and, types.or, types.carat, types.q_mark ...
      ]; 

      m = containers.Map( punct, types );
    end
  end
end