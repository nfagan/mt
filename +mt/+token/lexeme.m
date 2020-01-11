function l = lexeme(token, text, types)

import mt.token.*;

if ( type(token) == types.eof )
  l = '<eof>';
else
  l = text( start(token):stop(token) );
end

end