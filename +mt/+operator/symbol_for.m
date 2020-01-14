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
  otherwise
    error( 'Unrecognized symbol for type %d', type );
end

end