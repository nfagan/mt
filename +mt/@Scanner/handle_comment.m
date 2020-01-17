function handle_comment(obj)
import mt.Scanner;

advance( obj ); % consume '%'

if ( peek(obj) == '{' )
  % Maybe block comment.
  advance( obj );
  consume_whitespace_to_new_line( obj );

  if ( peek(obj) == Scanner.new_line )
    advance( obj );
  end
end

consume_whitespace_to_new_line( obj );

next = peek( obj );
next1 = peek_next( obj );
next2 = peek_n( obj, 2 );

is_type_code = next == '@' && next1 == 't' && ...
  (Scanner.is_whitespace( next2 ) || next2 == 0);

if ( ~is_type_code )
  % Consume until new line.
  while ( obj.I < obj.Eof && peek(obj) ~= Scanner.new_line() )
    advance( obj );
  end
  
  if ( peek(obj) == Scanner.new_line() )
    add_token( obj, make_token(obj, obj.I, obj.I, obj.TokenTypes.new_line) );
  end

else
  start = obj.I;
  stop = obj.I + 1;
  type = obj.TokenTypes.t_begin;

  add_token( obj, make_token(obj, start, stop, type) );
  advance( obj );
end
end