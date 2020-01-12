function errs = main_scan(obj)

import mt.Scanner;

types = obj.TokenTypes;
errs = Scanner.empty_error();

while ( obj.I < obj.Eof )
  c = peek( obj );

  if ( Scanner.is_alpha(c) )
    add_token( obj, identifier_or_keyword_token(obj) );

  elseif ( Scanner.is_digit(c) )
    add_token( obj, numeric_token(obj) );

  elseif ( Scanner.is_whitespace(c) )
    conditional_add_token( obj, check_whitespace_token(obj) );

  elseif ( c == '%' )
    handle_comment( obj );

  elseif ( c == '"' )
    [e, token] = string_literal_token( obj, types.string_literal, '"' );
    errs = conditional_add_token_check_err( obj, token, errs, e );

  else
    if ( c == Scanner.apostrophe() && ~Scanner.is_transposable(peek_prev(obj)) )
      % char literal
      [e, token] = string_literal_token( obj, types.char_literal, Scanner.apostrophe() );
      errs = conditional_add_token_check_err( obj, token, errs, e );
      
    else
      conditional_add_token( obj, check_punctuation_token(obj) );
    end
  end

  obj.I = obj.I + 1;
end

% Add sentinel token
add_token( obj, make_token(obj, 0, 0, obj.TokenTypes.eof) );

end