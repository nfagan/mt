%{
@t begin

given <T> function parse1
  S<T> = (T, double)
  S<T> = (T, single)
end

given <T> struct S
  a: T
  b: double | single
  c: [] = ()
end

begin export
namespace Another
  
end
end

end
%}