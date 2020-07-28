module NoMissingDocumentationTest exposing (..)

import Review.Test exposing (ReviewResult)
import NoMissingDocumentation exposing (rule)
import Test exposing (Test)


{-| Rule to test
-}
testRule : String -> ReviewResult
testRule string =
    Review.Test.run rule string


{-| Test cases for NoUndocumentedTopLevelDeclarations rule
-}
tests : Test
tests =
    Test.describe "NoMissingDocumentation"
        [ Test.test "No errors are thrown in case function/type alias/custom type is documented" <|
            \() ->
                testRule """module A exposing (..)

{-| Documentation for custom type
-}
type A =
    String

{-| Documentation for type alias
-}
type alias ThisIsATypeAlias =
    A.B.OtherTypeConstructor SomeOtherTypes

{-| Documentation for function
-}
sum : Int -> Int -> Int
sum a b =
    a + b
"""
                    |> Review.Test.expectNoErrors
        , Test.test "Throws and error when documentation is missing for function/type alias/custom type" <|
            \() ->
                testRule """module A exposing (..)

type A =
    String


type alias ThisIsATypeAlias =
    A.B.OtherTypeConstructor SomeOtherTypes

sum : Int -> Int -> Int
sum a b =
    a + b
"""
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "No undocumented function/type alias/custom type"
                            , under = """type A =
    String"""
                            , details = [ "Every top level function/type alias/custom type must be documented" ]
                            }
                        , Review.Test.error
                            { message = "No undocumented function/type alias/custom type"
                            , under = """type alias ThisIsATypeAlias =
    A.B.OtherTypeConstructor SomeOtherTypes"""
                            , details = [ "Every top level function/type alias/custom type must be documented" ]
                            }
                        , Review.Test.error
                            { message = "No undocumented function/type alias/custom type"
                            , under = """sum : Int -> Int -> Int
sum a b =
    a + b"""
                            , details = [ "Every top level function/type alias/custom type must be documented" ]
                            }
                        ]
        ]
