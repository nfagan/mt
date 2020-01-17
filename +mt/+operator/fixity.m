function f = fixity(type, types)

switch ( type )
  case {types.plus, types.minus, types.not}
    f = mt.operator.fixities.pre();
    
  case {types.apostrophe, types.dot_apostrophe}
    f = mt.operator.fixities.post();
    
  otherwise
    if ( mt.operator.is_binary(type, types) )
      f = mt.operator.fixities.in();
    else
      error( 'No fixity defined for type "%d".', type );
    end
end

end