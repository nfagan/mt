function [errs, node] = period_subscript(obj)

advance( obj.Iterator );  % consume `.`

types = obj.TokenTypes;
t = peek_type( obj.Iterator );

switch ( t )
  case types.identifier
    [errs, expr] = identifier_reference_expression( obj );
    
  case types.l_parens
    [errs, expr] = expression( obj );
    
  otherwise
    errs = make_error_expected_token_type( obj, peek(obj.Iterator) ...
      , [types.identifier, types.l_parens] );
end

if ( isempty(errs) )
  node = mt.ast.Subscript( '.', {expr} );
else
  node = [];
end

end