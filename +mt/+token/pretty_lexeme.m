function lexeme = pretty_lexeme(token, text, types)

type = mt.token.type( token );

if ( type == types.new_line )
  % Don't display new line.
  lexeme = '';
  
elseif ( type == types.eof )
  lexeme = '<eof>';
  
elseif ( type == types.t_end )
  lexeme = '<t_end>';
  
else
  lexeme = text( mt.token.start(token):mt.token.stop(token) );
end

if ( type == types.char_literal )
  lexeme = sprintf( '''%s''', lexeme );
  
elseif ( type == types.string_literal )
  lexeme = sprintf( '"%s"', lexeme );
end

end