%{
@T begin export
  given <X, Y, Z> let X = Another
  given A let Y = Z<[] = ()>
  given <B,C> let X = Z

  let X = [] = (double)
  let Y = [] = (double, single)
  let Z = [] = (double, varargin<keyof<S>>)
  let X = any
end

%}

% @T [[] = (double)] = ([] = (A))
function x()

if (dfA+dfB)<size(design, 2)
  a = 11; 
end

for i = 1:10
  break;
end

[bb_p,aa_p]=butter(3,[Pf1/(srate/2),Pf2/(srate/2)]);
low_filtered_signals=filtfilt(bb_p,aa_p,lf_signals')';
Phase_signals=angle(hilbert(low_filtered_signals'))'; % this is getting the phase time series
Ntrials=size(lf_signals,1);

a.b.c{1}.d.e.f();

% end

function another()
%{
  @T begin export
    let X = another
  end
%}
end
end