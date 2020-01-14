function [errs, node] = expression_statement(obj)

node = [];
initial_token = peek( obj.Iterator );
[errs, expr] = expression( obj );

if ( ~isempty(errs) )
  return
end

t = peek_type( obj.Iterator );
types = obj.TokenTypes;

is_assignment = false;
rhs = [];

if ( t == types.equal )
  if ( is_valid_assignment_target(expr) )
    is_assignment = true;
    advance( obj.Iterator );  % consume `=`
    [errs, rhs] = expression( obj );
  else
    errs = make_error_invalid_assignment_target( obj, initial_token );
  end
end

if ( ~isempty(errs) )  
  return
end

if ( is_assignment )
  node = mt.ast.AssignmentStatement( expr, rhs );
else
  node = mt.ast.ExpressionStatement( expr );
end

end

function tf = is_valid_assignment_target(expr)

% TODO: Make this visitor-based / abstract method-based
tf = isa( expr, 'mt.ast.IdentifierReference' );

end