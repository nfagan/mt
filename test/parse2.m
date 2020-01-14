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

function [one, two, three] = parse2(a, b, c)

b(1).four(four, three, 'a', 2 * 4).five * 2 * 3;

end