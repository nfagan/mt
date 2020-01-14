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
  if ( is_valid_assignment_target(expr, types) )
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
  node = mt.ast.AssignmentStmt( expr, rhs );
else
  node = mt.ast.ExpressionStmt( expr );
end

end

function tf = is_valid_assignment_target(expr, types)

% TODO: Make this visitor-based / abstract method-based
if ( isa(expr, 'mt.ast.IdentifierReference') )
  tf = true;
  
elseif ( isa(expr, 'mt.ast.GroupingExpr') )
  tf = is_valid_multiple_assignment_target( expr, types );
  
else
  tf = false;
end

end

function tf = is_valid_multiple_assignment_target(expr, types)

tf = false;

if ( expr.BeginType ~= types.l_bracket || isempty(expr.Exprs) )
  % (a, b) = ... | {a, b} = ... | [] = ...
  return
end

delims = [ expr.Exprs.Delimiter ];
tf = all( delims == types.comma );

end