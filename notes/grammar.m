%{

TypeInfo        := Type
                    | Begin
                    | Namespace
                    | StructDecl
                    | FunctionDecl
                    | Let

Type            := OneType | FunctionType | SumType

OneType         := Identifier | Identifier<Type,+>
FunctionType    := '[' Type,* ']' = (Type,*)
SumType         := Type '|' Type

Identifier      := [:?]OneIdentifier[:OneIdentifier]*
OneIdentifier   := \alpha-numeric-sequence-starting-with-letter

Begin           := begin export?
                    [TypeInfo Newline]*
                   end

Namespace       := namespace OneIdentifier
                    [TypeInfo Newline]*
                   end

Newline         := \n

Given           := given [OneIdentifier | <OneIdentifier,+>]

FieldDecl       := OneIdentifier: Type
StructDecl      := Given? struct OneIdentifier
                    [Field Newline]*
                   end

FunctionDecl    := Given? function OneIdentifier
                    [FunctionType Newline]+
                   end

Let             := Given? let OneIdentifier = Type
                   

%}