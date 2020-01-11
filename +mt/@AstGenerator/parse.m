function errs = parse(obj, tokens, text)
import mt.*;

types = obj.TokenTypes;
errs = AstGenerator.empty_error;

it = TokenIterator( tokens );

obj.Iterator = it;
obj.Text = text;

while ( ~ended(it) )
  t = peek_type( it );
  err = [];

  switch ( t )
    case types.function
%       err = function_definition( obj );
    otherwise
%       err = make_error_expected_token_type( obj, peek(it), types.function );
  end
  
  if ( ~isempty(err) )
    errs = [ errs, err ];
  end
  
  advance( it );
end

end