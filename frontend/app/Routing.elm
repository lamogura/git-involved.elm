module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = MainPage
    | AboutPage
    | NotFoundRoute


type alias Model =
    Route


type Message
    = OnLocationChange Location
    | GoToAboutPage
    | GoToMainPage


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                newRoute ! []

        GoToAboutPage ->
            ( model, Navigation.newUrl "#about" )

        GoToMainPage ->
            ( model, Navigation.newUrl "/" )


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
