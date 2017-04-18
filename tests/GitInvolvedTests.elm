module GitInvolvedTests exposing (allTests)

import Test exposing (Test, describe, test, fuzz, fuzz2)
import Expect
import Fuzz exposing (..)


add : number -> number -> number
add x y =
    x + y


allTests : Test
allTests =
    describe "Addition"
        [ fuzz2 int int "given two integer" <|
            \num1 num2 ->
                add num1 num2
                    |> Expect.equal (num1 + num2)
        ]
