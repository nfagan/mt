function [errs, node] = identifier_reference_expression(obj)

types = obj.TokenTypes;

node = [];
[errs, main_identifier] = char_identifier( obj );

if ( isempty(errs) )
  advance( obj.Iterator );
else
  return
end

t = peek_type( obj.Iterator );
subscript = mt.ast.Subscript.empty();

% Allow empty subscript.
switch ( t )
  case types.period
    [errs, subscript] = period_subscript( obj );
    
  case types.l_parens
    [errs, subscript] = non_period_subscript( obj, '()', types.r_parens );
    
  case types.l_brace
    [errs, subscript] = non_period_subscript( obj, '{}', types.r_brace );
end

if ( isempty(errs) )
  node = mt.ast.IdentifierReference( main_identifier, subscript );
end

end