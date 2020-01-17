function [errs, node] = period_subscript(obj)

advance( obj.Iterator );  % consume `.`

types = obj.TokenTypes;
t = peek_type( obj.Iterator );

switch ( t )
  case types.identifier
    [errs, expr] = literal_fieldname_reference( obj );
%     [errs, expr] = identifier_reference_expression( obj );
    
  case types.l_parens
    [errs, expr] = dynamic_fieldname_reference( obj, types );
    
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

function [errs, expr] = literal_fieldname_reference(obj)

[errs, ident] = char_identifier( obj );

if ( ~isempty(errs) )
  return
end

advance( obj.Iterator );
expr = mt.ast.LiteralFieldReferenceExpr( ident );

end

function [errs, expr] = dynamic_fieldname_reference(obj, types)

advance( obj.Iterator );
[errs, expr] = expression( obj );

if ( ~consume(obj.Iterator, types.r_parens) )
  errs = make_error_expected_token_type( obj, peek(obj.Iterator), types.r_parens );
else
  expr = mt.ast.DynamicFieldReferenceExpr( expr );
end

end