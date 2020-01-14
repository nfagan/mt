function [errs, node] = if_statement(obj)

advance( obj.Iterator );  % consume `if`

types = obj.TokenTypes;
node = [];

[errs, if_node] = if_branch( obj, types.if );

if ( ~isempty(errs) )
  return
end

elseif_nodes = mt.ast.Branch.empty();

while ( peek_type(obj.Iterator) == types.elseif && isempty(errs) )
  advance( obj.Iterator );
  
  [errs, elseif_node] = if_branch( obj, types.elseif );
  
  if ( isempty(errs) )
    elseif_nodes(end+1) = elseif_node;
  end
end

if ( ~isempty(errs) )
  return
end

if ( peek_type(obj.Iterator) == types.else )
  advance( obj.Iterator );
  [errs, else_block] = sub_block( obj );
else
  else_block = mt.ast.Block.empty();
end

if ( ~isempty(errs) )
  return;
end

if ( ~consume(obj.Iterator, types.end) )
  errs = make_error_expected_token_type( obj, peek(obj.Iterator), types.end );
else
  node = mt.ast.IfStmt( if_node, elseif_nodes, else_block );
end

end

function [errs, node] = if_branch(obj, type)

node = [];

[errs, if_cond] = expression( obj );

if ( ~isempty(errs) )
  return
end

[errs, if_block] = sub_block( obj );

if ( ~isempty(errs) )
  return
end

node = mt.ast.Branch( type, if_cond, if_block );

end