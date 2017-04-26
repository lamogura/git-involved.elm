module Update exposing (..)

import Models exposing (Model)
import Navigation
import Messages exposing (Msg)
import Routing exposing (parseLocation)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Messages.OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        Messages.GoToAboutPage ->
            ( model, Navigation.newUrl "#about" )

        Messages.GoToMainPage ->
            ( model, Navigation.newUrl "/" )

        Messages.OnFetchIssues response ->
            ( { model | issuesSearchResult = response }, Cmd.none )
