function [errs, info_node] = type_info(obj)

types = obj.TokenTypes;
info_node = [];

t = peek_type( obj.Iterator );

switch ( t )      
  case types.begin
    [errs, anno] = begin( obj );

  case types.given
    [errs, anno] = given( obj );

  case types.let
    [errs, anno] = let( obj );

  otherwise
    tok = peek( obj.Iterator );
    errs = make_error_expected_token_type( obj, tok, possible_types(types) );
end

if ( isempty(errs) )
  info_node = mt.ast.TypeAnnotation( anno );
end

end

function ts = possible_types(types)
ts = [ types.begin, types.given, types.let ];
end