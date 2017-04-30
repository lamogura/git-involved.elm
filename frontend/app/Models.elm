module Models exposing (..)

import Autocomplete
import RemoteData exposing (WebData)
import Material


initialModel : Route -> Model
initialModel route =
    { issuesSearchResult = RemoteData.Loading
    , route = route
    , languages = [ Javascript, Ruby, Elm, Java ]
    , autoState = Autocomplete.empty
    , selectedLanguage = Just Javascript
    , showMenu = False
    , query = "Javascript"
    , orderBy = LastUpdated
    , mdl = Material.model
    }


type alias Model =
    { issuesSearchResult : WebData IssueSearchResult
    , route : Route
    , languages : List Language
    , autoState : Autocomplete.State
    , selectedLanguage : Maybe Language
    , showMenu : Bool
    , query : String
    , orderBy : OrderBy
    , mdl : Material.Model
    }


type alias IssueSearchResult =
    { totalCount : Int
    , issues : List Issue
    }


type Language
    = Ruby
    | Javascript
    | Elm
    | Java


type OrderBy
    = LastUpdated
    | MostPopular


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


type Route
    = MainPage
    | AboutPage
    | NotFoundRoute



-- GITHUB ISSUE SEARCH RESULT JSON
--
--{
--  "total_count": 9047620,
--  "incomplete_results": false,
--  "items": [
--    {
--      "url": "https://api.github.com/repos/jouni-kantola/templated-assets-webpack-plugin/issues/24",
--      "repository_url": "https://api.github.com/repos/jouni-kantola/templated-assets-webpack-plugin",
--      "labels_url": "https://api.github.com/repos/jouni-kantola/templated-assets-webpack-plugin/issues/24/labels{/name}",
--      "comments_url": "https://api.github.com/repos/jouni-kantola/templated-assets-webpack-plugin/issues/24/comments",
--      "events_url": "https://api.github.com/repos/jouni-kantola/templated-assets-webpack-plugin/issues/24/events",
--      "html_url": "https://github.com/jouni-kantola/templated-assets-webpack-plugin/issues/24",
--      "id": 221998343,
--      "number": 24,
--      "title": "TypeError: Cannot read property 'test' of undefined",
--      "user": {
--        "login": "jouni-kantola",
--        "id": 2670127,
--        "avatar_url": "https://avatars0.githubusercontent.com/u/2670127?v=3",
--        "gravatar_id": "",
--        "url": "https://api.github.com/users/jouni-kantola",
--        "html_url": "https://github.com/jouni-kantola",
--        "followers_url": "https://api.github.com/users/jouni-kantola/followers",
--        "following_url": "https://api.github.com/users/jouni-kantola/following{/other_user}",
--        "gists_url": "https://api.github.com/users/jouni-kantola/gists{/gist_id}",
--        "starred_url": "https://api.github.com/users/jouni-kantola/starred{/owner}{/repo}",
--        "subscriptions_url": "https://api.github.com/users/jouni-kantola/subscriptions",
--        "organizations_url": "https://api.github.com/users/jouni-kantola/orgs",
--        "repos_url": "https://api.github.com/users/jouni-kantola/repos",
--        "events_url": "https://api.github.com/users/jouni-kantola/events{/privacy}",
--        "received_events_url": "https://api.github.com/users/jouni-kantola/received_events",
--        "type": "User",
--        "site_admin": false
--      },
--      "labels": [
--        {
--          "id": 579257206,
--          "url": "https://api.github.com/repos/jouni-kantola/templated-assets-webpack-plugin/labels/bug",
--          "name": "bug",
--          "color": "ee0701",
--          "default": true
--        }
--      ],
--      "state": "open",
--      "locked": false,
--      "assignee": null,
--      "assignees": [],
--      "milestone": null,
--      "comments": 0,
--      "created_at": "2017-04-16T08:30:19Z",
--      "updated_at": "2017-04-16T08:31:24Z",
--      "closed_at": null,
--      "body": "The following error is displayed:\r\n`TypeError: Cannot read property 'test' of undefined`\r\n\r\n...with the following config:\r\n```javascript\r\nconst rules = [\r\n  {\r\n    name: \"inline-chunk\",\r\n    output: { inline: true }\r\n  },\r\n  {\r\n    name: \"url-chunk\",\r\n    output: { }\r\n  },\r\n  {\r\n    name: [\"defer-chunk-1\", \"defer-chunk-2\"],\r\n    output: { defer: true }\r\n  }\r\n  ].map(rule => {\r\n  rule.output.extension = \"lol\";\r\n  rule.output.prefix = \"__\";\r\n  rule.output.path = \"a/path\";\r\n  rule.output.emitAsset = false;\r\n  });\r\n```",
--      "score": 1
--    },
--  ]
--}
