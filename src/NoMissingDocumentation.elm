module NoMissingDocumentation exposing (..)


import Elm.Syntax.Declaration exposing (Declaration(..))
import Elm.Syntax.Documentation exposing (Documentation)
import Elm.Syntax.Node exposing (Node(..))
import Elm.Syntax.Range exposing (Range)
import Review.Rule as Rule exposing (Direction(..), Error, Rule)


{-| Rule configuration for checking every top level declarations has documentation
-}
rule : Rule
rule =
    Rule.newModuleRuleSchema "NoMissingDocumentation" ()
        |> Rule.withSimpleDeclarationVisitor declarationVisitor
        |> Rule.fromModuleRuleSchema


{-| Is documentation present
-}
isWithDocumentation : Maybe (Node Documentation) -> Bool
isWithDocumentation maybeDocumentationNode =
    maybeDocumentationNode /= Nothing


{-| Checks if node contains documentation and throws an error if not
-}
throwRuleErrorIfNoDocumentation : Maybe (Node Documentation) -> Range -> List (Error {})
throwRuleErrorIfNoDocumentation maybeDocumentationNode range =
    if isWithDocumentation maybeDocumentationNode then
        []

    else
        [ Rule.error
            { message = "No undocumented function/type alias/custom type"
            , details = [ "Every top level function/type alias/custom type must be documented" ]
            }
            range
        ]


{-| Declaration visitor
-}
declarationVisitor : Node Declaration -> List (Error {})
declarationVisitor (Node range declarationNode) =
    case declarationNode of
        AliasDeclaration { documentation } ->
            throwRuleErrorIfNoDocumentation documentation range

        FunctionDeclaration { documentation } ->
            throwRuleErrorIfNoDocumentation documentation range

        CustomTypeDeclaration { documentation } ->
            throwRuleErrorIfNoDocumentation documentation range

        _ ->
            []
