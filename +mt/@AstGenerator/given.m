function [errs, node] = given(obj)

advance( obj.Iterator );  % consume `given`.
types = obj.TokenTypes;

[errs, idents] = handle_identifiers( obj, types );
node = [];

if ( ~isempty(errs) )
  return
end

t = peek_type( obj.Iterator );
decl = [];

switch ( t )
  case types.let
    [errs, decl] = let( obj );
    
  otherwise
    errs = make_error_expected_token_type( obj, peek(obj.Iterator), [types.let] );
end

if ( ~isempty(decl) )
  node = mt.ast.Given( idents, decl );
end

end

function [errs, idents] = handle_identifiers(obj, types)

idents = {};
tok = peek( obj.Iterator );
errs = [];

if ( mt.token.type(tok) == types.less )
  advance( obj.Iterator );
  
  [errs, idents] = char_identifier_sequence( obj, types.greater );
  
  if ( ~isempty(errs) )
    return
  end
  
elseif ( mt.token.type(tok) == types.identifier )
  idents = { mt.token.lexeme(tok, obj.Text, types) };
  
else
  errs = make_error_expected_token_type( obj, tok, [types.identifier, types.less] );
  
end

if ( isempty(errs) )
  advance( obj.Iterator );  % consume terminator or identifier.
end

end