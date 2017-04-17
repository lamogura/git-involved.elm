module Main exposing (..)

import Array
import Routing exposing (parseLocation)
import Messages exposing (Msg(..))
import Navigation exposing (Location)
import Routing exposing (Route)
import Html exposing (Html, button, div, h1, header, input, p, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Routing exposing (Route(..))
import Types exposing (Issue)
import DummyData exposing (dummySearchResult)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel currentRoute, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { route : Routing.Route }


initialModel : Routing.Route -> Model
initialModel route =
    { route = route }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ page model ]


mainPage : Html Msg
mainPage =
    div [ class "mdl-layout mdl-js-layout mdl-layout--fixed-header" ]
        [ header [ class "mdl-layout__header" ]
            [ div [ class "mdl-layout__header-row" ]
                [ span [ class "mdl-layout__title" ] [ text "Git-Involved" ] ]
            ]
        , div [] [ text "Show me repos using" ]
        , input [] []
        , div [ class "mdl-layout__content" ]
            [ div [ class "git-issues" ]
                (Array.toList (Array.map issueDiv dummySearchResult.issues))
            ]
        ]


issueDiv : Issue -> Html Msg
issueDiv issue =
    div [ class "git-issue" ]
        [ div [ class "issue-title" ] [ text ("Title: " ++ issue.title) ]
        , div [ class "issue-comments" ] [ text ("Comments: " ++ toString issue.commentCount) ]
        , div [ class "issue-body" ] [ text ("Body: " ++ issue.body) ]
        , div [ class "issue-something" ]
            [ div [] []
            , div [] []
            ]
        ]



--div [ class "jumbotron" ]
--  [ div [ class "container" ]
--    [ h1 [] [ text "Welcome to Elm Main page" ]
--    , p [] [ text "A delightful language for reliable webapps." ]
--    , button [ onClick GoToAboutPage, class "btn btn-primary btn-lg" ] [ text "Go To About Page" ]
--    ]
--  ]


aboutPage : Html Msg
aboutPage =
    div [ class "jumbotron" ]
        [ div [ class "container" ]
            [ h1 [] [ text "This is <about> page" ]
            , button [ onClick GoToMainPage, class "btn btn-primary btn-lg" ] [ text "Go To About Page" ]
            ]
        ]


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not Found" ]


page : Model -> Html Msg
page model =
    case model.route of
        MainPage ->
            mainPage

        AboutPage ->
            aboutPage

        NotFoundRoute ->
            notFoundView



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        GoToAboutPage ->
            ( model, Navigation.newUrl "#about" )

        GoToMainPage ->
            ( model, Navigation.newUrl "/" )
