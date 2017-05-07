module Messages exposing (Message(..))

import Models exposing (IssueSearchResult, OrderIssuesBy)
import RemoteData exposing (WebData)
import Navigation exposing (Location)
import Material
import Autocomplete


type Message
    = OnLocationChange Location
    | OnFetchIssues (WebData IssueSearchResult)
    | GoToAboutPage
    | GoToMainPage
    | Mdl (Material.Msg Message)
    | SelectOrderBy OrderIssuesBy
    | SetAutoState Autocomplete.Msg
    | SetQuery String
    | PreviewLanguage String
    | SelectLanguageMouse String
    | Reset
    | Wrap Bool
    | SelectLanguageKeyboard String
    | NoOp
    | HandleEscape
