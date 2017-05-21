module App exposing (..)

import Routing
import Messages exposing (Message(..))
import Navigation exposing (Location)
import Models exposing (Model, initialModel, Issue)
import Update exposing (update)
import View exposing (view)
import Commands exposing (fetchIssues)
import Autocomplete


init : Location -> ( Model, Cmd Message )
init location =
    let
        currentRoute =
            Routing.parseLocation location

        initModel =
            initialModel currentRoute
    in
        ( initModel, fetchIssues initModel.selectedLanguage )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.map SetAutoState Autocomplete.subscription



-- MAIN


main : Program Never Model Message
main =
    Navigation.program Messages.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
