function tree = make_ast_from_string(str)

tree = [];

s = mt.Scanner();
tke = mt.TokenKeywordExtractor();
expr_delimiter = mt.ExpressionDelimiterTokenInserter();
ast_gen = mt.AstGenerator();
typed_ast_gen = mt.TypedAstGenerator();

[errs, ts] = s.scan( str );

if ( ~isempty(errs) )
  show( errs );
  return
end

[errs, ts] = tke.extract( ts, str );

if ( ~isempty(errs) )
  show( errs );
  return
end

[errs, ts] = expr_delimiter.process( ts, str );

if ( ~isempty(errs) )
  show( errs );
  return
end

[errs, tree] = ast_gen.parse( ts, str );

if ( ~isempty(errs) )
  show( errs );
  return
end

[errs, tree] = typed_ast_gen.generate( tree, str );

if ( ~isempty(errs) )
  show( errs );
  return
end

end