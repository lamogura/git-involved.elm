module View exposing (..)

import Html exposing (Html, div)
import Pages.View exposing (page)
import Pages.Types exposing (Model, RoutingMsg)


rootView : Model -> Html RoutingMsg
rootView model =
    div []
        [ page model ]
