module View exposing (view)

import Html exposing (Html, button, div, h1, a, p, span, text)
import Html.Attributes exposing (class, style, href, id)
import Html.Events exposing (onClick)
import Models exposing (Model)
import Messages exposing (Message(..))
import Autocomplete.View exposing (autoComplete)
import RemoteData exposing (WebData)
import Commands exposing (repoNameFromUrl, dateFrom)
import Material
import Material.Menu as Menu
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
        [ div [ class "page-layout mdl-color--grey-200" ]
            [ styled Html.header
                [ cs "p1 mdl-color--primary"
                , css "color" "rgb(255,255,255)"
                ]
                [ styled Html.h5 [ cs "m2" ] [ text "Git-Back" ]
                , styled Html.h3
                    [ cs "mt4 center" ]
                    [ text "Contribute to open source" ]
                , styled Html.h6
                    [ cs "mb4 center" ]
                    [ text "Help out on unassigned open issues" ]
                ]
            , styled Html.main_
                [ cs "p2 mx-auto max-width-4" ]
                [ styled div
                    [ cs "flex flex-wrap justify-center" ]
                    [ (autoComplete
                        { languageQuery = model.languageQuery
                        , autocompleteState = model.autocompleteState
                        , selectedLanguage = model.selectedLanguage
                        , showingLanguageMenu = model.showingLanguageMenu
                        , mdl = model.mdl
                        }
                      )
                    , styled div
                        [ cs "mt3 ml2 flex" ]
                        [ text ("Order by:")
                        , text (toString model.orderIssuesBy)
                        , mdlMenu model.mdl
                        ]
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
        [ cs "issue-card fit rounded flex my3 mdl-shadow--2dp mdl-color--white" ]
        [ div [ class "content col col-10" ]
            [ styled div
                [ cs "fit py0 px3 mdl-card__supporting-text" ]
                [ styled Html.h3
                    [ cs "mt2" ]
                    [ text issue.title ]
                , styled div
                    [ cs "body overflow-hidden"
                    , css "min-height" "5rem"
                    , css "height" "auto"
                    ]
                    [ if String.isEmpty issue.body then
                        text "No description"
                      else
                        text issue.body
                    ]
                ]
            , styled div
                [ cs "flex items-center mdl-card__actions" ]
                [ issueCardAction issue
                , div [] (List.map labelDiv issue.labels)
                ]
            ]
        , styled div
            [ cs "repo fit p2 col col-2 xs-hide"
            , css "overflow-wrap" "break-word"
            ]
            [ Html.h5 [] [ text (repoNameFromUrl issue.repository_url) ]
            ]
        ]


issueCardAction : Models.Issue -> Html Message
issueCardAction issue =
    styled div
        [ cs "p2" ]
        [ text ("opened this issue on " ++ (dateFrom issue.createdAt) ++ " - " ++ (toString issue.commentCount) ++ " comments") ]


mdlMenu : Material.Model -> Html Message
mdlMenu mdlModel =
    Menu.render Mdl
        [ 1, 2, 3, 4 ]
        mdlModel
        [ Menu.ripple
        , Menu.bottomRight
        , Menu.icon "arrow_drop_down"
        ]
        [ Menu.item
            [ Menu.onSelect (SetOrderIssuesBy Models.LastUpdated) ]
            [ text "Last updated" ]
        , Menu.item
            [ Menu.onSelect (SetOrderIssuesBy Models.MostPopular) ]
            [ text "Most popular" ]
        ]


labelDiv : Models.Label -> Html Message
labelDiv label =
    styled span
        [ css "background-color" ("#" ++ label.color)
        , cs "m1 center mdl-chip"
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
