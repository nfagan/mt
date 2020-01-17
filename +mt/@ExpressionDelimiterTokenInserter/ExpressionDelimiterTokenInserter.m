classdef ExpressionDelimiterTokenInserter < handle
  properties (Access = private)
    TokenTypes;
    Iterator;
    Text;
    
    BracketDepth;
    BraceDepth;
  end
  
  methods
    function obj = ExpressionDelimiterTokenInserter()
      obj.TokenTypes = mt.token.types.all();
      obj.BracketDepth = 0;
      obj.BraceDepth = 0;
      obj.Iterator = mt.TokenIterator( [] );
      obj.Text = '';
    end
    
    [errs, tokens] = process(obj, tokens, text)
  end
  
  methods (Access = private)
    function begin_process(obj, tokens, text)
      obj.Iterator = mt.TokenIterator( tokens );
      obj.Text = text;
    end
    
    function err = maker_error_unbalanced_bracket_or_brace(obj, token)
      msg = 'Unbalanced bracket or brace.';
      err = make_error_message_at_token( obj, token, msg );
    end
    
    function err = make_error_message_at_token(obj, token, message)      
      start = mt.token.start( token );
      stop = mt.token.stop( token);
      
      err = mt.ParseError.with_message_context( message, start, stop, obj.Text );
    end
  end
end