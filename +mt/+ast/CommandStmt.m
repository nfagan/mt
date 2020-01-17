classdef CommandStmt < handle
  properties
    Identifier;
    Arguments;
  end
  
  methods
    function obj = CommandStmt(ident, args)
      obj.Identifier = ident;
      obj.Arguments = args;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = command_statement( vis, obj );
    end
  end
end