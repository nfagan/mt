classdef Root < handle
  properties
    Contents = {};
  end
  
  methods
    function obj = Root()
      %
    end
    
    function append(obj, node)
      obj.Contents{end+1} = node;
    end
    
    function conditional_append(obj, node)
      if ( ~isempty(node) )
        append( obj, node );
      end
    end
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = root( visitor, obj );
    end
  end
end