function [errs, tokens] = process(obj, tokens, text)

errs = [];

it = mt.TokenIterator( tokens );
obj.Iterator = it;
obj.Text = text;

types = obj.TokenTypes;
insert_at_indices = [];

next_r_parens_is_anon_func_input_term = false;

while ( ~ended(it) )
  curr = peek( it );
  t = mt.token.type( curr );
  next = peek_next( it );
  prev = peek_prev( it );
  
  allow_r_parens_terminator = true;
  
  switch ( t )
    case types.l_bracket
      obj.BracketDepth = obj.BracketDepth + 1;
    case types.r_bracket
      obj.BracketDepth = obj.BracketDepth - 1;
    case types.l_brace
      obj.BraceDepth = obj.BraceDepth + 1;
    case types.r_brace
      obj.BraceDepth = obj.BraceDepth - 1;
  end
  
  if ( obj.BracketDepth < 0 || obj.BraceDepth < 0 )
    errs = maker_error_unbalanced_bracket_or_brace( obj, peek(it) );
    return
  end
  
  if ( t == types.at && mt.token.type(next) == types.l_parens )
    next_r_parens_is_anon_func_input_term = true;
    
  elseif ( next_r_parens_is_anon_func_input_term && t == types.r_parens )
    next_r_parens_is_anon_func_input_term = false;
    allow_r_parens_terminator = false;
  end
  
  if ( (obj.BracketDepth > 0 || obj.BraceDepth > 0) && allow_r_parens_terminator )
    if ( can_insert_comma_between(curr, next, types) )
      insert_at_indices(end+1) = it.I;
      
    elseif ( t == types.new_line )
      tokens(it.I, mt.token.type_column()) = types.semicolon;
    end
  end
  
  advance( obj.Iterator );
end

offset = 0;

for i = 1:numel(insert_at_indices)
  insert_at = insert_at_indices(i) + offset;
  
  start_slice = tokens(1:insert_at, :);
  rest_slice = tokens(insert_at+1:end, :);
  
  tok_start = mt.token.stop( tokens(insert_at, :) ) + 1;
  tok_stop = tok_start + 1;
  
  tok = mt.token.new( tok_start, tok_stop, types.comma );
  
  tokens = [ start_slice; tok; rest_slice ];
  offset = offset + 1;
end

end

% Without space, insert comma before:
%   unary -> grouping_initiator
%   unary -> literal
%   unary -> identifier

function tf = can_insert_comma_between(curr, next, types)

% If space between, insert comma between:
%   identifier          -> grouping_initiator     [a ()]
%   literal             -> grouping_initiator     [2 ()]
%   postfix_operator    -> grouping_initiator     [2.' ()]
%   grouping_terminator -> grouping_initiator     [[] []]
%   grouping_terminator -> identifier             [[] a]
%   grouping_terminator -> literal                [[] 1]

%   identifier          -> identifier             [a a]
%   literal             -> literal                [1 1]
%   identifier          -> literal                [a 1]
%   literal             -> identifier             [1 b]

t = mt.token.type( curr );

inits = mt.token.grouping_initiators( types );
terms = mt.token.grouping_terminators( types );
literals = mt.token.literals( types );

first_is_lit_or_ident = ismember( t, [types.identifier, literals] );
first_is_term = ismember( t, terms );
first_is_postfix = mt.operator.is_unary_postfix( t, types );

tf = first_is_lit_or_ident || first_is_term || first_is_postfix;

if ( ~tf )
  return
end

tf = mt.token.start( next ) - mt.token.stop( curr ) > 1;

if ( ~tf )
  % No space between next token and current token.
  return
end

next_t = mt.token.type( next );
tf = ismember( next_t, [types.identifier, literals, inits] );

end