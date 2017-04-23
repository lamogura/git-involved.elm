module App exposing (..)

import Routing
import Messages exposing (Msg(..))
import Navigation exposing (Location)
import Routing
import Models exposing (Model, initialModel, Issue)
import Update exposing (update)
import View exposing (view)
import Commands exposing (fetchIssues)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel currentRoute, fetchIssues )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
