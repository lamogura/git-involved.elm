module Pages.View exposing (..)

import Array
import Pages.Types exposing (Route(..), RoutingMsg(..), Model)
import Html exposing (Html, button, div, h1, header, input, p, span, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import DummyData exposing (dummySearchResult)
import IssueSearch.View exposing (issueCard)


page : Model -> Html RoutingMsg
page model =
    case model.route of
        HomePage ->
            homePage

        AboutPage ->
            aboutPage

        NotFoundRoute ->
            notFoundView


aboutPage : Html RoutingMsg
aboutPage =
    div [ class "jumbotron" ]
        [ div [ class "container" ]
            [ h1 [] [ text "This is <about> page" ]
            , button [ onClick GoToHomePage, class "btn btn-primary btn-lg" ] [ text "Go To About Page" ]
            ]
        ]


homePage : Html RoutingMsg
homePage =
    div [ class "mdl-layout mdl-js-layout mdl-layout--fixed-header" ]
        [ header [ class "mdl-layout__header" ]
            [ div [ class "mdl-layout__header-row" ]
                [ span [ class "mdl-layout__title" ] [ text "Git-Involved" ] ]
            ]
        , div [] [ text "Show me repos using" ]
        , input [] []
        , div [ class "mdl-layout__content" ]
            [ div [ class "git-issues" ]
                (Array.toList (Array.map issueCard dummySearchResult.issues))
            ]
        ]


notFoundView : Html RoutingMsg
notFoundView =
    div []
        [ text "Not Found" ]
