classdef Block < handle
  properties
    Contents = {};
  end
  
  methods
    function obj = Block()
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
  end
end