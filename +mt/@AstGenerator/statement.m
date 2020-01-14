function [errs, node] = statement(obj)

types = obj.TokenTypes;
t = peek_type( obj.Iterator );

switch ( t )
  % if, try, etc.  
  case types.if
    [errs, node] = if_statement( obj );
  
  otherwise
    [errs, node] = expression_statement( obj );
end

end