classdef LoopControlStmt < handle
  properties
    Type;
  end
  
  methods
    function obj = LoopControlStmt(type)
      obj.Type = type;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = loop_control_statement( vis, obj );
    end
  end
end