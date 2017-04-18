port module RunTestsInTerminal exposing (main)

import Test.Runner.Node exposing (TestProgram, run)
import Json.Encode exposing (Value)
import GitInvolvedTests exposing (allTests)
import Test exposing (describe)


main : TestProgram
main =
    run emit <|
        describe "Test suite"
            [ allTests
            ]


port emit : ( String, Value ) -> Cmd msg
