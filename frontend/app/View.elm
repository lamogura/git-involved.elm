module View exposing (..)

import Html exposing (Html, button, div, h1, a, p, span, text)
import Html.Attributes exposing (class, style, href, id)
import Html.Events exposing (onClick)
import Models exposing (Model)
import Messages exposing (Message(..))
import Update
import Autocomplete
import Autocomplete.DefaultStyles as DefaultStyles
import RemoteData exposing (WebData)
import Json.Decode as Json
import Commands exposing (repoNameFromUrl, dateFrom)
import Material
import Material.Menu as Menu
import Material.Textfield as Textfield
import Material.Options as Options exposing (css, cs, when, styled)


view : Model -> Html Message
view model =
    div []
        [ page model ]


page : Model -> Html Message
page model =
    case model.route of
        Models.MainPage ->
            mainPage model

        Models.AboutPage ->
            aboutPage

        Models.NotFoundRoute ->
            notFoundView


mainPage : Model -> Html Message
mainPage model =
    Html.body [ class "mdl-color-text--grey-700" ]
        [ div [ class "page-layout mdl-color--grey-100" ]
            [ styled Html.header
                [ cs "mdl-color--primary"
                , css "padding" "1rem"
                , css "color" "rgb(255,255,255)"
                ]
                [ styled Html.h5 [ css "margin" "1rem" ] [ text "Git-Back" ]
                , styled Html.h3
                    [ css "text-align" "center"
                    , css "margin-top" "5rem"
                    ]
                    [ text "Contribute to open source" ]
                , styled Html.h6
                    [ css "text-align" "center"
                    , css "margin-bottom" "3rem"
                    ]
                    [ text "Help out on unassigned open issues" ]
                ]
            , styled Html.main_
                [ css "padding" "1rem" ]
                [ styled div
                    [ css "display" "flex"
                    , css "flex-direction" "row"
                    , css "justify-content" "center"
                    ]
                    [ autoComplete model
                    , styled div
                        [ css "margin-top" "1.5rem"
                        , css "margin-left" "1rem"
                        ]
                        [ text ("Order by: " ++ toString model.orderBy) ]
                    , mdlMenu model.mdl
                    ]
                , div [] (maybeIssueSearchResult model)
                ]
            ]
        ]


maybeIssueSearchResult : Model -> List (Html Message)
maybeIssueSearchResult model =
    case model.issuesSearchResult of
        RemoteData.NotAsked ->
            [ text "" ]

        RemoteData.Loading ->
            [ text "Loading..." ]

        RemoteData.Success issueSearchResult ->
            List.map issueDiv issueSearchResult.issues
                |> List.map (\f -> f model.mdl)

        RemoteData.Failure error ->
            [ text (toString error) ]


issueDiv : Models.Issue -> Material.Model -> Html Message
issueDiv issue mdl =
    styled div
        [ cs "issue-card mdl-cell--12-col mdl-shadow--2dp mdl-color--white"
        , css "display" "flex"
        , css "width" "100%"
        , css "margin" "2rem 0px"
        , css "border-radius" "5px"
        ]
        [ div [ class "content mdl-cell--10-col" ]
            [ styled div
                [ css "padding" "0rem 2rem"
                , css "width" "auto"
                , cs "mdl-card__supporting-text"
                ]
                [ styled Html.h3
                    [ css "margin-top" "1rem"
                    ]
                    [ text issue.title ]
                , styled div
                    [ cs "body"
                    , css "min-height" "5rem"
                    , css "height" "auto"
                    , css "overflow" "hidden"
                    ]
                    [ if String.isEmpty issue.body then
                        text "No description"
                      else
                        text issue.body
                    ]
                ]
            , styled div
                [ css "display" "flex"
                , css "flex-direction" "row"
                , css "align-items" "center"
                , cs "mdl-card__actions"
                ]
                [ issueCardAction issue
                , div [] (List.map labelDiv issue.labels)
                ]
            ]
        , styled div
            [ cs "repo mdl-cell--2-col"
            , css "padding" "1rem"
            ]
            [ Html.h5 [] [ text (repoNameFromUrl issue.repository_url) ]
            ]
        ]


issueCardAction : Models.Issue -> Html Message
issueCardAction issue =
    styled div
        [ css "padding" "1rem" ]
        [ text ("opened this issue on " ++ (dateFrom issue.createdAt) ++ " - " ++ (toString issue.commentCount) ++ " comments") ]


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
            if model.showMenu then
                [ viewMenu model ]
            else
                []

        query =
            case model.selectedLanguage of
                Just language ->
                    language

                Nothing ->
                    model.query
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
                    , Options.onInput SetQuery
                    , Options.id "autocomplete-input"
                    ]
                    []
                ]
                menu
            )


viewMenu : Model -> Html Message
viewMenu model =
    div
        [ style DefaultStyles.menuStyles ]
        [ Html.map SetAutoState (Autocomplete.view viewConfig 5 model.autoState (Update.acceptableLanguage model.query model.languages)) ]


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


mdlMenu : Material.Model -> Html Message
mdlMenu mdlModel =
    Menu.render Mdl
        [ 1, 2, 3, 4 ]
        mdlModel
        [ Menu.ripple
        , Menu.bottomRight
        , Menu.icon "arrow_drop_down"
        , Options.css "margin-top" "1rem"
        ]
        [ Menu.item
            [ Menu.onSelect (SelectOrderBy Models.LastUpdated) ]
            [ text "Last updated" ]
        , Menu.item
            [ Menu.onSelect (SelectOrderBy Models.MostPopular) ]
            [ text "Most popular" ]
        ]


labelDiv : Models.Label -> Html Message
labelDiv label =
    styled span
        [ css "text-align" "center"
        , css "background-color" ("#" ++ label.color)
        , css "margin" "0.1rem"
        , cs "mdl-chip"
        ]
        [ span [ class "mdl-chip__text" ] [ text (label.name) ] ]


aboutPage : Html Message
aboutPage =
    div [ class "jumbotron" ]
        [ div [ class "container" ]
            [ h1 [] [ text "This is <about> page" ]
            , button [ onClick Messages.GoToMainPage, class "btn btn-primary btn-lg" ] [ text "Go To Main Page" ]
            ]
        ]


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
