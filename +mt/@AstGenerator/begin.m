function [errs, node] = begin(obj)

types = obj.TokenTypes;
advance( obj.Iterator );  % consume `begin`

exported = handle_export( obj, types );

node = mt.ast.Begin( exported );
errs = mt.AstGenerator.empty_error();

while ( ~ended(obj.Iterator) && peek_type(obj.Iterator) ~= types.t_end )  
  t = peek_type( obj.Iterator );
  e = mt.AstGenerator.empty_error();

  switch ( t )
    case {types.new_line, types.eof}
      %
    otherwise
      [e, info_node] = type_info( obj );

      if ( isempty(e) )
        append( node, info_node );
      end
  end
  
  if ( isempty(e) )
    advance( obj.Iterator );
  else
    advance_to( obj.Iterator, possible_types(types) );
    errs = [ errs, e ];
  end
end

if ( isempty(errs) )
  errs = make_error_if_unexpected_current_token( obj, types.t_end );
else
  node = [];
end

end

function exported = handle_export(obj, types)

if ( peek_type(obj.Iterator) == types.export )
  exported = true;
  advance( obj.Iterator );
else
  exported = false;
end

end

function ts = possible_types(types)
ts = [ types.begin, types.given, types.let, types.t_end ];
end