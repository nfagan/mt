classdef DebugStringVisitor < handle
  properties (Access = private)
    TabDepth;
    TokenTypes;
  end
  
  methods
    function obj = DebugStringVisitor()
      obj.TabDepth = 0;
      obj.TokenTypes = mt.token.types.all();
    end
    
    function str = root(obj, r)
      str = visit_array( obj, r.Contents, mt.characters.newline() );
    end
    
    function str = type_annotation(obj, t)
      anno_str = accept_debug_string_visitor( t.Annotation, obj );
      str = sprintf( '%s%s', tab_str(obj), anno_str );
    end
    
    function str = begin(obj, b)
      if ( b.Exported )
        export_str = ' export';
      else
        export_str = '';
      end
      
      header = sprintf( 'begin%s', export_str );
      
      enter_block( obj );
      body = visit_homogeneous_array( obj, b.Contents, mt.characters.newline() );
      exit_block( obj );
      
      str = sprintf( '%s\n%s\n%send', header, body, tab_str(obj) );
    end
    
    function str = given(obj, g)
      param_str = sprintf( '<%s>', strjoin(g.ParameterNames, ', ') );
      decl_str = accept_debug_string_visitor( g.Declaration, obj );
      str = sprintf( 'given %s %s', param_str, decl_str );
    end
    
    function str = let(obj, l)
      type_str = accept_debug_string_visitor( l.EqualToType, obj );
      str = sprintf( 'let %s = %s', l.Identifier, type_str );
    end
    
    function str = function_type(obj, t)
      out_array = visit_array( obj, t.Outputs, ', ' );
      in_array = visit_array( obj, t.Inputs, ', ' );
      
      str = sprintf( '[%s] = (%s)', out_array, in_array );
    end
    
    function str = type_identifier(obj, t)
      base_str = t.Identifier;
      
      if ( ~isempty(t.Arguments) )
        arg_str = sprintf( '<%s>', visit_array(obj, t.Arguments, ', ') );
      else
        arg_str = '';
      end
      
      str = sprintf( '%s%s', base_str, arg_str );
    end
    
    function str = function_definition(obj, def)
      outputs = strjoin( def.Outputs, ', ' );
      inputs = strjoin( def.Inputs, ', ' );
      name = def.Name;
      
      header = sprintf( '%sfunction [%s] = %s(%s)' ...
        , tab_str(obj), outputs, name, inputs );
      
      enter_block( obj );
      body = accept_debug_string_visitor( def.Body, obj );
      exit_block( obj );
      
      end_str = sprintf( '%send', tab_str(obj) );
      str = sprintf( '%s\n%s\n%s', header, body, end_str );
    end
    
    function str = block(obj, b)
      str = visit_array( obj, b.Contents, mt.characters.newline() );
    end
    
    function str = if_stmt(obj, stmt)
      main_str = accept_debug_string_visitor( stmt.IfBranch, obj );
      strs = { main_str };
      
      if ( ~isempty(stmt.ElseifBranches) )
        branches = stmt.ElseifBranches;
        elseif_strs = visit_homogeneous_array( obj, branches, mt.characters.newline() );
        strs{end+1} = elseif_strs;
      end
      
      if ( ~isempty(stmt.ElseBlock) )
        else_str = accept_debug_string_visitor( stmt.ElseBlock, obj );
        strs{end+1} = else_str;
      end
      
      strs{end+1} = sprintf( '%send', tab_str(obj) );
      str = strjoin( strs, mt.characters.newline() );
    end
    
    function str = branch(obj, stmt)
      type_name = mt.token.typename( stmt.Type );
      cond_str = accept_debug_string_visitor( stmt.Condition, obj );
      branch_str = sprintf( '%s%s %s', tab_str(obj), type_name, cond_str );
      
      enter_block( obj );
      block_str = accept_debug_string_visitor( stmt.Block, obj );
      exit_block( obj );
      
      str = sprintf( '%s\n%s', branch_str, block_str );
    end
    
    function str = expression_statement(obj, es)
      str = sprintf( '%s%s;', tab_str(obj), accept_debug_string_visitor(es.Expr, obj) );
    end
    
    function str = assignment_statement(obj, as)
      of = accept_debug_string_visitor( as.OfExpr, obj );
      to = accept_debug_string_visitor( as.ToExpr, obj );
      
      str = sprintf( '%s%s = %s', tab_str(obj), to, of );
    end
    
    function str = binary_operator_expr(obj, bin)
      left = accept_debug_string_visitor( bin.LeftExpr, obj );
      right = accept_debug_string_visitor( bin.RightExpr, obj );
      op = mt.token.symbol_for( bin.OperatorType, obj.TokenTypes );
      
      str = sprintf( '(%s %s %s)', left, op, right );
    end
    
    function str = identifier_reference_expr(obj, ref)
      main_ident = ref.Identifier;
      sub_strs = arrayfun( @(x) accept_debug_string_visitor(x, obj) ...
        , ref.Subscript, 'un', 0 );
      
      str = sprintf( '(%s%s)', main_ident, strjoin(sub_strs, '') );
    end
    
    function str = number_literal_expr(obj, num)
      str = sprintf( '%s', num2str(num.Value) );
    end
    
    function str = char_literal_expr(obj, c)
      str = sprintf( '''%s''', c.Value );
    end
    
    function str = colon_subscript(obj, c)
      str = ':';
    end
    
    function str = grouping_expression(obj, g)
      sub_strs = visit_homogeneous_array( obj, g.Exprs, ' ' );
      term = mt.token.grouping_terminator( g.BeginType, obj.TokenTypes );
      
      begin_sym = mt.token.symbol_for( g.BeginType, obj.TokenTypes );
      end_sym = mt.token.symbol_for( term, obj.TokenTypes );
      
      str = sprintf( '%s%s%s', begin_sym, sub_strs, end_sym );
    end
    
    function str = grouping_expression_component(obj, g)
      expr_str = accept_debug_string_visitor( g.Expr, obj );
      delim_str = mt.token.symbol_for( g.Delimiter, obj.TokenTypes );
      
      str = sprintf( '%s%s', expr_str, delim_str );
    end
    
    function str = subscript(obj, s)
      sub_str = visit_array( obj, s.Arguments, ', ' );
      
      switch ( s.Method )
        case '()'
          str = sprintf( '(%s)', sub_str );
        case '{}'
          str = sprintf( '{%s}', sub_str );
        case '.'
          str = sprintf( '.%s', sub_str );
        otherwise
          error( 'Unrecognized method "%s".', s.Method );
      end
    end
  end
  
  methods (Access = private)
    function str = visit_homogeneous_array(obj, array, delim)
      strs = cell( size(array) );
      
      for i = 1:numel(array)
        strs{i} = accept_debug_string_visitor( array(i), obj );
      end
      
      str = strjoin( strs, delim );
    end
    
    function str = visit_array(obj, array, delim)
      strs = cell( size(array) );
      
      for i = 1:numel(array)
        strs{i} = accept_debug_string_visitor( array{i}, obj );
      end
      
      str = strjoin( strs, delim );
    end
    
    function enter_block(obj)
      obj.TabDepth = obj.TabDepth + 1;
    end
    
    function exit_block(obj)
      obj.TabDepth = obj.TabDepth - 1;
      assert( obj.TabDepth >= 0 );
    end
    
    function str = tab_str(obj)
      str = repmat( '  ', 1, obj.TabDepth );
    end
  end
end