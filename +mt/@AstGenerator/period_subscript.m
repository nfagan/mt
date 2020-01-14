function [errs, node] = period_subscript(obj)

advance( obj.Iterator );  % consume `.`
[errs, expr] = expression( obj );

if ( isempty(errs) )
  node = mt.ast.Subscript( '.', {expr} );
else
  node = [];
end

end