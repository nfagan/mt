function [errs, nodes] = multiple_type_specifiers(obj, term)

errs = [];
nodes = {};
types = obj.TokenTypes;

while ( ~ended(obj.Iterator) && peek_type(obj.Iterator) ~= term && isempty(errs) )
  [errs, node] = type_specifier( obj );
  
  if ( isempty(errs) )
    t = peek_type( obj.Iterator );
    
    if ( t == types.comma )
      advance( obj.Iterator );
    elseif ( t ~= term )
      errs = make_error_expected_token_type( obj, peek(obj.Iterator) ...
        , [types.comma, term] );
      break;
    end
    
    nodes{end+1} = node;
  end
end

if ( isempty(errs) )
  errs = make_error_if_unexpected_current_token( obj, term );
end

end