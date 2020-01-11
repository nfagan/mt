function tf = is_scalar_text(t)

tf = ischar( t ) && (isempty(t) || (ismatrix(t) && size(t, 1) == 1));

end