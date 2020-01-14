function [errs, node] = expression(obj, lhs)

if ( nargin < 2 )
  lhs = [];
end

types = obj.TokenTypes;

node = [];
errs = mt.AstGenerator.empty_error();

tok = peek( obj.Iterator );
t = mt.token.type( tok );

switch ( t )
  case types.identifier
    [errs, node] = identifier_reference_expression( obj );
    
  case {types.number_literal, types.char_literal}
    node = literal_expression( obj, tok, t, types );
    
  case {types.semicolon}
    return
    
  otherwise
    errs = make_error_expected_token_type( obj, tok, possible_types(types) );
end

if ( ~isempty(errs) )
  return
end

[errs, node] = handle_binary_expression( obj, node, lhs, types );

if ( ~isempty(errs) )
  node = [];
end

end

function [errs, node] = handle_binary_expression(obj, node, lhs, types)

errs = [];
it = obj.Iterator;

while ( ~ended(it) && mt.operator.is_binary(peek_type(it), types) && isempty(errs) )
  next_t = peek_type( it );
  
  if ( isempty(lhs) )
    pending = mt.ast.BinaryOperatorExpr( next_t, node, [] );
    advance( obj.Iterator );
  
    [errs, node] = expression( obj, pending );
    
    if ( isempty(pending.RightExpr) )
      pending.RightExpr = node;
      node = pending;
    end
  else
    left_t = lhs.OperatorType;
    prec_left = mt.operator.precedence( left_t, types );
    prec_curr = mt.operator.precedence( next_t, types );
    
    if ( prec_left > prec_curr )
      lhs.RightExpr = node;
      node = lhs;
      break
    else      
      pending = mt.ast.BinaryOperatorExpr( next_t, node, [] );
      advance( obj.Iterator );
      
      [errs, rhs] = expression( obj, pending );
      
      if ( isempty(lhs.RightExpr) )
        lhs.RightExpr = rhs;
        node = lhs;
      else
        assert( isempty(pending.RightExpr) );
        pending.RightExpr = rhs;
        node = pending;
      end
    end
  end
end

end

function node = literal_expression(obj, tok, t, types)

if ( t == types.number_literal )
  node = mt.ast.NumberLiteralExpr.from_token_text( tok, obj.Text, types );
else
  node = mt.ast.CharLiteralExpr.from_token_text( tok, obj.Text, types);
end

advance( obj.Iterator );

end

function ts = possible_types(types)
ts = [types.identifier, types.number_literal, types.char_literal];
end