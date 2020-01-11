function types = typing()

persistent t;

if ( isempty(t) )
  t = make_types();
end

types = t;

end

function types = make_types()

offset = 1e3;

kws = mt.keywords.typing();
addtl = { 't_begin', 't_function', 't_end' };
fs = [ kws, addtl ];

values = arrayfun( @(x) x, (0:(numel(fs)-1)) + offset, 'un', 0 );
types = cell2struct( values, fs, 2 );

end