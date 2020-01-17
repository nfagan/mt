function [errs, node] = loop_control_statement(obj)

type = peek_type( obj.Iterator );
advance( obj.Iterator );  % consume `break` or `continue`

errs = mt.AstGenerator.empty_error();
node = mt.ast.LoopControlStmt( type );

end