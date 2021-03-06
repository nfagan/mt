function [errs, idents] = char_identifier_sequence(obj, term)

idents = {};
errs = mt.AstGenerator.empty_error();
types = obj.TokenTypes;
expect_identifier = true;

while ( ~ended(obj.Iterator) && peek_type(obj.Iterator) ~= term )
  tok = peek( obj.Iterator );
  t = mt.token.type( tok );
  e = mt.AstGenerator.empty_error();
  
  if ( expect_identifier && t ~= types.identifier )
    e = make_error_expected_token_type( obj, tok, [types.identifier, term] );
    
  elseif ( expect_identifier && t == types.identifier )
    idents{end+1} = mt.token.lexeme( tok, obj.Text, types );
    expect_identifier = false;    
    
  elseif ( ~expect_identifier && t == types.comma )
    expect_identifier = true;
    
  else
    e = make_error_expected_token_type( obj, tok, [types.comma, term] );
  end
  
  if ( ~isempty(e) )
    errs = [ errs, e ];
    break
  end
  
  advance( obj.Iterator );
end

if ( isempty(errs) )
  errs = make_error_if_unexpected_current_token( obj, term );
end

end