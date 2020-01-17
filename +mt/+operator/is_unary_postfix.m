function tf = is_unary_postfix(type, types)

tf = ismember( type, [ ...
  types.apostrophe, types.dot_apostrophe
]);

end