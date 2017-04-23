module Messages exposing (..)

import Models exposing (IssueSearchResult)
import RemoteData exposing (WebData)
import Navigation exposing (Location)


type Msg
    = OnLocationChange Location
    | OnFetchIssues (WebData IssueSearchResult)
    | GoToAboutPage
    | GoToMainPage
