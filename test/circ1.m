%{
@t begin

import circ2

struct Y
  b: S
end

let D = C
let C = D

given <T> struct X
  x: Y<T>
end

given <U> struct Y
  x: X<U>
  y: Y<U>*
end
  
end
%}