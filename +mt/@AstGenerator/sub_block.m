function [errs, block_node] = sub_block(obj)

types = obj.TokenTypes;

block_node = mt.ast.Block();
errs = mt.AstGenerator.empty_error();

while ( ~ended(obj.Iterator) && peek_type(obj.Iterator) ~= types.end )
  t = peek_type( obj.Iterator );
  e = mt.AstGenerator.empty_error();
  node = [];

  switch ( t )
    case {types.new_line, types.eof}
      %
      
    case {types.else, types.elseif}
      break
      
    otherwise
      [e, node] = statement( obj );
  end
  
  if ( isempty(e) )
    advance( obj.Iterator );
    conditional_append( block_node, node );
  else
    advance_to( obj.Iterator, possible_types(types) );
    errs = [ errs, e ];
  end
end

if ( ~isempty(errs) )
  block_node = [];
end

end

function ts = possible_types(types)
ts = [types.end];
end