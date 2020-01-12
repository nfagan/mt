classdef Begin < handle
  properties (Access = public)
    Exported;
    Contents;
  end
  
  methods
    function obj = Begin(info, exported)
      obj.Contents = info;
      obj.Exported = exported;
    end
  end
end