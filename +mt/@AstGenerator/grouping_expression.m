function [errs, node] = grouping_expression(obj)

t = peek_type( obj.Iterator );
types = obj.TokenTypes;

term = terminator_for_type( t, types );
advance( obj.Iterator );  % consume `[`, etc.

node = [];
errs = mt.AstGenerator.empty_error();
exprs = mt.ast.GroupingExprComponent.empty();

while ( ~ended(obj.Iterator) && peek_type(obj.Iterator) ~= term )
  allow_empty = t == types.l_bracket || t == types.l_brace;
  [errs, n] = expression( obj, allow_empty );
  
  if ( ~isempty(errs) )
    break;
  end

  next_t = peek_type( obj.Iterator );
  delim = types.comma;
  
  switch ( next_t )
    case types.comma
      advance( obj.Iterator );
      
    case types.semicolon
      delim = types.semicolon;
      advance( obj.Iterator );
      
    case term
      %
      
    otherwise
      errs = make_error_expected_token_type( obj, peek(obj.Iterator) ...
        , possible_types(types, term) );
  end
  
  if ( ~isempty(n) )
    expr = mt.ast.GroupingExprComponent( n, delim );
    exprs(end+1) = expr;
  end
end

if ( ~isempty(errs) )
  return
end

if ( ~consume(obj.Iterator, term) )
  errs = make_error_expected_token_type( obj, peek(obj.Iterator), term );
  
else
  node = mt.ast.GroupingExpr( t, exprs );
end

end

function ts = possible_types(types, term)
ts = [ types.comma, types.semicolon, term ];
end

function t = terminator_for_type(t, types)

switch ( t )
  case types.l_bracket
    t = types.r_bracket;
    
  case types.l_parens
    t = types.r_parens;
    
  case types.l_brace
    t = types.r_brace;
  otherwise
    error( 'No such terminator for type: %d', t );
end

end