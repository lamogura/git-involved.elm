module Commands exposing (..)

import Http
import Models exposing (Issue, IssueSearchResult, Label)
import Json.Decode exposing (Decoder, int, string, list)
import Json.Decode.Pipeline exposing (decode, required)
import Messages exposing (Message)
import RemoteData
import Date


fetchIssues : Cmd Message
fetchIssues =
    Http.get fetchIssuesUrl issueSearchResultDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Messages.OnFetchIssues


fetchIssuesUrl : String
fetchIssuesUrl =
    "http://localhost:4000/issues"


issueSearchResultDecoder : Decoder IssueSearchResult
issueSearchResultDecoder =
    decode IssueSearchResult
        |> required "total_count" int
        |> required "items" (list issueDecoder)


issueDecoder : Decoder Issue
issueDecoder =
    decode Issue
        |> required "title" string
        |> required "body" string
        |> required "comments" int
        |> required "repository_url" string
        |> required "labels" (list labelDecoder)
        |> required "id" int
        |> required "created_at" string
        |> required "updated_at" string



{- 2017-04-16T08:31:05Z -}


dateFrom : String -> String
dateFrom sqlFormatDate =
    case Date.fromString sqlFormatDate of
        Ok date ->
            toString (Date.month date) ++ " " ++ toString (Date.day date) ++ ", " ++ toString (Date.year date)

        Err msg ->
            "dateParseError"


repoNameFromUrl : String -> String
repoNameFromUrl url =
    let
        urlParamsList =
            url
                |> String.split "/"
                |> List.reverse
    in
        case urlParamsList of
            repoName :: repoOwner :: _ ->
                repoName ++ " by " ++ repoOwner

            _ :: [] ->
                "wrong repo url"

            [] ->
                "wrong repo url"


labelDecoder : Decoder Label
labelDecoder =
    decode Label
        |> required "name" string
        |> required "color" string
