%{

* Associate each new scope with a type environment (and parent)
* For `let`, `struct`, `function`, and `class` declarations, ensure the
  declared identifier has not already been defined.
* For `let`, `struct`, and `function` declarations, consider the type
  identifiers that need to be resolved. If the identifier exists in the
  environment, validate it and assign it. Otherwise, mark it as unresolved.
  When the current file has been parsed, attempt to resolve the remaining
  unresolved identifiers.


%}