module RunTestsInBrowser exposing (main)

import Test.Runner.Html exposing (run)
import GitInvolvedTests exposing (allTests)


main =
    run allTests
