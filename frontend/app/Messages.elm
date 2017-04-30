module Messages exposing (Message(..))

import Models exposing (IssueSearchResult, OrderBy)
import RemoteData exposing (WebData)
import Navigation exposing (Location)
import Material


type Message
    = OnLocationChange Location
    | OnFetchIssues (WebData IssueSearchResult)
    | GoToAboutPage
    | GoToMainPage
    | Mdl (Material.Msg Message)
    | ButtonClick
    | SelectOrderBy OrderBy
    | ChangeLanguage String
