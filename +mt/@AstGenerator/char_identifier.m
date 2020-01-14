function [errs, ident] = char_identifier(obj)

ident = '';

types = obj.TokenTypes;
errs = make_error_if_unexpected_current_token( obj, types.identifier );

if ( isempty(errs) )
  ident = mt.token.lexeme( peek(obj.Iterator), obj.Text, types );
end

end