classdef Begin < handle
  properties (Access = public)
    Exported;
    Contents = mt.ast.TypeAnnotation.empty();
  end
  
  methods
    function obj = Begin(exported)
      obj.Exported = exported;
    end

    function append(obj, node)
      obj.Contents(end+1) = node;
    end
    
    function conditional_append(obj, node)
      if ( ~isempty(node) )
        append( obj, node );
      end
    end
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = begin( visitor, obj );
    end
  end
end