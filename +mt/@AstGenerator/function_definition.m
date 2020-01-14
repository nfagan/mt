function [errs, node] = function_definition(obj)

advance( obj.Iterator );  % consume function
types = obj.TokenTypes;

node = [];

[errs, name, inputs, outputs] = function_header( obj );

if ( ~isempty(errs) )
  return
end

[errs, body] = block( obj );

if ( ~isempty(errs) )
  return
end

if ( obj.ExpectEndTerminatedFunction )
  errs = make_error_if_unexpected_current_token( obj, types.end );
end

if ( isempty(errs) )
  node = mt.ast.FunctionDefinition( name, inputs, outputs, body );
end

end