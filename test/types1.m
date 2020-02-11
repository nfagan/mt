% @t [double] = (double, double)
function c = types1(a, b)

tmp = a * b + 2;
c = nested( tmp );

  % @t [double] = (double)
  function d = nested(a)
    d = a * 2;
  end
end