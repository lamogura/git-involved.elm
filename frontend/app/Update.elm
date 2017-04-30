module Update exposing (..)

import Models exposing (Model)
import Navigation
import Messages exposing (Message(..))
import Routing exposing (parseLocation)
import Material


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        GoToAboutPage ->
            ( model, Navigation.newUrl "#about" )

        GoToMainPage ->
            ( model, Navigation.newUrl "/" )

        OnFetchIssues response ->
            ( { model | issuesSearchResult = response }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model

        ButtonClick ->
            ( model, Cmd.none )

        SelectOrderBy orderBy ->
            ( { model | orderBy = orderBy }, Cmd.none )

        ChangeLanguage input ->
            ( { model | language = input }, Cmd.none )
