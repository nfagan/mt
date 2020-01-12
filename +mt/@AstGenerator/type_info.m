function [errs, info_node] = type_info(obj)

errs = mt.AstGenerator.empty_error();
types = obj.TokenTypes;

info_node = mt.ast.TypeInfo();

while ( ~ended(obj.Iterator) )
  node = [];
  e = mt.AstGenerator.empty_error();
  
  t = peek_type( obj.Iterator );
  
  switch ( t )      
    case types.begin
      [e, node] = begin( obj );
      
    case types.given
      [e, node] = given( obj );
      
    case types.let
      [e, node] = let( obj );
      
    case types.t_end
      break
      
    case {types.new_line, types.eof}
      %
      
    otherwise
      tok = peek( obj.Iterator );
      e = make_error_expected_token_type( obj, tok, possible_types(types) );
  end
  
  conditional_append( info_node, node );
  
  if ( ~isempty(e) )
    errs = [ errs, e ];
    
    % Don't mark additional parse errors, skip to the next valid type.
    advance_until( obj.Iterator, possible_types(types) );
  else
    advance( obj.Iterator );
  end
end

if ( ~isempty(errs) )
  info_node = [];
end

end

function ts = possible_types(types)
ts = [ types.begin, types.given, types.let ];
end