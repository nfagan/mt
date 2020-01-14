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
  otherwise
    error( 'Unrecognized symbol for type %d', type );
end

end