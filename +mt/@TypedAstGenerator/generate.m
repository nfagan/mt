function [errs, tree] = generate(obj, tree, text)

obj.Tree = tree;
obj.Text = text;

errs = [];

generate_block( obj, tree );

end

function generate_block(obj, block)

i = 1;

while ( i < numel(block.Contents) )
  a = block.Contents{i};
  b = block.Contents{i+1};
  
  if ( isa(b, 'mt.ast.FunctionDefinition') && isa(a, 'mt.ast.FunctionType') )
    new_type = mt.ast.TypedFunctionDefinition( a, b );
    block.Contents{i} = new_type;
    block.Contents(i+1) = [];
    
    generate_block( obj, b.Body );
  end
  
  i = i + 1;
end

end