function [errs, node] = identifier_reference_expression(obj)

types = obj.TokenTypes;

node = [];
[errs, main_identifier] = char_identifier( obj );

if ( isempty(errs) )
  advance( obj.Iterator );
else
  return
end

subscript = mt.ast.Subscript.empty();

while ( ~ended(obj.Iterator) && isempty(errs) )
  t = peek_type( obj.Iterator );
  
  % Allow empty subscript.
  switch ( t )
    case types.period
      [errs, s] = period_subscript( obj );

    case types.l_parens
      [errs, s] = non_period_subscript( obj, '()', types.r_parens );

    case types.l_brace
      [errs, s] = non_period_subscript( obj, '{}', types.r_brace );
      
    otherwise
      break
  end
  
  if ( isempty(errs) )
    subscript = [ subscript, s ];
  end
end

if ( isempty(errs) )
  node = mt.ast.IdentifierReference( main_identifier, subscript );
end

end