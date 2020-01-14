classdef ColonSubscript < handle
  methods
    function obj = ColonSubscript()
      %
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = colon_subscript( vis, obj );
    end
  end
end