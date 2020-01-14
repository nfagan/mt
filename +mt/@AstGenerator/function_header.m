function [errs, name, inputs, outputs] = function_header(obj)

name = '';
inputs = {};
outputs = {};

types = obj.TokenTypes;

[errs, outputs] = handle_outputs( obj, types );

if ( ~isempty(errs) )
  return
end

if ( ~isempty(outputs) )
  errs = make_error_if_unexpected_current_token( obj, types.equal );
  
  if ( isempty(errs) )
    advance( obj.Iterator );
  else
    return
  end
end

% function name
[errs, name] = char_identifier( obj );

if ( isempty(errs) )
  advance( obj.Iterator );
else
  return
end

[errs, inputs] = handle_inputs( obj, types );

end

function [errs, inputs] = handle_inputs(obj, types)

errs = [];
inputs = {};

if ( peek_type(obj.Iterator) == types.l_parens )
  advance( obj.Iterator );
  
  [errs, inputs] = char_identifier_sequence( obj, types.r_parens );
  
  if ( isempty(errs) )
    advance( obj.Iterator );
  end
end

end

function [errs, outputs] = handle_outputs(obj, types)

outputs = {};
errs = [];

t = peek_type( obj.Iterator );

if ( t == types.l_bracket )
  advance( obj.Iterator );
  [errs, outputs] = char_identifier_sequence( obj, types.r_bracket );
  
  if ( isempty(errs) )
    advance( obj.Iterator );  % consume ]
  end
elseif ( t == types.identifier )
  next_tok = peek_next( obj.Iterator );
  is_single_output = mt.token.type( next_tok ) == types.equal;
  
  if ( is_single_output )
    outputs = { mt.token.lexeme(peek(obj.Iterator), obj.Text, types) };
    advance( obj.Iterator );
  end
else
  errs = make_error_expected_token_type( obj, peek(obj.Iterator), possible_types(types) );
end

end

function ts = possible_types(types)
ts = [ types.l_bracket, types.identifier ];
end