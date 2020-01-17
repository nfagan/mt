function s = symbol_for(type, types)

switch ( type )
  case types.plus
    s = '+';
  case types.minus
    s = '-';
  case types.f_slash
    s = '/';
  case types.b_slash
    s = '\';
  case types.star
    s = '*';
  case types.dot_star
    s = '.*';
  case types.dot_f_slash
    s = './';
  case types.dot_b_slash
    s = '.\';
  case types.comma
    s = ',';
  case types.semicolon
    s = ';';
  case types.colon
    s = ':';
  case types.l_parens
    s = '(';
  case types.l_bracket
    s = '[';
  case types.l_brace
    s = '{';
  case types.r_parens
    s = ')';
  case types.r_bracket
    s = ']';
  case types.r_brace
    s = '}';
  case types.equal_equal
    s = '==';
  case types.not
    s = '~';
  case types.not_equal
    s = '~=';
  case types.apostrophe
    s = mt.characters.apostrophe();
  case types.dot_apostrophe
    s = '.''';
  case types.greater
    s = '>';
  case types.less
    s = '<';
  case types.greater_equal
    s = '>=';
  case types.less_equal
    s = '<=';
  case types.and
    s = '&';
  case types.and_and
    s = '&&';
  case types.or
    s = '|';
  case types.or_or
    s = '||';
  case types.carat
    s = '^';
  case types.dot_carat
    s = '.^';
  otherwise
    error( 'Unrecognized symbol for type %d', type );
end

end