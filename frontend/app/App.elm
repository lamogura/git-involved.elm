module App exposing (..)

import Routing
import Messages exposing (Message(..))
import Navigation exposing (Location)
import Routing
import Models exposing (Model, initialModel)
import Update exposing (update)
import Commands exposing (fetchIssues)
import View exposing (view)
import AutocompleteLang


init : Location -> ( Model, Cmd Message )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel currentRoute, fetchIssues )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.map Acl (AutocompleteLang.subscriptions model.autocompleteLang)



-- MAIN


main : Program Never Model Message
main =
    Navigation.program (\location -> Rtg (Routing.OnLocationChange location))
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
