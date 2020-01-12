function [errs, node] = single_type_specifier(obj)

errs = [];
node = [];

tok = peek( obj.Iterator );
types = obj.TokenTypes;

advance( obj.Iterator );  % consume identifier
      
main_ident = mt.token.lexeme( tok, obj.Text, types );
type_args = {};

if ( peek_type(obj.Iterator) == types.less )
  advance( obj.Iterator );  % consume <
  [errs, type_args] = multiple_type_specifiers( obj, types.greater );

  if ( isempty(errs) )
    advance( obj.Iterator );  % consume >
  end
end

if ( isempty(errs) )
  node = mt.ast.TypeIdentifier( main_ident, type_args );
end

end