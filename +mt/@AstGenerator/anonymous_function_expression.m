function [errs, node] = anonymous_function_expression(obj)

advance( obj.Iterator );  % consume `@`
types = obj.TokenTypes;

node = [];
errs = mt.AstGenerator.empty_error();

if ( peek_type(obj.Iterator) == types.identifier )
  [errs, expr] = identifier_reference_expression( obj );
%   [errs, ident] = char_identifier( obj );
  
  if ( ~isempty(errs) )
    return
  end
  
%   advance( obj.Iterator );
  node = mt.ast.FunctionReferenceExpr( expr );
  return
end

if ( ~consume(obj.Iterator, types.l_parens) )
  errs = make_error_expected_token_type( obj, peek(obj.Iterator), types.l_parens );
  return
end

[errs, input_identifiers] = char_identifier_sequence( obj, types.r_parens );

if ( ~isempty(errs) )
  return
end

advance( obj.Iterator );  % consume `)`
[errs, expr] = expression( obj );

if ( ~isempty(errs) )
  return
end

node = mt.ast.AnonymousFunctionExpr( input_identifiers, expr );

end