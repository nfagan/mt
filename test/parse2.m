%{
@t begin
  given T let X = [double] = (A<[] = (B<[] = (T)>)>)
  given Z let Y = [[] = (double)] = (Z)
  let Z = double

  begin
    let Y = X
  end
end
%}