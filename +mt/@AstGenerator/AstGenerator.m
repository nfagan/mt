classdef AstGenerator < handle
  properties (Access = private)
    TokenTypes;
    Iterator;
    Text;
    ExpectEndTerminatedFunction = true;
    ParensReferenceDepth = 0;
    BraceReferenceDepth = 0;
  end
  
  methods
    function obj = AstGenerator()
      obj.TokenTypes = mt.token.types.all();
    end
    
    [errs, tree] = parse(obj, tokens, text)
  end
  
  methods (Access = private)
    [errs, node] = function_definition(obj)
    [errs, name, inputs, outputs] = function_header(obj)
    
    [errs, node] = block(obj)
    [errs, node] = sub_block(obj)
    [errs, node] = statement(obj)
    [errs, node] = expression_statement(obj)
    [errs, node] = if_statement(obj)
    [errs, node] = command_statement(obj)
    [errs, node] = for_statement(obj)
    [errs, node] = while_statement(obj)
    [errs, node] = switch_statement(obj)
    [errs, node] = try_statement(obj)
    [errs, node] = return_statement(obj)
    [errs, node] = loop_control_statement(obj)
    
    [errs, node] = expression(obj, allow_empty)
    [errs, node] = identifier_reference_expression(obj)
    [errs, node] = period_subscript(obj)
    [errs, node] = non_period_subscript(obj, method, term)
    [errs, node] = grouping_expression(obj)
    [errs, node] = anonymous_function_expression(obj)
    
    [errs, node] = t_begin(obj)
    [errs, node] = begin(obj)
    [errs, node] = type_info(obj)
    [errs, node] = given(obj)
    [errs, node] = let(obj)
    [errs, ident] = char_identifier(obj)
    [errs, idents] = char_identifier_sequence(obj, term)
    
    [errs, node] = type_specifier(obj)
    [errs, node] = single_type_specifier(obj)
    [errs, nodes] = multiple_type_specifiers(obj, term)
    [errs, inputs] = function_type_inputs(obj)
    [errs, node] = function_type_specifier(obj)
    
    function tf = is_inside_non_period_reference(obj)
      tf = obj.ParensReferenceDepth > 0 || obj.BraceReferenceDepth > 0;
    end
    
    function enter_non_period_reference(obj, method)
      if ( strcmp(method, '()') )
        enter_parens_reference( obj );
      elseif ( strcmp(method, '{}') )
        enter_brace_reference( obj );
      else
        error( 'Unhandled method "%s".', method );
      end
    end
    
    function exit_non_period_reference(obj, method)
      if ( strcmp(method, '()') )
        exit_parens_reference( obj );
      elseif ( strcmp(method, '{}') )
        exit_brace_reference( obj );
      else
        error( 'Unhandled method "%s".', method );
      end
    end
    
    function enter_parens_reference(obj)
      obj.ParensReferenceDepth = obj.ParensReferenceDepth + 1;
    end
    
    function exit_parens_reference(obj)
      obj.ParensReferenceDepth = obj.ParensReferenceDepth - 1;
    end
    
    function enter_brace_reference(obj)
      obj.BraceReferenceDepth = obj.BraceReferenceDepth + 1;
    end
    
    function exit_brace_reference(obj)
      obj.BraceReferenceDepth = obj.BraceReferenceDepth - 1;
    end
    
    function err = make_error_if_unexpected_current_token(obj, allowed_types)
      tok = peek( obj.Iterator );
      type = mt.token.type( tok );
      
      if ( ~ismember(type, allowed_types) )
        err = make_error_expected_token_type( obj, tok, allowed_types );
      else
        err = mt.AstGenerator.empty_error();
      end
    end
    
    function err = make_error_message_at_token(obj, token, message)      
      start = mt.token.start( token );
      stop = mt.token.stop( token);
      
      err = mt.ParseError.with_message_context( message, start, stop, obj.Text );
    end
    
    function err = make_error_invalid_expr_token(obj, token)
      msg = sprintf( 'Token "%s" is not valid in expressions.' ...
        , mt.token.to_string(token, obj.Text, obj.TokenTypes) );
      err = make_error_message_at_token( obj, token, msg );
    end
    
    function err = make_error_incomplete_expr(obj, token)
      msg = 'Expression is incomplete.';
      err = make_error_message_at_token( obj, token, msg );
    end
    
    function err = make_error_expected_lhs(obj, binary_token)
      msg = 'Expected an expression on the left hand side.';
      err = make_error_message_at_token( obj, binary_token, msg );
    end
    
    function err = make_error_invalid_assignment_target(obj, lhs_token)
      msg = 'The expression on the left is not a valid target for assignment.';
      err = make_error_message_at_token( obj, lhs_token, msg );
    end
    
    function err = make_error_reference_after_parens_reference_expr(obj, token)
      msg = '()-indexing must appear last in an index expression.';
      err = make_error_message_at_token( obj, token, msg );
    end
    
    function err = make_error_expected_token_type(obj, received_token, expected_types)
      expected_typenames = strjoin( mt.token.typenames(expected_types), ', ');
      msg = sprintf( ...
        'Expected to receive one of these types:\n\n%s\n\nInstead, received: "%s".' ...
        , expected_typenames ...
        , mt.token.to_string(received_token, obj.Text, obj.TokenTypes) ...
      );
    
    	start = mt.token.start( received_token );
      stop = mt.token.stop( received_token );
      
      err = mt.ParseError.with_message_context( msg, start, stop, obj.Text );
    end
  end
  
  methods (Access = private, Static = true)
    function err = empty_error()
      err = [];
%       err = mt.ParseError.empty();
    end
  end
end