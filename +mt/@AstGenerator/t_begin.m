function [errs, node] = t_begin(obj)

advance( obj.Iterator );  % consume `@t`
[errs, node] = type_info( obj );

end