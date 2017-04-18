module GitInvolvedTests exposing (allTests)

import Test exposing (describe, test)
import Expect


allTests =
    describe "Addition"
        [ test "1 + 1 = 2" <|
            \() ->
                (1 + 1) |> Expect.equal 2
        ]
