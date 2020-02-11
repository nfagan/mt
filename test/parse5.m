code = {
  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
  '% Add or change options for on-the-fly preprocessing'
  '% Use as cfg.preproc.option=value'
  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
};

code = {;;;1};

z = [1 -1];

% if isfield(headshape, 'color')
%   skin = 'none';
%   ft_plot_mesh(headshape);
%   view([90, 0]);
% else
%   ft_plot_mesh(headshape, 'facecolor', 'skin', 'EdgeColor', 'none', 'facealpha',1);
%   lighting gouraud
%   material dull
%   lightangle(0, 90);
%   alpha 0.9
% end

if numel(mri)>1; set(hscan, 'Visible', 'on');  end

z = 1;
