% TEST_B -- Show help
%
%   test_b is a test.
%{
@t function test_b
  double = ()
  single = ()
end
%}
function a = test_b()

%@t [double]
x = 10;

y = 'hello''''';

z = ...
  3;

y = ...
  2;

end

%{
@t given <T> function another
  [] = (T)
%}