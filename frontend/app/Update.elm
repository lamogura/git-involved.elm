module Update exposing (update)

import Models exposing (Model)
import Navigation
import Messages exposing (Message(..))
import Routing exposing (parseLocation)
import Material
import AutocompleteLang


-- = OnLocationChange Location
-- | GoToAboutPage
-- | GoToMainPage
-- | OnFetchIssues (WebData IssueSearchResult)
-- | SetOrderIssuesBy OrderBy
-- | SetAutocompleteState Autocomplete.Msg
-- | SetLanguageQuery String
-- | PreviewLanguage String
-- | SelectLanguageMouse String
-- | SelectLanguageKeyboard String
-- | Wrap Bool
-- | HandleEscape
-- | Reset
-- | NoOp
-- | Mdl (Material.Msg Message)


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                { model | route = newRoute } ! []

        GoToAboutPage ->
            ( model, Navigation.newUrl "#about" )

        GoToMainPage ->
            ( model, Navigation.newUrl "/" )

        OnFetchIssues response ->
            { model | issuesSearchResult = response } ! []

        SetOrderIssuesBy orderBy ->
            { model | orderIssuesBy = orderBy } ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model

        Acl autoMsg ->
            { model | autocompleteLang = Tuple.first <| AutocompleteLang.update autoMsg model.autocompleteLang } ! []
