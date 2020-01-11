function begin_scan(obj, text)

if ( ~mt.util.is_scalar_text(text) )
  throw( mt.util.error_not_scalar_text('Text') );
end

obj.I = 1;
obj.Eof = numel( text ) + 1;
obj.Tokens = [];
obj.Text = text;

end