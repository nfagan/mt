function [errs, node] = function_type_specifier(obj)

node = [];
[errs, outputs] = handle_outputs( obj );

if ( ~isempty(errs) )
  return
end

errs = make_error_if_unexpected_current_token( obj, obj.TokenTypes.equal );

if ( ~isempty(errs) )
  return
end

advance( obj.Iterator );  % consume =

[errs, inputs] = handle_inputs( obj );

if ( isempty(errs) )
  node = mt.ast.FunctionType( inputs, outputs );
end

end

function [errs, inputs] = handle_inputs(obj)

inputs = {};

types = obj.TokenTypes;
curr_type = peek_type( obj.Iterator );

if ( curr_type == types.l_parens )
  advance( obj.Iterator );
  
  [errs, inputs] = multiple_type_specifiers( obj, types.r_parens );
  
  if ( isempty(errs) )
    advance( obj.Iterator );
  end  
else
  errs = make_error_expected_token_type( obj, peek(obj.Iterator), [types.l_parens] );
end

end

function [errs, outputs] = handle_outputs(obj)

outputs = {};

types = obj.TokenTypes;
curr_type = peek_type( obj.Iterator );

if ( curr_type == types.l_bracket )
  advance( obj.Iterator );
  
  [errs, outputs] = multiple_type_specifiers( obj, types.r_bracket );
  
  if ( isempty(errs) )
    advance( obj.Iterator );
  end
elseif ( curr_type == types.identifier )
  [errs, output] = single_type_specifier( obj );
  
  if ( isempty(errs) )
    outputs = { output };
  end
  
else
  errs = make_error_expected_token_type( obj, peek(obj.Iterator) ...
    , [types.l_bracket, types.identifier] );
end

end