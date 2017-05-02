module Messages exposing (Message(..))

import Models exposing (IssueSearchResult, OrderIssuesBy)
import RemoteData exposing (WebData)
import Navigation exposing (Location)
import Material
import Autocomplete


type Message
    = OnLocationChange Location
    | GoToAboutPage
    | GoToMainPage
    | OnFetchIssues (WebData IssueSearchResult)
    | SetOrderIssuesBy OrderIssuesBy
    | SetAutocompleteState Autocomplete.Msg
    | SetLanguageQuery String
    | PreviewLanguage String
    | SelectLanguageMouse String
    | SelectLanguageKeyboard String
    | Wrap Bool
    | HandleEscape
    | Reset
    | NoOp
    | Mdl (Material.Msg Message)
