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

[aa, bb] = c{1:2:3};
a(1 * 2) = b(1).four(four, three, 'a', 2 * 4).five * 2 * 3;

if a == 11
  d = 11;
  
  if a == 2
    c = 12;
  end
  
elseif b == 12
  b = 12;
end

end