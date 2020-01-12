function [errs, node] = type_specifier(obj)

types = obj.TokenTypes;
t = peek_type( obj.Iterator );
next_t = peek_next_type( obj.Iterator );

is_func = t == types.l_bracket || (t == types.identifier && next_t == types.equal);

node = [];
errs = [];

allowed_types = possible_types( types );

if ( is_func )
  [errs, node] = function_type_specifier( obj );
  
else
  switch ( t )
    case types.identifier
      [errs, node] = single_type_specifier( obj );
      
    otherwise
      errs = make_error_expected_token_type( obj, peek(obj.Iterator), allowed_types );
  end
end

end

function ts = possible_types(types)
ts = [ types.identifier, types.l_bracket ];
end