repadd mt;
repadd( 'mt/test', true );
repadd( 'mt/script', true );

%%

tic;

s = mt.Scanner();
tke = mt.TokenKeywordExtractor();
ast_gen = mt.AstGenerator();

f = fileread( which('test_b') );
errs = s.scan( f );
% disp_tokens( s );

[errs, ts] = tke.extract( tokens(s), f );
% mt.token.disp( ts, f, mt.token.types.all() );

if ( isempty(errs) )
  errs = ast_gen.parse( ts, f );
end

show( errs );

toc;
