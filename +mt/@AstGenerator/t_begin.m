function [errs, node] = t_begin(obj)

advance( obj.Iterator );  % consume `@t`

types = obj.TokenTypes;
t = peek_type( obj.Iterator );

switch ( t )
  case {types.l_bracket, types.identifier}
    [errs, node] = type_specifier( obj );
    
  otherwise
    [errs, node] = type_info( obj );
end

end