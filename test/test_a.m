%@t [double, single] = (double, double, double)
%{
@t begin
  begin
end
end
%}
function [out1, out2] = test_a(a, b, c)

y = 1.111.''';
z = y ~= 1;

a = '1';
b = '';
c = b == 1;

a = b <= 2;

c = @(x) y;

end