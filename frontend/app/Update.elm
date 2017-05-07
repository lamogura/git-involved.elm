module Update exposing (..)

import Models exposing (Model)
import Navigation
import Messages exposing (Message(..))
import Routing exposing (parseLocation)
import Material
import Autocomplete
import Dom
import Task


allLanguages : List String
allLanguages =
    [ "Javascript", "Ruby", "Elm", "Java" ]


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

        Mdl msg_ ->
            Material.update Mdl msg_ model

        SetOrderIssuesBy orderBy ->
            { model | orderIssuesBy = orderBy } ! []

        SetQuery newQuery ->
            let
                showMenu =
                    not << List.isEmpty <| (languageMatches newQuery allLanguages)
            in
                { model | languageQuery = newQuery, showLanguageMenu = showMenu, selectedLanguage = Nothing } ! []

        SetAutoState autoMsg ->
            let
                ( newState, maybeMsg ) =
                    Autocomplete.update updateConfig autoMsg 5 model.autocompleteState (languageMatches model.languageQuery allLanguages)

                newModel =
                    { model | autocompleteState = newState }
            in
                case maybeMsg of
                    Nothing ->
                        newModel ! []

                    Just updateMsg ->
                        update updateMsg newModel

        SelectLanguageKeyboard id ->
            let
                newModel =
                    setQuery model id
                        |> resetLanguageMenu
            in
                newModel ! []

        SelectLanguageMouse id ->
            let
                newModel =
                    setQuery model id
                        |> resetLanguageMenu
            in
                ( newModel, Task.attempt (\_ -> NoOp) (Dom.focus "autocomplete-input") )

        Wrap toTop ->
            case model.selectedLanguage of
                Just language ->
                    update Reset model

                Nothing ->
                    if toTop then
                        { model
                            | autocompleteState = Autocomplete.resetToLastItem updateConfig (languageMatches model.languageQuery allLanguages) 5 model.autocompleteState
                            , selectedLanguage = List.head <| List.reverse <| List.take 5 <| (languageMatches model.languageQuery allLanguages)
                        }
                            ! []
                    else
                        { model
                            | autocompleteState = Autocomplete.resetToFirstItem updateConfig (languageMatches model.languageQuery allLanguages) 5 model.autocompleteState
                            , selectedLanguage = List.head <| List.take 5 <| (languageMatches model.languageQuery allLanguages)
                        }
                            ! []

        Reset ->
            { model | autocompleteState = Autocomplete.reset updateConfig model.autocompleteState, selectedLanguage = Nothing } ! []

        PreviewLanguage id ->
            { model | selectedLanguage = Just <| getLanguageAtId id } ! []

        HandleEscape ->
            let
                validOptions =
                    not <| List.isEmpty (languageMatches model.languageQuery allLanguages)

                handleEscape =
                    if validOptions then
                        model
                            |> removeSelectedLanguage
                            |> resetLanguageMenu
                    else
                        { model | languageQuery = "" }
                            |> removeSelectedLanguage
                            |> resetLanguageMenu

                escapedModel =
                    case model.selectedLanguage of
                        Just language ->
                            if model.languageQuery == language then
                                model
                                    |> resetInput
                            else
                                handleEscape

                        Nothing ->
                            handleEscape
            in
                escapedModel ! []

        NoOp ->
            model ! []


setQuery : Model -> String -> Model
setQuery model id =
    { model
        | languageQuery = getLanguageAtId id
        , selectedLanguage = Just <| getLanguageAtId id
    }


getLanguageAtId : String -> String
getLanguageAtId id =
    List.filter (\language -> language == id) allLanguages
        |> List.head
        |> Maybe.withDefault "Javascript"


removeSelectedLanguage : Model -> Model
removeSelectedLanguage model =
    { model | selectedLanguage = Nothing }


resetLanguageMenu : Model -> Model
resetLanguageMenu model =
    { model
        | autocompleteState = Autocomplete.empty
        , showLanguageMenu = False
    }


resetInput : Model -> Model
resetInput model =
    { model | languageQuery = "" }
        |> removeSelectedLanguage
        |> resetLanguageMenu


languageMatches : String -> List String -> List String
languageMatches query languages =
    let
        lowerQuery =
            String.toLower query
    in
        List.filter (String.contains lowerQuery << String.toLower) languages


updateConfig : Autocomplete.UpdateConfig Message String
updateConfig =
    Autocomplete.updateConfig
        { toId = identity
        , onKeyDown =
            \code maybeId ->
                if code == 38 || code == 40 then
                    Maybe.map PreviewLanguage maybeId
                else if code == 13 then
                    Maybe.map SelectLanguageKeyboard maybeId
                else
                    Just <| Reset
        , onTooLow = Just <| Wrap False
        , onTooHigh = Just <| Wrap True
        , onMouseEnter = \id -> Just <| PreviewLanguage id
        , onMouseLeave = \_ -> Nothing
        , onMouseClick = \id -> Just <| SelectLanguageMouse id
        , separateSelections = False
        }
