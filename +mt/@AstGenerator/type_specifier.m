function [errs, node] = type_specifier(obj)

types = obj.TokenTypes;

node = [];

t = peek_type( obj.Iterator );
is_definitely_func = t == types.l_bracket;

if ( is_definitely_func )
  [errs, node] = function_type_specifier( obj );
  
elseif ( t == types.identifier )
  [errs, node] = single_type_specifier( obj );
  
  if ( isempty(errs) && peek_type(obj.Iterator) == types.equal )
    % e.g. double = (A)
    advance( obj.Iterator );
    [errs, inputs] = function_type_inputs( obj );
    
    if ( isempty(errs) )
      outputs = { node };
      node = mt.ast.FunctionType( inputs, outputs );
    end
  end
else
  tok = peek( obj.Iterator );
  errs = make_error_expected_token_type( obj, tok, possible_types(types) );
end

end

function ts = possible_types(types)
ts = [ types.identifier, types.l_bracket ];
end