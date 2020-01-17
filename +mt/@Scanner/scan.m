function [errs, toks] = scan(obj, text)

toks = [];

begin_scan( obj, text );
errs = main_scan( obj );

if ( ~isempty(errs) )
  return
end

merge_compound_tokens( obj );
errs = remove_ellipses( obj );

if ( ~isempty(errs) )
  return
end

toks = tokens( obj );

end