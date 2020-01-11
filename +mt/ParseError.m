classdef ParseError
  properties (Access = private, Constant = true)
    CONTEXT_SIZE = 30;
  end
  
  properties (Access = private)
    Message;
    Token;
    Text;
  end
  
  methods (Access = private)
    function obj = ParseError()
      obj.Message = '';
      obj.Token = mt.token.eof();
      obj.Text = '';
    end
  end
  
  methods (Access = public)
    function show(obj)
      stp = 1;
      
      for i = 1:numel(obj)
        msg = obj(i).Message;
        
        if ( ~isempty(msg) )
          fprintf( '\n%d:\n\n%s\n\n\n', stp, msg );
          stp = stp + 1;
        end
      end
    end
  end
  
  methods (Access = public, Static = true)
    function obj = with_message_context(message, token, text)
      import mt.*;
      
      start_ind = mt.token.start( token );
      stop_ind = mt.token.stop( token ); 

      use_msg = util.mark_text_with_message_and_context( ...
        text, start_ind, stop_ind, ParseError.CONTEXT_SIZE, message ...
      );

      obj = ParseError();
      obj.Message = use_msg;
      obj.Token = token;
      obj.Text = text;
    end
  end
end