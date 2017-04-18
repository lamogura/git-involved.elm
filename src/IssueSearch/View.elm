module IssueSearch.View exposing (..)

import Html exposing (Html, button, div, h1, header, input, p, span, text)
import Html.Attributes exposing (class)
import Types exposing (Issue)


issueCard : Issue -> Html a
issueCard issue =
    div [ class "git-issue" ]
        [ div [ class "issue-title" ] [ text ("Title: " ++ issue.title) ]
        , div [ class "issue-comments" ] [ text ("Comments: " ++ toString issue.commentCount) ]
        , div [ class "issue-body" ] [ text ("Body: " ++ issue.body) ]
        , div [ class "issue-something" ]
            [ div [] []
            , div [] []
            ]
        ]
