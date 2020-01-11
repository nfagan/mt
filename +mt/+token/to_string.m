function s = to_string(token, text, types)

if ( nargin < 3 )
  lexeme = '';
else
  lexeme = mt.token.pretty_lexeme( token, text, types );
end

typename = mt.token.typename( mt.token.type(token) );

if ( ~isempty(lexeme) )
  s = sprintf( '%s: %s', typename, lexeme );
else
  s = typename;
end

end