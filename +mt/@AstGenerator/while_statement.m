function [errs, node] = while_statement(obj)

advance( obj.Iterator );  % consume `while`

node = [];
types = obj.TokenTypes;

[errs, condition] = expression( obj );

if ( ~isempty(errs) )
  return
end

[errs, body] = sub_block( obj );

if ( ~isempty(errs) )
  return
end

errs = make_error_if_unexpected_current_token( obj, types.end );

if ( ~isempty(errs) )
  return
end

node = mt.ast.WhileStmt( condition, body );

end