function [errs, node] = expression(obj, allow_empty)

if ( nargin < 2 )
  allow_empty = false;
end

types = obj.TokenTypes;

pending_binaries = {};
binaries = {};
unaries = {};
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
    
  elseif ( is_ignore_output_expr(obj, t, types) )
    [e, n] = ignore_output_expr( obj, t, types );
    
  elseif ( ismember(t, grouping_types(types)) )
    % (), [], {}
    [e, n] = grouping_expression( obj );
    
  elseif ( is_literal_expr(t, types) )
    n = literal_expression( obj, tok, t, types );
    
  elseif ( t == types.end && is_inside_non_period_reference(obj) )
    n = mt.ast.EndIndexExpr();
    advance( obj.Iterator );
    
  elseif ( is_unary_prefix_expr(obj, t, types) )
    unaries = prefix_unary_expression( obj, unaries, tok );
    
  elseif ( mt.operator.is_binary(t, types) )
    if ( t == types.colon && is_colon_subscript(obj, types) )
      n = colon_subscript( obj, types );
    else
      [e, completed, binaries] = binary_expression( obj, completed, binaries, tok );
    end
    
  elseif ( t == types.at )
    [e, n] = anonymous_function_expression( obj );
    
  elseif ( ismember(t, terminator_types(types)) )
    break;
    
  elseif ( t == types.ellipsis )
    e = check_consume_ellipsis( obj );
    
    if ( isempty(e) )
      continue;
    end
    
  else
    e = make_error_invalid_expr_token( obj, tok );
  end
  
  if ( ~isempty(e) )
    errs = [ errs, e ];
    break;
  end
    
  if ( ~isempty(n) )
    completed{end+1} = n;
    [e, completed] = handle_postfix_unary_expressions( obj, completed );
    
    if ( ~isempty(e) )
      errs = [ errs, e ];
      break;
    end
  end
  
  if ( ~isempty(completed) )
    [completed, unaries] = update_prefix_unaries( completed, unaries );
  end

  if ( ~isempty(binaries) && ~isempty(completed) )
    [completed, binaries, pending_binaries] = ...
      update_binaries( obj, completed, binaries, pending_binaries, types );
  end
end

if ( ~isempty(errs) )
  return
end

% if ( numel(completed) == 1 )
%   node = completed{1};
% else
%   errs = make_error_incomplete_expr( obj, peek(obj.Iterator) );
% end

if ( numel(completed) == 1 )
  node = completed{1};
  
else
  is_complete = isempty( completed ) && isempty( pending_binaries ) && ...
    isempty( binaries ) && isempty( unaries );
  
  is_valid = is_complete && (allow_empty || ~isempty(node));
  
  if ( ~is_valid )
    errs = make_error_incomplete_expr( obj, peek(obj.Iterator) );
  end
end

end

function errs = check_consume_ellipsis(obj)

advance( obj.Iterator );

if ( ~consume(obj.Iterator, obj.TokenTypes.new_line) )
  errs = make_error_expected_token_type( obj, peek(obj.Iterator), types.new_line );
else
  errs = mt.AstGenerator.empty_error();
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

function tf = is_ignore_output_expr(obj, t, types)

% [~] = func() | [~, a] = func()

tf = false;

if ( t ~= types.not )
  return
end

next_t = peek_next_type( obj.Iterator );
tf = next_t == types.r_bracket || next_t == types.comma;

end

function [errs, node] = ignore_output_expr(obj, t, types)

errs = mt.AstGenerator.empty_error();
node = mt.ast.IgnoreFunctionArgument();

advance( obj.Iterator );  % consume `~`

end

function unaries = prefix_unary_expression(obj, unaries, tok)

advance( obj.Iterator );

type = mt.token.type( tok );
fixity = mt.operator.fixity( type, obj.TokenTypes );

unaries{end+1} = mt.ast.UnaryOperatorExpr( type, fixity, [] );

end

function [errs, completed] = handle_postfix_unary_expressions(obj, completed)

types = obj.TokenTypes;
errs = mt.AstGenerator.empty_error();

while ( ~ended(obj.Iterator) && isempty(errs) )
  next_tok = peek( obj.Iterator );
  next_type = mt.token.type( next_tok );
  prev_type = peek_prev_type( obj.Iterator );

  if ( mt.operator.is_unary_postfix(next_type, types) && ...
      is_postfix_unary_operable(prev_type, types) )
    [errs, completed] = postfix_unary_expression( obj, completed, next_tok );
  else
    break
  end
end

end

function [errs, completed] = postfix_unary_expression(obj, completed, tok)

if ( isempty(completed) )
  errs = make_error_expected_lhs( obj, tok );
  
else
  advance( obj.Iterator );
  
  type = mt.token.type( tok );
  fixity = mt.operator.fixity( type, obj.TokenTypes );
  
  expr = completed{end};
  completed{end} = mt.ast.UnaryOperatorExpr( type, fixity, expr );
  
  errs = mt.AstGenerator.empty_error();
end

end

function tf = is_literal_expr(t, types)
tf = ismember( t, [types.number_literal, types.char_literal, types.string_literal] );
end

function tf = is_unary_prefix_expr(obj, t, types)

tf = mt.operator.is_unary_prefix( t, types ) && ...
  (t == types.not || is_prefix_unary_operable(peek_prev_type(obj.Iterator), types));

% tf = mt.operator.is_unary_prefix( t, types ) && ...
%   is_prefix_unary_operable( peek_next_type(obj.Iterator), types ) && ...
%   ~is_prefix_unary_operable( peek_prev_type(obj.Iterator), types );

end

function tf = is_prefix_unary_operable(t, types)

% tf = ismember( t, [ ...
%   types.identifier, types.number_literal, types.char_literal ...
%   , mt.token.grouping_initiators(types) ...
% ]);

tf = ~ismember( t, [ ...
    types.identifier, types.number_literal, types.char_literal, types.string_literal ...
  , mt.token.grouping_terminators(types), types.end ...
]);

end

function tf = is_postfix_unary_operable(t, types)
  tf = ismember( t, [ ...
      types.identifier, types.number_literal, types.string_literal ...
    , mt.token.grouping_terminators(types) ...
    , types.apostrophe, types.dot_apostrophe ...
] );
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

function [completed, unaries] = update_prefix_unaries(completed, unaries)

while ( ~isempty(unaries) )
  un = unaries{end};
  un.Expr = completed{end};
  completed{end} = un;
  unaries(end) = [];
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
  
elseif ( t == types.char_literal )
  node = mt.ast.CharLiteralExpr.from_token_text( tok, obj.Text, types );
  
elseif ( t == types.string_literal )
  node = mt.ast.StringLiteralExpr.from_token_text( tok, obj.Text, types );
  
else
  error( 'Unhandled literal type "%d".', t );
end

advance( obj.Iterator );

end

function ts = possible_types(types)
ts = [ types.identifier, types.number_literal, types.char_literal, types.colon ];
end

function ts = terminator_types(types)
ts = [ ...
    types.semicolon, types.comma, types.new_line, types.eof ...
  , types.equal ...
  , types.r_parens, types.r_brace, types.r_bracket ...
];
end

function ts = grouping_types(types)
ts = [ types.l_parens, types.l_bracket, types.l_brace ];
end