function [errs, node] = begin(obj)

types = obj.TokenTypes;
advance( obj.Iterator );  % consume `begin`

if ( peek_type(obj.Iterator) == types.export )
  exported = true;
  advance( obj.Iterator );
else
  exported = false;
end

[errs, info_node] = type_info( obj );

if ( isempty(errs) )
  errs = make_error_if_unexpected_current_token( obj, types.t_end );
end

if ( ~isempty(info_node) )
  node = mt.ast.Begin( info_node, exported );
else
  node = [];
end

end