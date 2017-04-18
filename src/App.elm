module App exposing (..)

import Navigation
import State
import View
import Pages.Types exposing (Model, RoutingMsg(..))


main : Program Never Model RoutingMsg
main =
    Navigation.program OnLocationChange
        { init = State.init
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.rootView
        }
