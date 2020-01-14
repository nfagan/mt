function t = grouping_terminator(s, types)

switch ( s )
  case types.l_parens
    t = types.r_parens;
    
  case types.l_bracket
    t = types.r_bracket;
    
  case types.l_brace
    t = types.r_brace;
    
  otherwise
    error( 'No terminator exists for grouping type "%d".', s );
end

end