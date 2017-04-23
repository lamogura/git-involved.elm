module View exposing (..)

import Html exposing (Html, button, div, h1, a, p, span, text)
import Html.Attributes exposing (class, href, id)
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
mainPage response =
    Html.body [ class "mdl-demo mdl-color-text--grey-700 mdl-base" ]
        [ div [ class "mdl-layout__container has-scrolling-header" ]
            [ div [ class "mdl-layout mdl-js-layout mdl-layout--fixed-header has-tabs is-upgraded" ]
                [ Html.header [ class "mdl-layout__header mdl-layout__header--scroll mdl-color--primary" ]
                    [ div [ class "mdl-layout--large-screen-only mdl-layout__header-row" ] []
                    , div [ class "mdl-layout--large-screen-only mdl-layout__header-row" ]
                        [ Html.h3 [] [ text "Git-Involved" ] ]
                    , div [ class "mdl-layout--large-screen-only mdl-layout__header-row" ] []
                    ]
                , Html.main_ [ class "mdl-layout__content mdl-color--grey-100" ]
                    [ Html.section [ class "section--center mdl-grid" ]
                        (maybeIssueSearchResult response)
                    ]
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
    div [ class "git-issue-card mdl-cell--12-col mdl-shadow--2dp" ]
        [ div [ class "git-issue mdl-cell mdl-cell--9-col" ]
            [ div [ class "mdl-card__supporting-text" ]
                [ Html.h4 [ class "issue-title" ] [ text ("Title: " ++ issue.title) ]
                , div [ class "issue-body" ] [ text ("Body: " ++ issue.body) ]
                ]
            , div [ class "mdl-card__actions" ]
                [ div [ class "issue-labels" ] (List.map labelDiv issue.labels)
                , div [ class "issue-comments mdl-button" ] [ text ("Comments: " ++ toString issue.commentCount) ]
                ]
            ]
        , div [ class "git-repo mdl-cell mdl-cell--3-col" ]
            [ div [ class "mdl-card__supporting-text" ]
                [ Html.h5 [ class "repo-title" ] [ text ("Repo: " ++ (repoNameFromUrl issue.repository_url)) ]
                ]
            , div [ class "mdl-card__actions" ]
                [ div [ class "issue-comments mdl-button" ] [ text ("Comments: " ++ toString issue.commentCount) ]
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
