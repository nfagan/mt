function tf = is_unary_prefix(type, types)

tf = ismember( type, [ ...
  types.plus, types.minus, types.not
]);

end