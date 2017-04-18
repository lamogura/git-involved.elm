module RunTestsInBrowser exposing (main)

import Test.Runner.Html exposing (TestProgram, run)
import GitInvolvedTests exposing (allTests)
import Test exposing (describe)


main : TestProgram
main =
    run <|
        describe "Test suite"
            [ allTests
            ]
