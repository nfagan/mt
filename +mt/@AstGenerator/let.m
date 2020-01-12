function [errs, node] = let(obj)

advance( obj.Iterator );  % consume `let`.

types = obj.TokenTypes;
node = [];
ident = '';

errs = make_error_if_unexpected_current_token( obj, types.identifier );

if ( isempty(errs) )
  ident = mt.token.lexeme( peek(obj.Iterator), obj.Text, types );
  advance( obj.Iterator );
else
  return
end

errs = make_error_if_unexpected_current_token( obj, types.equal );

if ( isempty(errs) )
  advance( obj.Iterator );
else
  return
end

[errs, type] = type_specifier( obj );

if ( isempty(errs) )
  node = mt.ast.Let( ident, type );
end

end