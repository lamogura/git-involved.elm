module Autocomplete.View exposing (autoComplete)

import Html exposing (Html, button, div, h1, a, p, span, text)
import Html.Attributes exposing (class, style, href, id)
import Html.Events exposing (onClick)
import Messages exposing (Message(..))
import Update
import Autocomplete
import Autocomplete.DefaultStyles as DefaultStyles
import Json.Decode as Json
import Material
import Material.Textfield as Textfield
import Material.Options as Options exposing (css, cs, when, styled)


type alias Model =
    { languageQuery : String
    , autocompleteState : Autocomplete.State
    , selectedLanguage : Maybe String
    , showingLanguageMenu : Bool
    , mdl : Material.Model
    }


autoComplete : Model -> Html Message
autoComplete model =
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
    div
        [ style DefaultStyles.menuStyles ]
        [ Html.map SetAutocompleteState (Autocomplete.view viewConfig 5 autocompleteState (Update.languageMatches query)) ]


viewConfig : Autocomplete.ViewConfig String
viewConfig =
    let
        customizedLi keySelected mouseSelected language =
            { attributes =
                [ if keySelected || mouseSelected then
                    style DefaultStyles.selectedItemStyles
                  else
                    style DefaultStyles.itemStyles
                , id language
                ]
            , children = [ Html.text (language) ]
            }
    in
        Autocomplete.viewConfig
            { toId = identity
            , ul = [ style DefaultStyles.listStyles ]
            , li = customizedLi
            }
