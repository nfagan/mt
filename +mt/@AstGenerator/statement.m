function [errs, node] = statement(obj)

types = obj.TokenTypes;
t = peek_type( obj.Iterator );

switch ( t )
  case types.if
    [errs, node] = if_statement( obj );
  
  case {types.for, types.parfor}
    [errs, node] = for_statement( obj );
    
  case types.while
    [errs, node] = while_statement( obj );
    
  case types.switch
    [errs, node] = switch_statement( obj );
    
  case types.try
    [errs, node] = try_statement( obj );
    
  case types.return
    [errs, node] = return_statement( obj );
    
  case {types.continue, types.break}
    [errs, node] = loop_control_statement( obj );
  
  otherwise
    [errs, node] = expression_statement( obj );
end

end