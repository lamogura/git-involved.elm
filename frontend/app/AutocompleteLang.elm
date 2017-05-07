module AutocompleteLang exposing (..)

import Html exposing (Html, button, div, h1, a, p, span, text)
import Html.Attributes exposing (class, style, href, id)
import Html.Events exposing (onClick)
import Autocomplete
import Json.Decode as Json
import Material
import Material.Textfield as Textfield
import Material.Options as Options exposing (css, cs, when, styled)
import Dom
import Task


main : Program Never Model Message
main =
    Html.program
        { init = init ! []
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.map SetAutocompleteState Autocomplete.subscription


type alias Model =
    { languageQuery : String
    , autocompleteState : Autocomplete.State
    , selectedLanguage : Maybe String
    , showingLanguageMenu : Bool
    , mdl : Material.Model
    }


init : Model
init =
    { autocompleteState = Autocomplete.empty
    , selectedLanguage = Just "Javascript"
    , showingLanguageMenu = False
    , languageQuery = "Javascript"
    , mdl = Material.model
    }


type Message
    = SetAutocompleteState Autocomplete.Msg
    | SetLanguageQuery String
    | PreviewLanguage String
    | SelectLanguageMouse String
    | SelectLanguageKeyboard String
    | Wrap Bool
    | HandleEscape
    | Reset
    | NoOp
    | Mdl (Material.Msg Message)


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        SetLanguageQuery newQuery ->
            let
                showingLanguageMenu =
                    not << List.isEmpty <| (languageMatches newQuery)
            in
                { model | languageQuery = newQuery, showingLanguageMenu = showingLanguageMenu, selectedLanguage = Nothing } ! []

        SetAutocompleteState autoMsg ->
            let
                ( newState, maybeMsg ) =
                    Autocomplete.update updateConfig autoMsg 5 model.autocompleteState (languageMatches model.languageQuery)

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
                            | autocompleteState = Autocomplete.resetToLastItem updateConfig (languageMatches model.languageQuery) 5 model.autocompleteState
                            , selectedLanguage = List.head <| List.reverse <| (languageMatches model.languageQuery)
                        }
                            ! []
                    else
                        { model
                            | autocompleteState = Autocomplete.resetToFirstItem updateConfig (languageMatches model.languageQuery) 5 model.autocompleteState
                            , selectedLanguage = List.head <| (languageMatches model.languageQuery)
                        }
                            ! []

        Reset ->
            { model | autocompleteState = Autocomplete.reset updateConfig model.autocompleteState, selectedLanguage = Nothing } ! []

        PreviewLanguage id ->
            { model | selectedLanguage = Just <| getLanguageAtId id } ! []

        HandleEscape ->
            let
                validOptions =
                    not <| List.isEmpty (languageMatches model.languageQuery)

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
        , showingLanguageMenu = False
    }


resetInput : Model -> Model
resetInput model =
    { model | languageQuery = "" }
        |> removeSelectedLanguage
        |> resetLanguageMenu


allLanguages : List String
allLanguages =
    [ "Javascript", "Ruby", "Elm", "Java" ]


languageMatches : String -> List String
languageMatches query =
    let
        lowerQuery =
            String.toLower query
    in
        List.filter (String.contains lowerQuery << String.toLower) allLanguages


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


view : Model -> Html Message
view model =
    let
        options =
            { preventDefault = True, stopPropagation = False }

        dec =
            (Json.map
                (\code ->
                    if code == 38 || code == 40 then
                        Ok NoOp
                    else if code == 27 then
                        Ok HandleEscape
                    else
                        Err "not handling that key"
                )
                Html.Events.keyCode
            )
                |> Json.andThen
                    fromResult

        fromResult : Result String a -> Json.Decoder a
        fromResult result =
            case result of
                Ok val ->
                    Json.succeed val

                Err reason ->
                    Json.fail reason

        menu =
            if model.showingLanguageMenu then
                [ viewMenu query model.autocompleteState ]
            else
                []

        query =
            case model.selectedLanguage of
                Just language ->
                    language

                Nothing ->
                    model.languageQuery
    in
        div []
            (List.append
                [ Textfield.render Mdl
                    [ 17 ]
                    model.mdl
                    [ Textfield.label "Show me repos using"
                    , Textfield.floatingLabel
                    , Textfield.value query
                    , Textfield.autofocus
                    , Options.onInput SetLanguageQuery
                    , Options.id "autocomplete-input"
                    ]
                    []
                ]
                menu
            )


viewMenu : String -> Autocomplete.State -> Html Message
viewMenu query autocompleteState =
    styled div
        [ cs "border rounded bg-white"
        , css "z-index" "11110"
        ]
        [ Html.map SetAutocompleteState (Autocomplete.view viewConfig 5 autocompleteState (languageMatches query)) ]


viewConfig : Autocomplete.ViewConfig String
viewConfig =
    let
        customizedLi keySelected mouseSelected language =
            { attributes =
                [ if keySelected || mouseSelected then
                    style selectedItemStyles
                  else
                    style itemStyles
                , id language
                ]
            , children = [ Html.text (language) ]
            }
    in
        Autocomplete.viewConfig
            { toId = identity
            , ul = [ style listStyles ]
            , li = customizedLi
            }


selectedItemStyles : List ( String, String )
selectedItemStyles =
    [ ( "background", "#3366FF" )
    , ( "color", "white" )
    , ( "display", "block" )
    , ( "padding", "5px 10px" )
    , ( "border-bottom", "1px solid #DDD" )
    , ( "cursor", "pointer" )
    ]


listStyles : List ( String, String )
listStyles =
    [ ( "list-style", "none" )
    , ( "padding", "0" )
    , ( "margin", "auto" )
    , ( "overflow-y", "auto" )
    ]


itemStyles : List ( String, String )
itemStyles =
    [ ( "display", "block" )
    , ( "padding", "5px 10px" )
    , ( "border-bottom", "1px solid #DDD" )
    , ( "cursor", "pointer" )
    ]
