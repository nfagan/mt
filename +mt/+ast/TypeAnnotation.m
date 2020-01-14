classdef TypeAnnotation < handle
  properties
    Annotation;
  end
  
  methods
    function obj = TypeAnnotation(annot)
      obj.Annotation = annot;
    end
    
    function str = accept_debug_string_visitor(obj, visitor)
      str = type_annotation( visitor, obj );
    end
  end
end