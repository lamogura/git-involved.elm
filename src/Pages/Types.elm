module Pages.Types exposing (..)

import Navigation exposing (Location)


type alias Model =
    { route : Route }


type Route
    = HomePage
    | AboutPage
    | NotFoundRoute


type RoutingMsg
    = OnLocationChange Location
    | GoToAboutPage
    | GoToHomePage
