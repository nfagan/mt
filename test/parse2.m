%{
@t begin
  given T let X = [double] = (A<[] = (B<[] = (T)>)>)
  given Z let Y = [[] = (double)] = (Z)
  let Z = [[] = (double)] = (double)

  begin
    let Y = X
  end
end
%}

function [a] = parse2(a)

% a = 1 + 2 * 3 * 6 + 4;
a = 1 + 2 + 3 + 4;

end