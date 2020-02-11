classdef TypedAstGenerator < handle
  properties (Access = private)
    Text;
    Tree;
  end
  
  methods
    function obj = TypedAstGenerator()
    end
    
    [errs, tree] = generate(obj, tree, text)
  end
end