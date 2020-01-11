function n = typenames(t)

import mt.*;

types = token.types.all();
c = struct2cell( types );
c = vertcat( c{:} );
f = fieldnames( types );

n = cell( size(t) );

for i = 1:numel(t)
  ind = find( c == t(i), 1 );
  
  if ( isempty(ind) )
    n{i} = '';
  else
    n{i} = f{ind};
  end
end

end