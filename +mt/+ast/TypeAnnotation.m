classdef TypeAnnotation < handle
  properties
    Annotation;
  end
  
  methods
    function obj = TypeAnnotation(annot)
      obj.Annotation = annot;
    end
  end
end