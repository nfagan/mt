function [errs, tree] = parse(obj, tokens, text)

import mt.*;

it = TokenIterator( tokens );
obj.Iterator = it;
obj.Text = text;

[errs, tree] = block( obj );

if ( isempty(errs) )
  errs = mt.ParseError.empty();
else
  tree = mt.ast.Block.empty();
end

end