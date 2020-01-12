function [errs, node] = t_begin(obj)

advance( obj.Iterator );
[errs, node] = type_info( obj );

end