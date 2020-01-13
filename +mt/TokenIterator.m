classdef TokenIterator < handle
  properties (Access = public)
    Tokens;
    I;
    N;
  end
  
  methods
    function obj = TokenIterator(tokens)
      obj.I = 1;
      obj.N = mt.token.count( tokens );
      obj.Tokens = tokens;
    end
    
    function advance(obj)
      obj.I = obj.I + 1;
    end
    
    function advance_until(obj, types)
      while ( ~ended(obj) && ~ismember(peek_next_type(obj), types) )
        advance( obj );
      end
    end
    
    function advance_to(obj, types)
      while ( ~ended(obj) && ~ismember(peek_type(obj), types) )
        advance( obj );
      end
    end
    
    function tf = ended(obj)
      tf = obj.I > obj.N;
    end
    
    function t = peek(obj)
      if ( obj.I > obj.N )
        t = mt.token.eof();
      else
        t = obj.Tokens(obj.I, :);
      end
    end
    
    function t = peek_next(obj)
      if ( obj.I+1 > obj.N )
        t = mt.token.eof();
      else
        t = obj.Tokens(obj.I+1, :);
      end
    end
    
    function t = peek_type(obj)
      t = mt.token.type( peek(obj) );
    end
    
    function t = peek_next_type(obj)
      t = mt.token.type( peek_next(obj) );
    end
    
    function t = peek_typename(obj)
      t = mt.token.typename( peek_type(obj) );
    end
  end
end