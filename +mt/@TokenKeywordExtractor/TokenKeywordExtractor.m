classdef TokenKeywordExtractor < handle
  properties (Access = private)
    TokenTypes;
    TokenTypesRequireEnd;
    TokenTypenamesRequireEnd;
    SourceTokenTypes;
    DestinationTokenTypes;
    Keywords;
    Iterator;
  end
  
  methods
    function obj = TokenKeywordExtractor()
      tts = mt.token.types.all();
      
      obj.TokenTypes = tts;
      obj.SourceTokenTypes = [ tts.function ];
      obj.DestinationTokenTypes = [ tts.t_function ];
      obj.Keywords = mt.keywords.typing();
      obj.TokenTypesRequireEnd = [ tts.begin, tts.function, tts.struct ];
      obj.TokenTypenamesRequireEnd = mt.token.typenames( obj.TokenTypesRequireEnd );     
    end
    
    [errs, tokens] = extract(obj, tokens, text)
  end
  
  methods (Access = private)
    function err = make_error_unterminated_typing_decl(obj, initial_token, text)
      msg = 'Unterminated typing declaration, which began from here.';
      err = mt.ParseError.with_message_context( msg, initial_token, text );
    end
  end
  
  methods (Access = private, Static = true)   
    function arr = empty_error()
      arr = mt.ParseError.empty();
    end
  end
end