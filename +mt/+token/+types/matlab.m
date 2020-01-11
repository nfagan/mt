function types = matlab()

persistent t;

if ( isempty(t) )
  t = make_types();
end

types = t;

end

function types = make_types()

kws = iskeyword();
class_kws = { 'methods', 'properties', 'events', 'enumeration' };
addtl_kws = { 'import' };
kws = [ kws(:); class_kws(:); addtl_kws(:) ];

types = struct();
offset = 1;

for i = 1:numel(kws)
  types.(kws{i}) = offset;
  offset = offset + 1;
end

% punctuation
punct = { ...
    'l_parens', 'r_parens', 'l_brace', 'r_brace', 'l_bracket', 'r_bracket' ...
  , 'equal', 'not', 'colon', 'semicolon', 'period', 'comma' ...
  , 'plus', 'minus', 'star', 'f_slash', 'b_slash', 'at', 'new_line' ...
  , 'less', 'greater', 'q_mark', 'apostrophe', 'quote' ...
  , 'or', 'and', 'carat' ...
};

compound_punct = { 'equal_equal', 'not_equal', 'dot_star', 'dot_f_slash', 'dot_b_slash' ...
  , 'dot_apostrophe', 'dot_carat', 'less_equal', 'greater_equal', 'ellipsis' ...
  , 'or_or', 'and_and' };

punct = [ punct, compound_punct ];

for i = 1:numel(punct)
  types.(punct{i}) = offset;
  offset = offset + 1;
end

% parsed
literals = { 'identifier', 'char_literal', 'string_literal', 'number_literal' };

for i = 1:numel(literals)
  types.(literals{i}) = offset;
  offset = offset + 1;
end

end