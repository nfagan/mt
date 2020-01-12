%{

1. Type annotation scope / visibility
  1 Annotations may not be re-declared within a given scope. Only child
  functions and files introduce a new scope.
  2 `begin` ... `end` denotes a region of type annotations, but does not
  introduce a new scope. Nested `begin` ... `end` regions are legal.
  3 In a given file, annotations outside of function declarations are
  visible to the entire file (i.e., global).
    o In a classdef file, methods, properties, events, and enumeration 
    blocks do not introduce a new scope. Declarations in these blocks are 
    at file scope.
  4 In a properties block of a classdef file, annotations are restricted to 
  a single line for each property, immediately preceding the property.
  5 Within a function / script, typing declarations are visible to that
  function and its children, only. A declaration in a child's scope may
  shadow the declaration of its parent (but note point 2.1).
  6 Annotation declarations for `struct`, `let`, and `class` keywords can
  occur in any order, and reference one another.
  7 `function` identifiers live in a separate namespace from `let` and
  `struct` identifiers.
  8 `let` and `struct` identifiers live in the same namespace.
  9 `namespace Identifier` ... `end` introduces 

2. Exports
  1 `begin export` ... `end` denotes a region of type annotations that are 
  visible to external files if explicitly imported. Within a file, exported
  identifiers must be unique.
    o Identifiers that shadow exported identifiers in a parent scope may
    not be exported.

3. Imports
  1 import `file_identifier` imports the exported annotations from
  `file_identifier` into the current scope. `file_identifier` is the name 
  of the function or class as it would be known to Matlab, given the 
  current search path. E.g., if 'foo.m' is a file with exported type 
  annotations stored in directory '+Foo', then `import Foo.foo` imports 
  those annotations.
    o `file_identifier` must resolve to a known file. As a consequence, 
    type-checked files must exist on the search path.
  2 Given rule 1.1, imported annotations cannot shadow annotations in the
  target scope. They can, however, shadow annotations of the parent scope.
  3 It is OK for the export list of the import target to be empty; in this
  case, the `import` statement has no effect.

%}