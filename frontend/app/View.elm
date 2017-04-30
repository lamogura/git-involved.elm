module View exposing (..)

import Html exposing (Html, button, div, h1, a, p, span, text)
import Html.Attributes exposing (class, style, href, id)
import Html.Events exposing (onClick)
import Models exposing (Model)
import Messages exposing (Message(..))
import RemoteData exposing (WebData)
import Commands exposing (repoNameFromUrl, dateFrom)
import Material
import Material.Button as Button
import Material.Menu as Menu
import Material.Textfield as Textfield
import Material.Options as Options exposing (css, cs, when)


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
        [ div [ class "page-layout" ]
            [ Html.header [ class "mdl-color--primary" ]
                [ div [ class "hero-git-back" ]
                    [ Html.h5 [] [ text "Git-Back" ] ]
                , div [ class "hero-caption" ]
                    [ Html.h3 [] [ text "Contribute to open source" ] ]
                , div [ class "hero-subtitle" ]
                    [ Html.h6 [] [ text "Help out on unassigned open issues" ] ]
                ]
            , div [ class "left-sidebar mdl-color--grey-100" ] []
            , div [ class "right-sidebar mdl-color--grey-100" ] []
            , Html.main_ [ class "mdl-shadow--4dp" ]
                [ Options.styled div
                    [ css "display" "flex"
                    , css "flex-direction" "row"
                    , css "justify-content" "center"
                    ]
                    [ mdlTextfield model
                    , Options.styled div
                        [ css "margin-top" "20px"
                        , css "margin-left" "1rem"
                        ]
                        [ text ("Order by: " ++ toString model.orderBy) ]
                    , mdlMenu model.mdl
                    ]
                , div [ class "issues-section" ] (maybeIssueSearchResult model)
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
    div [ class "issue-card mdl-cell--12-col mdl-shadow--2dp" ]
        [ div [ class "content mdl-cell--10-col" ]
            [ div [ class "mdl-card__supporting-text" ]
                [ Html.h3 [ class "title" ] [ text issue.title ]
                , div [ class "body" ]
                    [ if String.isEmpty issue.body then
                        text "No description"
                      else
                        text issue.body
                    ]
                ]
            , Options.styled div
                [ css "display" "flex"
                , css "flex-direction" "row"
                , css "align-items" "center"
                , cs "mdl-card__actions"
                ]
                [ issueCardAction issue
                , div [ class "issue-labels" ] (List.map labelDiv issue.labels)
                ]
            ]
        , div [ class "repo mdl-cell--3-col" ]
            [ div [ class "" ]
                [ Html.h5 [ class "title" ] [ text (repoNameFromUrl issue.repository_url) ]
                ]
            ]
        ]


issueCardAction : Models.Issue -> Html Message
issueCardAction issue =
    Options.styled div
        [ css "padding" "1rem" ]
        [ text ("opened this issue on " ++ (dateFrom issue.createdAt) ++ " - " ++ (toString issue.commentCount) ++ " comments") ]


mdlButton : Models.Issue -> Material.Model -> Html Message
mdlButton issue mdlModel =
    Button.render Mdl
        [ issue.id ]
        mdlModel
        [ Button.ripple
        , Button.flat
        , Options.onClick ButtonClick
        ]
        [ text ("Comments: " ++ toString issue.commentCount) ]


mdlTextfield : Model -> Html Message
mdlTextfield model =
    Textfield.render Mdl
        [ 17 ]
        model.mdl
        [ Textfield.label "Show me repos using"
        , Textfield.floatingLabel
        , Textfield.value model.language
        , Textfield.autofocus
        , Options.onInput ChangeLanguage
        ]
        []


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
    span
        [ class "label mdl-chip"
        , Html.Attributes.style [ ( "backgroundColor", "#" ++ label.color ) ]
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
