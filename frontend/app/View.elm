module View exposing (..)

import Html exposing (Html, button, div, h1, a, p, span, text)
import Html.Attributes exposing (class, style, href, id)
import Html.Events exposing (onClick)
import Models exposing (Model)
import Messages exposing (Message(..))
import RemoteData exposing (WebData)
import Commands exposing (repoNameFromUrl)
import Material
import Material.Button as Button
import Material.Color as Color
import Material.Options as Options exposing (css, cs, when)


view : Model -> Html Message
view model =
    div []
        [ page model ]


page : Model -> Html Message
page model =
    case model.route of
        Models.MainPage ->
            mainPage model.issuesSearchResult model.mdl

        Models.AboutPage ->
            aboutPage

        Models.NotFoundRoute ->
            notFoundView


mainPage : WebData Models.IssueSearchResult -> Material.Model -> Html Message
mainPage issuesSearchResult mdl =
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
                (maybeIssueSearchResult issuesSearchResult mdl)
            ]
        ]


maybeIssueSearchResult : WebData Models.IssueSearchResult -> Material.Model -> List (Html Message)
maybeIssueSearchResult response mdl =
    case response of
        RemoteData.NotAsked ->
            [ text "" ]

        RemoteData.Loading ->
            [ text "Loading..." ]

        RemoteData.Success issueSearchResult ->
            List.map issueDiv issueSearchResult.issues
                |> List.map (\f -> f mdl)

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
            ]
        , div [ class "repo mdl-cell--3-col" ]
            [ div [ class "" ]
                [ Html.h5 [ class "title" ] [ text (repoNameFromUrl issue.repository_url) ]
                ]
            , div [ class "mdl-card__actions" ]
                [ mdlButton issue mdl
                , div [ class "issue-labels" ] (List.map labelDiv issue.labels)
                ]
            ]
        ]


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
