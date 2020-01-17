function [errs, node] = for_statement(obj)

type = peek_type( obj.Iterator );
advance( obj.Iterator );  % consume `for` or `parfor`

node = [];
[errs, ident] = char_identifier( obj );

if ( ~isempty(errs) )
  return
end

advance( obj.Iterator );
types = obj.TokenTypes;

if ( ~consume(obj.Iterator, types.equal) )
  errs = make_error_expected_token_type( obj, peek(obj.Iterator), types.equal );
  return
end

[errs, initializer] = expression( obj );

if ( ~isempty(errs) )
  return
end

[errs, body] = sub_block( obj );

if ( ~isempty(errs) )
  return
end

errs = make_error_if_unexpected_current_token( obj, types.end );

if ( ~isempty(errs) )
  return
end

node = mt.ast.ForStmt( type, ident, initializer, body );

end