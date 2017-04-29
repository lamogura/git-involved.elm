module View exposing (..)

import Html exposing (Html, button, div, h1, a, p, span, text)
import Html.Attributes exposing (class, style, href, id)
import Html.Events exposing (onClick)
import Models exposing (Model)
import Messages exposing (Msg)
import RemoteData exposing (WebData)
import Commands exposing (repoNameFromUrl)


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        Models.MainPage ->
            mainPage model.issuesSearchResult

        Models.AboutPage ->
            aboutPage

        Models.NotFoundRoute ->
            notFoundView


mainPage : WebData Models.IssueSearchResult -> Html Msg
mainPage issuesSearchResult =
    Html.body [ class "mdl-color-text--grey-700" ]
        [ div [ class "page-layout" ]
            [ Html.header [ class "mdl-color--primary" ]
                [ div [ id "git-back" ]
                    [ Html.h4 [] [ text "Git-Back" ] ]
                , div [ class "caption" ]
                    [ Html.h3 [] [ text "Contribute to open source" ] ]
                , div [ class "subtitle" ]
                    [ Html.h6 [] [ text "Help out on unassigned open issues" ] ]
                ]
            , div [ class "left-sidebar mdl-color--grey-100" ] []
            , div [ class "right-sidebar mdl-color--grey-100" ] []
            , Html.main_ [ class "mdl-shadow--4dp" ]
                (maybeIssueSearchResult issuesSearchResult)
            ]
        ]


maybeIssueSearchResult : WebData Models.IssueSearchResult -> List (Html Msg)
maybeIssueSearchResult response =
    case response of
        RemoteData.NotAsked ->
            [ text "" ]

        RemoteData.Loading ->
            [ text "Loading..." ]

        RemoteData.Success issueSearchResult ->
            List.map issueDiv issueSearchResult.issues

        RemoteData.Failure error ->
            [ text (toString error) ]


issueDiv : Models.Issue -> Html Msg
issueDiv issue =
    div [ class "git-issue-card mdl-cell--12-col mdl-shadow--2dp" ]
        [ div [ class "git-issue mdl-cell--9-col" ]
            [ div [ class "mdl-card__supporting-text" ]
                [ Html.h3 [ class "issue-title" ] [ text issue.title ]
                , div [ class "issue-body" ]
                    [ if String.isEmpty issue.body then
                        text "No description"
                      else
                        text issue.body
                    ]
                ]
            , div [ class "mdl-card__actions" ]
                [ div [ class "issue-comments mdl-button" ] [ text ("Comments: " ++ toString issue.commentCount) ]
                , div [ class "issue-labels" ] (List.map labelDiv issue.labels)
                ]
            ]
        , div [ class "git-repo mdl-cell mdl-cell--3-col" ]
            [ div [ class "mdl-card__supporting-text", id "git-repo" ]
                [ Html.h5 [ class "repo-title" ] [ text (repoNameFromUrl issue.repository_url) ]
                ]
            ]
        ]


labelDiv : Models.Label -> Html Msg
labelDiv label =
    span
        [ class "label mdl-chip"
        , Html.Attributes.style [ ( "backgroundColor", "#" ++ label.color ) ]
        ]
        [ span [ class "mdl-chip__text" ] [ text (label.name) ] ]


aboutPage : Html Msg
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
