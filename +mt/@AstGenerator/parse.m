function [errs, tree] = parse(obj, tokens, text)

import mt.*;

it = TokenIterator( tokens );
obj.Iterator = it;
obj.Text = text;

[errs, tree] = block( obj );

if ( isempty(errs) )
  errs = mt.ParseError.empty();
end

end