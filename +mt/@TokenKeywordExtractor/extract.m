function [errs, tokens] = extract(obj, tokens, text)

import mt.*;

errs = TokenKeywordExtractor.empty_error();
obj.Iterator = TokenIterator( tokens );

% n-1 Because at least one token should follow an @t macro.
while ( obj.Iterator.I < obj.Iterator.N-1 )
  tok = peek( obj.Iterator );
  
  if ( token.type(tok) == obj.TokenTypes.t_begin ) 
    advance( obj.Iterator );
    [e, tokens] = replace( obj, tokens, text );
    errs = [ errs, e ];
  end
  
  advance( obj.Iterator );
end

end

function [errs, tokens] = replace(obj, tokens, text)

import mt.*;
errs = TokenKeywordExtractor.empty_error();

types = obj.TokenTypes;
tre = obj.TokenTypenamesRequireEnd;
source_types = obj.SourceTokenTypes;
replace_with = obj.DestinationTokenTypes;

initiator_ptrs = [];
terminators = [];
allow_ident = true;

while ( obj.Iterator.I <= obj.Iterator.N )
  t = peek( obj.Iterator );
  type = token.type( t );
  
  term = terminator_for_type( t, type, types, text, tre, allow_ident );
  
  if ( ~isempty(term) )
    initiator_ptrs(end+1) = obj.Iterator.I;
    terminators(end+1) = term;
    allow_ident = false;
  end

  if ( ~isempty(terminators) && type == terminators(end) )
    % Pop the last terminator.
    terminators(end) = [];
    initiator_ptrs(end) = [];
    % Reassign the terminator -> t_end.
    tokens(obj.Iterator.I, token.type_column()) = types.t_end;
    
  elseif ( type == types.identifier )
    lex = token.lexeme( t, text, types );
    
    if ( ismember(lex, obj.Keywords) )
      % Change from identifier to typing keyword.
      tokens(obj.Iterator.I, token.type_column()) = types.(lex);
    end
  else
    % E.g., replace function with t_function.
    [tf, lia] = ismember( source_types, type );
    
    if ( any(tf) )
      tokens(obj.Iterator.I, token.type_column()) = replace_with(lia);
    end
  end
  
  if ( isempty(terminators) )
    break;
  end
  
  advance( obj.Iterator );
end

if ( ~isempty(terminators) )
  offending_token = mt.token.nth( tokens, initiator_ptrs(end) );
  errs = make_error_unterminated_typing_decl( obj, offending_token, text );
end

end

function terminator = terminator_for_type(t, type, types, text, tre, allow_ident)
import mt.*;

terminator = [];

if ( type == types.function )
  terminator = types.end;

elseif ( type == types.identifier )
  lex = token.lexeme( t, text, types );

  if ( ismember(lex, tre) )
    terminator = types.end;

  elseif ( allow_ident )
    % e.g. if @t double; in this case allow a new-line as terminator.
    terminator = types.new_line;
  end
end

end