function [errs, toks] = scan(obj, text)

begin_scan( obj, text );

errs = main_scan( obj );
merge_compound_tokens( obj );

toks = tokens( obj );

end