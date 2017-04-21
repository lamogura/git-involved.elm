module Main exposing (..)

import Routing exposing (parseLocation)
import Messages exposing (Msg(..))
import Navigation exposing (Location)
import Routing exposing (Route)
import Html exposing (Html, button, div, h1, a, p, span, text)
import Html.Attributes exposing (class, href, id)
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
                        (List.map issueDiv dummySearchResult.issues)
                    ]
                ]
            ]
        ]


issueDiv : Issue -> Html Msg
issueDiv issue =
    div [ class "git-issue mdl-card mdl-cell mdl-cell--12-col mdl-shadow--2dp" ]
        [ div [ class "mdl-card__supporting-text" ]
            [ Html.h4 [ class "issue-title" ] [ text ("Title: " ++ issue.title) ]
            , div [ class "issue-body" ] [ text ("Body: " ++ issue.body) ]
            ]
        , div [ class "mdl-card__actions" ]
            [ div [ class "issue-labels" ] (List.map labelDiv issue.labels)
            , div [ class "issue-comments" ] [ text ("Comments: " ++ toString issue.commentCount) ]
            ]
        ]


labelDiv : Types.Label -> Html Msg
labelDiv label =
    span
        [ class "label mdl-chip"
        , Html.Attributes.style [ ( "backgroundColor", "#" ++ label.color ) ]
        ]
        [ span [ class "mdl-chip__text" ] [ text (label.name) ] ]



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
