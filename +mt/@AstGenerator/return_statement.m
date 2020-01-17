function [errs, node] = return_statement(obj)

advance( obj.Iterator );  % consume `return`

errs = mt.AstGenerator.empty_error();
node = mt.ast.Return();

end