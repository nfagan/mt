repadd mt;
repadd( 'mt/test', true );
repadd( 'mt/script', true );

%%

tic;

s = mt.Scanner();
tke = mt.TokenKeywordExtractor();
ast_gen = mt.AstGenerator();
expr_delimiter = mt.ExpressionDelimiterTokenInserter();

fname = 'bfw_lda.population_decode_gaze_from_reward';
% fname = 'plot_mod_matrix2';
% fname = 'ft_electrodeplacement';
% fname = 'ft_databrowser';
% fname = 'parse5';
% fname = 'SHINE';
% fname = 'bsc.config.create';
% fname = 'parse6';

f = fileread( which(fname) );
[errs, ts] = s.scan( f );
show( errs );

[errs, ts] = tke.extract( ts, f );
[errs, ts] = expr_delimiter.process( ts, f );

if ( isempty(errs) )
  [errs, tree] = ast_gen.parse( ts, f );
else
  tree = [];
end

show( errs );

toc;

%%

vis = mt.ast.DebugStringVisitor();
vis.ParenthesizeExpressions = true;

res = accept_debug_string_visitor( tree, vis );
fprintf( '\n%s\n\n', res );