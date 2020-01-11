function merge_compound_tokens(obj)

import mt.Scanner;

tokens = obj.Tokens;
tts = obj.TokenTypes;

if ( isempty(tokens) )
  return
end

[start_names, next_names, replace_names] = define_compound_components();

start_types = cellfun( @(x) tts.(x), start_names );
next_types = extract_types( next_names, tts, {} );
replace_types = cellfun( @(x) cellfun(@(y) tts.(y), x), replace_names, 'un', 0 );

types = mt.token.type( tokens );
replace_with = zeros( size(types) );
replace_sizes = zeros( size(types) );

for i = 1:numel(start_types)
  is_start_type = types == start_types(i);
  next_ts = next_types{i};

  for j = 1:numel(next_ts)
    next_t = next_ts{j};
    
    if ( iscell(next_t) )
      is_next_type = true( size(is_start_type) );
      replace_size = numel( next_t );
      
      for k = 1:numel(next_t)
        falses = false( k, 1 );
        is_next_type = is_next_type & ...
          [ types((k+1):end); falses ] == next_t{k};
      end
    else
      is_next_type = [ types(2:end); false ] == next_t;
      replace_size = 1;
    end
    
    is_compound = is_start_type & is_next_type;
    replace_with(is_compound) = replace_types{i}(j);
    replace_sizes(is_compound) = replace_size;
  end
end

to_rep = find( replace_with );
rep_sizes = replace_sizes(to_rep);

type_col = mt.token.type_column();
stop_col = mt.token.stop_column();

tokens(to_rep, type_col) = replace_with(to_rep);
tokens(to_rep, stop_col) = tokens(to_rep, stop_col) + rep_sizes;

offset = 0;

for i = 1:numel(to_rep)
  start_rem = to_rep(i)-offset + 1;
  stop_rem = start_rem + rep_sizes(i) - 1;
  rem_seq = start_rem:stop_rem;
  
  tokens(rem_seq, :) = [];
  offset = offset + rep_sizes(i);
end

obj.Tokens = tokens;

end

function [start_names, next_names, replace_names] = define_compound_components()

start_names = { 'equal', 'not', 'period', 'less', 'greater', 'and', 'or' };
next_names = { ...
    {'equal'}, {'equal'} ...
  , {'star', 'f_slash', 'b_slash', 'apostrophe', 'carat', {'period', 'period'}} ...
  , {'equal'}, {'equal'} ...
  , {'and'}, {'or'} ...
};
replace_names = { ...
    {'equal_equal'}, {'not_equal'} ...
  , {'dot_star', 'dot_f_slash', 'dot_b_slash', 'dot_apostrophe', 'dot_carat', 'ellipsis'} ...
  , {'less_equal'}, {'greater_equal'} ...
  , {'and_and'}, {'or_or'} ...
};

end

function out_ts = extract_types(names, types, out_ts)

if ( iscell(names) )
  tmp_ts = cell( size(names) );

  for i = 1:numel(names)
    n = names{i};
    tmp_ts{i} = extract_types( n, types, out_ts );
  end
  
  out_ts = [ out_ts, tmp_ts ];
else
  out_ts = types.(names);
end

end