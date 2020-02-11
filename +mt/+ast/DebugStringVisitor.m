classdef DebugStringVisitor < handle
  properties (Access = private)
    TabDepth;
    TokenTypes;
  end
  
  properties (Access = public)
    ParenthesizeExpressions;
    AddSpaceBetweenOperators;
  end
  
  methods
    function obj = DebugStringVisitor()
      obj.TabDepth = 0;
      obj.TokenTypes = mt.token.types.all();
      obj.ParenthesizeExpressions = true;
      obj.AddSpaceBetweenOperators = true;
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
    
    function str = typed_function_definition(obj, def)
      type_str = accept_debug_string_visitor( def.Type, obj );
      def_str = accept_debug_string_visitor( def.Definition, obj );
      
      str = sprintf( '%s\n%s', type_str, def_str );
    end
    
    function str = ignore_function_argument(obj, i)
      str = '~';
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
        strs{end+1} = sprintf( '%selse', tab_str(obj) );
        enter_block( obj );
        strs{end+1} = accept_debug_string_visitor( stmt.ElseBlock, obj );
        exit_block( obj );
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
    
    function str = for_statement(obj, stmt)
      init_str = accept_debug_string_visitor( stmt.LoopVariableExpr, obj );
      ident_str = stmt.LoopVariableIdentifier;
      header_str = sprintf( '%sfor %s = %s', tab_str(obj), ident_str, init_str );
      
      enter_block( obj );
      body_str = accept_debug_string_visitor( stmt.Body, obj );
      exit_block( obj );
      
      str = sprintf( '%s\n%s\n%send', header_str, body_str, tab_str(obj) );
    end
    
    function str = while_statement(obj, stmt)
      cond_str = accept_debug_string_visitor( stmt.ConditionExpr, obj );
      header_str = sprintf( '%swhile %s', tab_str(obj), cond_str );
      
      enter_block( obj );
      body_str = accept_debug_string_visitor( stmt.Body, obj );
      exit_block( obj );
      
      str = sprintf( '%s\n%s\n%send', header_str, body_str, tab_str(obj) );
    end
    
    function str = try_statement(obj, stmt)
      header_str = sprintf( '%stry', tab_str(obj) );
      
      enter_block( obj );
      try_block_str = accept_debug_string_visitor( stmt.TryBlock, obj );
      exit_block( obj );
      
      if ( ~isempty(stmt.CatchBlock) )
        catch_str = sprintf( '%scatch', tab_str(obj) );
        
        if ( ~isempty(stmt.CatchExpr) )
          catch_expr_str = accept_debug_string_visitor( stmt.CatchExpr, obj );
          catch_str = sprintf( '%s %s', catch_str, catch_expr_str );
        end
        
        enter_block( obj );
        catch_block_str = accept_debug_string_visitor( stmt.CatchBlock, obj );
        exit_block( obj );
        
        catch_str = sprintf( '%s\n%s', catch_str, catch_block_str );
      else
        catch_str = '';
      end
      
      str = sprintf( '%s\n%s\n%s\n%send', header_str, try_block_str, catch_str, tab_str(obj) );
    end
    
    function str = switch_statement(obj, stmt)
      switch_str = accept_debug_string_visitor( stmt.SwitchExpr, obj );
      header_str = sprintf( '%sswitch %s', tab_str(obj), switch_str );
      
      enter_block( obj );
      cases_str = visit_homogeneous_array( obj, stmt.CaseBlocks, mt.characters.newline() );
      
      if ( ~isempty(stmt.OtherwiseBlock) )
        enter_block( obj );
        otherwise_block_str = accept_debug_string_visitor( stmt.OtherwiseBlock, obj );
        exit_block( obj );
        
        cases_str = sprintf( '%s\n%sotherwise\n%s' ...
          , cases_str, tab_str(obj), otherwise_block_str );
      end
      
      exit_block( obj );
      
      str = sprintf( '%s\n%s\n%send', header_str, cases_str, tab_str(obj) );
    end
    
    function str = switch_case(obj, cs)
      case_str = sprintf( '%scase %s', tab_str(obj), accept_debug_string_visitor(cs.Expr, obj) );
      
      enter_block( obj );
      block_str = accept_debug_string_visitor( cs.Block, obj );
      exit_block( obj );
      
      str = sprintf( '%s\n%s', case_str, block_str );
    end
    
    function str = loop_control_statement(obj, stmt)
      str = sprintf( '%s%s', tab_str(obj), mt.token.typename(stmt.Type) );
    end
    
    function str = return_statement(obj, r)
      str = sprintf( '%sreturn', tab_str(obj) );
    end
    
    function str = expression_statement(obj, es)
      if ( isempty(es.Expr) )
        str = '';
      else
        str = sprintf( '%s%s;', tab_str(obj), accept_debug_string_visitor(es.Expr, obj) );
      end
    end
    
    function str = command_statement(obj, cmd)
      arg_str = visit_array( obj, cmd.Arguments, ' ' );
      str = sprintf( '%s%s %s;', tab_str(obj), cmd.Identifier, arg_str );
    end
    
    function str = assignment_statement(obj, as)
      of = accept_debug_string_visitor( as.OfExpr, obj );
      to = accept_debug_string_visitor( as.ToExpr, obj );
      
      str = sprintf( '%s%s = %s;', tab_str(obj), to, of );
    end
    
    function str = end_index_expr(obj, expr)
      str = 'end';
    end
    
    function str = unary_operator_expr(obj, un)
      expr = accept_debug_string_visitor( un.Expr, obj );
      op = mt.token.symbol_for( un.OperatorType, obj.TokenTypes );
      
      if ( un.Fixity == mt.operator.fixities.post )
        tmp = expr;
        expr = op;
        op = tmp;
      end
      
      if ( obj.AddSpaceBetweenOperators )
        space_str = ' ';
      else
        space_str = '';
      end
      
      if ( obj.ParenthesizeExpressions )
        str = sprintf( '(%s%s%s)', op, space_str, expr );
      else
        str = sprintf( '%s%s%s', op, space_str, expr );
      end
    end
    
    function str = binary_operator_expr(obj, bin)
      left = accept_debug_string_visitor( bin.LeftExpr, obj );
      right = accept_debug_string_visitor( bin.RightExpr, obj );
      op = mt.token.symbol_for( bin.OperatorType, obj.TokenTypes );
      
      if ( obj.AddSpaceBetweenOperators )
        space_str = ' ';
      else
        space_str = '';
      end
      
      if ( obj.ParenthesizeExpressions )
        str = sprintf( '(%s%s%s%s%s)', left, space_str, op, space_str, right );
      else
        str = sprintf( '%s%s%s%s%s', left, space_str, op, space_str, right );
      end
    end
    
    function str = identifier_reference_expr(obj, ref)
      main_ident = ref.Identifier;
      sub_strs = arrayfun( @(x) accept_debug_string_visitor(x, obj) ...
        , ref.Subscript, 'un', 0 );
      
      if ( obj.ParenthesizeExpressions )
        str = sprintf( '(%s%s)', main_ident, strjoin(sub_strs, '') );
      else
        str = sprintf( '%s%s', main_ident, strjoin(sub_strs, '') );
      end
    end
    
    function str = anonymous_function_expr(obj, expr)
      ident_str = strjoin( expr.InputIdentifiers, ', ' );
      input_str = sprintf( '@(%s)', ident_str );
      expr_str = accept_debug_string_visitor( expr.Expr, obj );
      
      if ( obj.ParenthesizeExpressions )
        str = sprintf( '(%s %s)', input_str, expr_str );
      else
        str = sprintf( '%s %s', input_str, expr_str );
      end
    end
    
    function str = function_reference_expr(obj, expr)
%       str = sprintf( '@%s', expr.Identifier );
      str = sprintf( '@%s', accept_debug_string_visitor(expr.Identifier, obj) );
    end
    
    function str = number_literal_expr(obj, num)
      str = sprintf( '%s', num2str(num.Value) );
    end
    
    function str = char_literal_expr(obj, c)
      str = sprintf( '''%s''', c.Value );
    end
    
    function str = string_literal_expr(obj, c)
      str = sprintf( '"%s"', c.Value );
    end
    
    function str = dynamic_field_reference_expr(obj, expr)
      str = accept_debug_string_visitor( expr.Expr, obj );
      str = sprintf( '(%s)', str );
    end
    
    function str = literal_field_reference_expr(obj, expr)
      str = expr.Identifier;
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