%{
@t begin export
  given T let X = [] = ()
  given Z let Y = Another

  begin export
    let Me = X<T>
	end
end
%}

%{
@t begin
  given <T, X, Y, Z> let Y = double
end
%}