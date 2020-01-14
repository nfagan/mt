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

% function ts = possible_types(types)
% % ts = [ types.function, types.t_begin ];
% ts = [ types.t_begin ];
% end

% types = obj.TokenTypes;
% errs = AstGenerator.empty_error();
% tree = mt.ast.Root();
% 
% it = TokenIterator( tokens );
% 
% obj.Iterator = it;
% obj.Text = text;
% 
% allowed_types = possible_types( types );
% 
% while ( ~ended(it) )
%   t = peek_type( it );
%   err = AstGenerator.empty_error();
%   node = [];
% 
%   switch ( t )
%     case types.function
%       [err, node] = function_definition( obj );
%       
%     case types.t_begin
%       [err, node] = t_begin( obj );
% 
%     case {types.new_line, types.eof}
%       %
%       
%     otherwise
%       err = make_error_expected_token_type( obj, peek(it), allowed_types );
%   end
%   
%   if ( isempty(err) )
%     conditional_append( tree, node );
%     advance( it );
%   else
%     % Don't mark additional parse errors, skip to the next valid type.
%     advance_to( it, allowed_types );
%     errs = [ errs, err ];
%   end
% end