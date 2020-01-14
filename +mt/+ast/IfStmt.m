classdef IfStmt < handle
  properties
    IfBranch;
    ElseifBranches;
    ElseBlock;
  end
  
  methods
    function obj = IfStmt(if_branch, elseif_branches, else_block)
      obj.IfBranch = if_branch;
      obj.ElseifBranches = elseif_branches;
      obj.ElseBlock = else_block;
    end
    
    function str = accept_debug_string_visitor(obj, vis)
      str = if_stmt( vis, obj );
    end
  end
end