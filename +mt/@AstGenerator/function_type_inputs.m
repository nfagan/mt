function [errs, inputs] = function_type_inputs(obj)

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