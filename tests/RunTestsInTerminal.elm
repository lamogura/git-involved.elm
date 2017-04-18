port module RunTestsInTerminal exposing (main)

import Test.Runner.Node exposing (run)
import Json.Encode exposing (Value)
import GitInvolvedTests exposing (allTests)


main =
    run emit allTests


port emit : ( String, Value ) -> Cmd msg
