function [errs, node] = try_statement(obj)

advance( obj.Iterator );  % consume `try`
types = obj.TokenTypes;
node = [];

[errs, try_block] = sub_block( obj );

if ( ~isempty(errs) )
  return
end

catch_expr = [];
catch_block = mt.ast.Block.empty();

if ( peek_type(obj.Iterator) == types.catch )
  advance( obj.Iterator );
  
  if ( peek_type(obj.Iterator) ~= types.new_line )
    [errs, catch_expr] = expression( obj );
    
    if ( ~isempty(errs) )
      return
    end
  end
  
  [errs, catch_block] = sub_block( obj );
  
  if ( ~isempty(errs) )
    return
  end
end

errs = make_error_if_unexpected_current_token( obj, types.end );

if ( ~isempty(errs) )
  return
end

node = mt.ast.TryStmt( try_block, catch_expr, catch_block );

end