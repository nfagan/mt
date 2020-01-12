function msg = mark_text_with_message_and_context(text, start_ind, stop_ind, context_amount, message)

import mt.*;

begin_ind = max( 1, start_ind - context_amount );
end_ind = min( numel(text), stop_ind + context_amount );

subset_start_ind = start_ind - begin_ind + 1;
subset_text = text(begin_ind:end_ind);

lines = strsplit( subset_text, characters.newline(), 'collapse', false );
new_line_inds = find( subset_text == characters.newline() );
cumulative_inds = [0, new_line_inds];

intervals = [ -inf, new_line_inds ];        
interval_ind = find( subset_start_ind >= intervals, 1, 'last' );

num_spaces = subset_start_ind - cumulative_inds(interval_ind) - 1;

if ( begin_ind > 1 && ~isempty(lines) )
  addtl = '[...] ';
  lines{1} = sprintf( '%s%s', addtl, lines{1} );

  if ( interval_ind == 1 )
    num_spaces = num_spaces + numel( addtl );
  end
end

spaces = repmat( ' ', 1, num_spaces );
msg = sprintf( '%s^\n%s', spaces, message );
lines = [ lines(1:interval_ind), {msg} ];
msg = strjoin( lines, '\n' );

end