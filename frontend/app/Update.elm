module Update exposing (..)

import Models exposing (Model)
import Navigation
import Messages exposing (Message(..))
import Routing exposing (parseLocation)
import Material
import Autocomplete
import Dom
import Task


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
            ( { model | issuesSearchResult = response }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model

        SelectOrderBy orderBy ->
            { model | orderBy = orderBy } ! []

        SetQuery newQuery ->
            let
                showMenu =
                    not << List.isEmpty <| (acceptableLanguage newQuery model.languages)
            in
                { model | query = newQuery, showMenu = showMenu, selectedLanguage = Nothing } ! []

        SetAutoState autoMsg ->
            let
                ( newState, maybeMsg ) =
                    Autocomplete.update updateConfig autoMsg 5 model.autoState (acceptableLanguage model.query model.languages)

                newModel =
                    { model | autoState = newState }
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
                        |> resetMenu
            in
                newModel ! []

        SelectLanguageMouse id ->
            let
                newModel =
                    setQuery model id
                        |> resetMenu
            in
                ( newModel, Task.attempt (\_ -> NoOp) (Dom.focus "autocomplete-input") )

        Wrap toTop ->
            case model.selectedLanguage of
                Just language ->
                    update Reset model

                Nothing ->
                    if toTop then
                        { model
                            | autoState = Autocomplete.resetToLastItem updateConfig (acceptableLanguage model.query model.languages) 5 model.autoState
                            , selectedLanguage = List.head <| List.reverse <| List.take 5 <| (acceptableLanguage model.query model.languages)
                        }
                            ! []
                    else
                        { model
                            | autoState = Autocomplete.resetToFirstItem updateConfig (acceptableLanguage model.query model.languages) 5 model.autoState
                            , selectedLanguage = List.head <| List.take 5 <| (acceptableLanguage model.query model.languages)
                        }
                            ! []

        Reset ->
            { model | autoState = Autocomplete.reset updateConfig model.autoState, selectedLanguage = Nothing } ! []

        PreviewLanguage id ->
            { model | selectedLanguage = Just <| getLanguageAtId model.languages id } ! []

        HandleEscape ->
            let
                validOptions =
                    not <| List.isEmpty (acceptableLanguage model.query model.languages)

                handleEscape =
                    if validOptions then
                        model
                            |> removeSelection
                            |> resetMenu
                    else
                        { model | query = "" }
                            |> removeSelection
                            |> resetMenu

                escapedModel =
                    case model.selectedLanguage of
                        Just language ->
                            if model.query == language then
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
        | query = getLanguageAtId model.languages id
        , selectedLanguage = Just <| getLanguageAtId model.languages id
    }


getLanguageAtId : List String -> String -> String
getLanguageAtId languages id =
    List.filter (\language -> language == id) languages
        |> List.head
        |> Maybe.withDefault "Javascript"


removeSelection : Model -> Model
removeSelection model =
    { model | selectedLanguage = Nothing }


resetMenu : Model -> Model
resetMenu model =
    { model
        | autoState = Autocomplete.empty
        , showMenu = False
    }


resetInput : Model -> Model
resetInput model =
    { model | query = "" }
        |> removeSelection
        |> resetMenu


acceptableLanguage : String -> List String -> List String
acceptableLanguage query languages =
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
