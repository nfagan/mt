function [errs, tree] = parse(obj, tokens, text)
import mt.*;

types = obj.TokenTypes;
errs = AstGenerator.empty_error();
tree = mt.ast.Root();

it = TokenIterator( tokens );

obj.Iterator = it;
obj.Text = text;

allowed_types = possible_types( types );

while ( ~ended(it) )
  t = peek_type( it );
  err = AstGenerator.empty_error();

  switch ( t )
    case types.t_begin
      [err, info_node] = t_begin( obj );
      conditional_append( tree, info_node );

    case {types.new_line, types.eof}
      %
      
    otherwise
      err = make_error_expected_token_type( obj, peek(it), allowed_types );
  end
  
  if ( ~isempty(err) )
    % Don't mark additional parse errors, skip to the next valid type.
    advance_to( it, allowed_types );
    errs = [ errs, err ];
  else
    advance( it );
  end
end

if ( isempty(errs) )
  errs = mt.ParseError.empty();
end

end

function ts = possible_types(types)
% ts = [ types.function, types.t_begin ];
ts = [ types.t_begin ];
end