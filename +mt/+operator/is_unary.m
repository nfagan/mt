function tf = is_unary(type, types)

tf = mt.operator.is_unary_prefix( type, types ) || ...
  mt.operator.is_unary_postfix( type, types );

end