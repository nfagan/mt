function n = typename(t)

import mt.*;

validateattributes( t, {'double'}, {'scalar', 'integer'}, mfilename, 'type-id' );

types = token.types.all();
c = struct2cell( types );
f = fieldnames( types );

matches = cellfun( @(x) x == t, c );

if ( nnz(matches) == 0 )
  n = '';
else
  n = f{find(matches, 1)};
end

end