function [errs, node] = non_period_subscript(obj, method, term)

advance( obj.Iterator );  % consume `(` or `{`.

types = obj.TokenTypes;

args = {};
errs = mt.AstGenerator.empty_error();

while ( ~ended(obj.Iterator) && peek_type(obj.Iterator) ~= term )
  [errs, expr] = expression( obj );
  
  if ( isempty(errs) )
    args{end+1} = expr;
    
    if ( ~consume(obj.Iterator, types.comma) )
      break
    end
  else
    break
  end
end

if ( isempty(errs) )
  errs = make_error_if_unexpected_current_token( obj, term );
end

if ( isempty(errs) )
  advance( obj.Iterator );  % consume `term`
  node = mt.ast.Subscript( method, args );
else
  node = [];
end

end