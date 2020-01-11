function disp(tokens, text, types)

if ( isempty(tokens) )
  return
end

n = mt.token.count( tokens );
token_types = mt.token.type( tokens );
names = mt.token.typenames( token_types );
num_largest_name = max( cellfun(@numel, names) );

for i = 1:n
  t = mt.token.nth( tokens, i );
  type = mt.token.type( t );

  typename = mt.token.typename( type );
  lexeme = mt.token.pretty_lexeme( t, text, types );
  
  num_spaces = num_largest_name - numel( typename );
  space_str = repmat( ' ', 1, num_spaces );

  fprintf( '\n %s%s: %s', space_str, typename, lexeme );
end

fprintf( '\n' );

end