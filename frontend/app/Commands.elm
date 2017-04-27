module Commands exposing (..)

import Http
import Models exposing (Issue, IssueSearchResult, Label)
import Json.Decode exposing (Decoder, int, string, list)
import Json.Decode.Pipeline exposing (decode, required)
import Messages exposing (Msg)
import RemoteData


fetchIssues : Cmd Msg
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
