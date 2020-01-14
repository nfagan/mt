function [errs, node] = expression(obj)

types = obj.TokenTypes;

pending_binaries = {};
binaries = {};
completed = {};

node = [];
errs = mt.AstGenerator.empty_error();

while ( ~ended(obj.Iterator) )
  n = [];
  e = mt.AstGenerator.empty_error();
  
  tok = peek( obj.Iterator );
  t = mt.token.type( tok );
  
  if ( t == types.identifier )
    [e, n] = identifier_reference_expression( obj );
    
  elseif ( ismember(t, grouping_types(types)) )
    [e, n] = grouping_expression( obj );
    
  elseif ( ismember(t, [types.number_literal, types.char_literal]) )
    n = literal_expression( obj, tok, t, types );
    
  elseif ( mt.operator.is_binary(t, types) )
    if ( t == types.colon && is_colon_subscript(obj, types) )
      n = colon_subscript( obj, types );
    else
      [e, completed, binaries] = binary_expression( obj, completed, binaries, tok );
    end
    
  elseif ( ismember(t, terminator_types(types)) )
    break;
    
  else
    e = make_error_expected_token_type( obj, tok, possible_types(types) );
  end
  
  if ( ~isempty(e) )
    errs = [ errs, e ];
    break;
  end
    
  if ( ~isempty(n) )
    completed{end+1} = n;
  end

  if ( ~isempty(binaries) && ~isempty(completed) )
    [completed, binaries, pending_binaries] = ...
      update_binaries( obj, completed, binaries, pending_binaries, types );
  end
end

if ( ~isempty(errs) )
  return
end

if ( numel(completed) == 1 )
  node = completed{1};
else
  errs = make_error_incomplete_expr( obj, peek(obj.Iterator) );
end

end

function tf = is_colon_subscript(obj, types)

next_t = peek_next_type( obj.Iterator );
tf = ismember( next_t, ...
  [types.r_parens, types.r_brace, types.r_bracket, types.comma] ...
);

end

function node = colon_subscript(obj, types)

node = mt.ast.ColonSubscript();
advance( obj.Iterator );  % consume `:`

end

function [e, completed, binaries] = binary_expression(obj, completed, binaries, tok)

e = mt.AstGenerator.empty_error();

if ( isempty(completed) )
  e = make_error_expected_lhs( obj, tok );
  
else
  left = completed{end};
  completed(end) = [];
  binaries{end+1} = mt.ast.BinaryOperatorExpr( mt.token.type(tok), left, [] );
  
  advance( obj.Iterator );  % Consume token.
end

end

function [completed, binaries, pending] = update_binaries(obj, completed, binaries, pending, types)

bin = binaries{end};
binaries(end) = [];

prec_curr = mt.operator.precedence( bin.OperatorType, types );
prec_next = mt.operator.precedence( peek_type(obj.Iterator), types );

if ( prec_curr < prec_next )
  pending{end+1} = bin;
  
else
  assert( isempty(bin.RightExpr) );
  complete = completed{end};
  bin.RightExpr = complete;
  completed{end} = bin;
  
  while ( ~isempty(pending) && prec_next < prec_curr )
    pend = pending{end};
    prec_curr = mt.operator.precedence( pend.OperatorType, types );
    pend.RightExpr = completed{end};
    completed{end} = pend;
    
    pending(end) = [];
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
ts = [ types.identifier, types.number_literal, types.char_literal, types.colon ];
end

function ts = terminator_types(types)
ts = [ ...
    types.semicolon, types.comma, types.new_line ...
  , types.equal ...
  , types.r_parens, types.r_brace, types.r_bracket ...
];
end

function ts = grouping_types(types)
ts = [ types.l_parens, types.l_bracket, types.l_brace ];
end