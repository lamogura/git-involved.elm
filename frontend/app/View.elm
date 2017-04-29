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
            [ Html.header [ class "hero is-info is-medium" ]
                [ div [ class "git-back hero-head" ]
                    [ div [ class "nav-left" ]
                        [ Html.h3 [ class "column is-2" ] [ text "Git-Back" ] ]
                    ]
                , div [ class "caption hero-body" ]
                    [ div [ class "container has-text-centered" ]
                        [ Html.h1 [ class "title" ] [ text "Contribute to OPEN SOURCE" ]
                        , Html.h2 [ class "subtitle" ] [ text "discover unassiged open single issues to help on your free time" ]
                        ]
                    ]
                ]
            , Html.main_ [ class "columns" ]
                [ div [ class "column is-offset-1 is-10" ]
                    (maybeIssueSearchResult issuesSearchResult)
                ]
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
    div [ class "git-issue-card tile box" ]
        [ div [ class "git-issue tile is-parent" ]
            [ div [ class "tile is-child" ]
                [ Html.h3 [ class "issue-title title" ] [ text issue.title ]
                , Html.p [ class "issue-body" ]
                    [ if String.isEmpty issue.body then
                        text "No description"
                      else
                        text issue.body
                    ]
                ]
            ]
        , div [ class "git-repo tile is-3 is-parent" ]
            [ div [ class "tile git-repo is-child is-vertical" ]
                [ Html.h5 [ class "repo-title title" ] [ text (repoNameFromUrl issue.repository_url) ]
                , div [ class "issue-comments button" ] [ text ("Comments: " ++ toString issue.commentCount) ]
                , div [ class "issue-labels tag" ] (List.map labelDiv issue.labels)
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
