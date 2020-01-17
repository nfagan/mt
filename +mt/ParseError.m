classdef ParseError
  properties (Access = private, Constant = true)
    CONTEXT_SIZE = 30;
  end
  
  properties (Access = private)
    Message;
  end
  
  methods (Access = private)
    function obj = ParseError()
      obj.Message = '';
    end
  end
  
  methods (Access = public)
    function show(obj)
      stp = 1;
      
      for i = 1:numel(obj)
        msg = obj(i).Message;
        
        if ( ~isempty(msg) )
          tmp = strsplit( msg, mt.characters.newline(), 'collapse', 0 );
          msg = strjoin( cellfun(@(x) sprintf( '  %s', x ), tmp, 'un', 0) ...
            , mt.characters.newline() );
          
          fprintf( '\n%d:\n\n%s\n\n\n', stp, msg );
          stp = stp + 1;
        end
      end
    end
  end
  
  methods (Access = public, Static = true)
    function obj = with_message_context(message, start, stop, text)
      use_msg = mt.util.mark_text_with_message_and_context( ...
        text, start, stop, mt.ParseError.CONTEXT_SIZE, message ...
      );

      obj = mt.ParseError();
      obj.Message = use_msg;
    end
  end
end