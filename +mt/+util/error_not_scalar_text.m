function me = error_not_scalar_text(var_name)

me = MException( 'mt:not_scalar_text', '"%s" must be scalar text.', var_name );

end