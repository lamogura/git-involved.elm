module State exposing (..)

import Navigation exposing (Location)
import Pages.Routing as Routing
import Pages.Types exposing (RoutingMsg(..), Route, Model)


initialModel : Route -> Model
initialModel someRoute =
    { route = someRoute }


init : Location -> ( Model, Cmd RoutingMsg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel currentRoute, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub RoutingMsg
subscriptions model =
    Sub.none



-- UPDATE


update : RoutingMsg -> Model -> ( Model, Cmd RoutingMsg )
update msg model =
    case msg of
        OnLocationChange location ->
            let
                newRoute =
                    Routing.parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        GoToAboutPage ->
            ( model, Navigation.newUrl "#about" )

        GoToHomePage ->
            ( model, Navigation.newUrl "/" )
