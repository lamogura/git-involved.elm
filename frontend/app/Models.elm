module Models exposing (..)

import AutocompleteLang
import RemoteData exposing (WebData)
import Material
import Routing


-- [ "Javascript", "Ruby", "Elm", "Java" ]


initialModel : Routing.Route -> Model
initialModel route =
    { issuesSearchResult = RemoteData.Loading
    , route = route
    , autocompleteLang = AutocompleteLang.init
    , orderIssuesBy = LastUpdated
    , mdl = Material.model
    }


type alias Model =
    { issuesSearchResult : WebData IssueSearchResult
    , route : Routing.Model
    , autocompleteLang : AutocompleteLang.Model
    , orderIssuesBy : OrderIssuesBy
    , mdl : Material.Model
    }


type alias IssueSearchResult =
    { totalCount : Int
    , issues : List Issue
    }


type alias Issue =
    { title : String
    , body : String
    , commentCount : Int
    , repository_url : String
    , labels : List Label
    , id : Int
    , createdAt : String
    , updatedAt : String
    }


type alias Label =
    { name : String
    , color : String
    }


type OrderIssuesBy
    = LastUpdated
    | MostPopular
