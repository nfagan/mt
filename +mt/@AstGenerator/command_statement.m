function [errs, node] = command_statement(obj)

[errs, ident] = char_identifier( obj );

if ( ~isempty(errs) )
  return
end

advance( obj.Iterator );

types = obj.TokenTypes;
terms = terminators( types );

args = {};

while ( ~ended(obj.Iterator) && ~ismember(peek_type(obj.Iterator), terms) )
  tok = peek( obj.Iterator );
  t = mt.token.type( tok );
  advance( obj.Iterator );
  
  switch ( t )
    case types.string_literal
      arg = mt.ast.StringLiteralExpr.from_token_text( tok, obj.Text, types );
      
    case types.char_literal
      arg = mt.ast.CharLiteralExpr.from_token_text( tok, obj.Text, types );
      
    otherwise
      % Note that for commands, we ignore the type of token and treat it
      % as a char literal.
      lex = mt.token.lexeme( tok, obj.Text, types );
      arg = mt.ast.CharLiteralExpr( lex );
  end
  
  args{end+1} = arg;
end

node = mt.ast.CommandStmt( ident, args );

end

function ts = terminators(types)
ts = [ types.eof, types.new_line, types.semicolon, types.comma ];
end