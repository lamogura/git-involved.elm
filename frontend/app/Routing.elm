module Routing exposing (parseLocation)

import Navigation exposing (Location)
import UrlParser exposing (..)
import Models exposing (Route(..))


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map MainPage top
        , map AboutPage (s "about")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
