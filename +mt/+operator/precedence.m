function p = precedence(type, types)

% https://www.mathworks.com/help/matlab/matlab_prog/operator-precedence.html

p = -1;

if ( ismember(type, level7(types)) )
  p = 7;
  
elseif ( ismember(type, level6(types)) )
  p = 6;
  
elseif ( ismember(type, level5(types)) )
  p = 5;
  
end

end

function ts = level7(types)

ts = [ ...
  types.dot_star, types.dot_f_slash, types.dot_b_slash ...
  , types.star, types.f_slash, types.b_slash ...
];

end

function ts = level6(types)
ts = [ ...
  types.plus, types.minus ...
];
end

function ts = level5(types)
ts = types.colon;
end