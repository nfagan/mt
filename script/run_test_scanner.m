repadd mt;
repadd( 'mt/test', true );
repadd( 'mt/script', true );

%%

tic;

s = mt.Scanner();
tke = mt.TokenKeywordExtractor();
ast_gen = mt.AstGenerator();

f = fileread( which('parse3') );
[errs, ts] = s.scan( f );
% disp_tokens( s );
show( errs );

[errs, ts] = tke.extract( ts, f );
% mt.token.disp( ts, f, mt.token.types.all() )

if ( isempty(errs) )
  [errs, tree] = ast_gen.parse( ts, f );
end

show( errs );

toc;