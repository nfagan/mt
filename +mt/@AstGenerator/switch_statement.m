function [errs, node] = switch_statement(obj)

advance( obj.Iterator );  % consume `switch`

node = [];
types = obj.TokenTypes;

[errs, switch_expr] = expression( obj );

if ( ~isempty(errs) )
  return
end

cases = mt.ast.SwitchCase.empty();
otherwise_block = mt.ast.Block.empty();

while ( ~ended(obj.Iterator) && peek_type(obj.Iterator) ~= types.end )
  advance_to( obj.Iterator, [types.end, types.case, types.otherwise] );
  t = peek_type( obj.Iterator );
  
  if ( t == types.case )
    advance( obj.Iterator );
    
    [errs, case_expr] = expression( obj );
    
    if ( ~isempty(errs) )
      return
    end
    
    [errs, case_block] = sub_block( obj );
    
    if ( ~isempty(errs) )
      return
    end
    
    cases(end+1) = mt.ast.SwitchCase( case_expr, case_block );
  elseif ( t == types.otherwise )
    advance( obj.Iterator );
    
    [errs, otherwise_block] = sub_block( obj );
    
    if ( ~isempty(errs) )
      return
    end
  end
end

errs = make_error_if_unexpected_current_token( obj, types.end );

if ( ~isempty(errs) )
  return
end

node = mt.ast.SwitchStmt( switch_expr, cases, otherwise_block );

end