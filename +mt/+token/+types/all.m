function out = all()

import mt.token.*;

persistent p;

if ( isempty(p) )
  m = types.matlab();
  t = types.typing();

  f = fieldnames( t );
  for i = 1:numel(f)
    m.(f{i}) = t.(f{i});
  end

  % End of file token
  m.eof = -1;
  
  p = m;
end

out = p;

end