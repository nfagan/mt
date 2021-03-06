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
prev_subscript = mt.ast.Subscript.empty();

while ( ~ended(obj.Iterator) && isempty(errs) )
  tok = peek( obj.Iterator );
  t = mt.token.type( tok );
  
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
  
  if ( ~isempty(errs) )
    break
  end
  
  if ( ~isempty(prev_subscript) && strcmp(prev_subscript.Method, '()') && ...
      ~strcmp(s.Method, '.') )
    errs = make_error_reference_after_parens_reference_expr( obj, tok );
  else
    prev_subscript = s;
    subscript = [ subscript, s ];
  end
end

if ( isempty(errs) )
  node = mt.ast.IdentifierReference( main_identifier, subscript );
end

end