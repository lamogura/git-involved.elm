module Pages.Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)
import Pages.Types exposing (Route(..))


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map HomePage top
        , map AboutPage (s "about")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
