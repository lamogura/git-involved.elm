module Update exposing (update)

import Models exposing (Model)
import Messages exposing (Message(..))
import Routing exposing (parseLocation)
import Material
import AutocompleteLang


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        Rtg routingMessage ->
            { model | route = Tuple.first <| Routing.update routingMessage model.route } ! []

        OnFetchIssues response ->
            { model | issuesSearchResult = response } ! []

        SetOrderIssuesBy orderBy ->
            { model | orderIssuesBy = orderBy } ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model

        Acl autoMsg ->
            { model | autocompleteLang = Tuple.first <| AutocompleteLang.update autoMsg model.autocompleteLang } ! []
