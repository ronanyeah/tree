module Data exposing (..)

import Array
import GraphQL.Client.Http exposing (Error, customSendQuery, customSendMutation)
import GraphQL.Request.Builder as B
import GraphQL.Request.Builder.Arg as Arg
import Http
import Utils exposing (filterEmpty)
import Task exposing (Task)
import Types exposing (..)


query : String -> String -> B.Request B.Query a -> Task Error a
query url token =
    customSendQuery
        { method = "POST"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = url
        , timeout = Nothing
        , withCredentials = False
        }


mutate : String -> String -> B.Request B.Mutation a -> Task Error a
mutate url token =
    customSendMutation
        { method = "POST"
        , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
        , url = url
        , timeout = Nothing
        , withCredentials = False
        }


fetchData : B.Request B.Query AllData
fetchData =
    B.object AllData
        |> B.with (B.field "allTransitions" [] (B.list transition))
        |> B.with (B.field "allPositions" [] (B.list position))
        |> B.with (B.field "allSubmissions" [] (B.list submission))
        |> B.with (B.field "allTopics" [] (B.list topic))
        |> B.queryDocument
        |> B.request ()



-- CREATE


createPosition : Form -> B.Request B.Mutation Position
createPosition { name, notes } =
    position
        |> B.field "createPosition"
            [ ( "name", Arg.string name )
            , ( "notes", Arg.list <| List.map Arg.string <| filterEmpty <| Array.toList notes )
            ]
        |> B.extract
        |> B.mutationDocument
        |> B.request ()


createTopic : String -> List String -> B.Request B.Mutation Topic
createTopic name notes =
    topic
        |> B.field "createTopic"
            [ ( "name", Arg.string name )
            , ( "notes", Arg.list <| List.map Arg.string <| filterEmpty notes )
            ]
        |> B.extract
        |> B.mutationDocument
        |> B.request ()


createTransition : String -> List String -> List String -> Id -> Id -> B.Request B.Mutation Transition
createTransition name steps notes (Id startId) (Id endId) =
    transition
        |> B.field "createTransition"
            [ ( "name", Arg.string name )
            , ( "startPositionId", Arg.string startId )
            , ( "endPositionId", Arg.string endId )
            , ( "notes", Arg.list <| List.map Arg.string <| filterEmpty notes )
            , ( "steps", Arg.list <| List.map Arg.string <| filterEmpty steps )
            ]
        |> B.extract
        |> B.mutationDocument
        |> B.request ()


createSubmission : String -> List String -> List String -> Id -> B.Request B.Mutation Submission
createSubmission name steps notes (Id startId) =
    submission
        |> B.field "createSubmission"
            [ ( "name", Arg.string name )
            , ( "positionId", Arg.string startId )
            , ( "notes", Arg.list <| List.map Arg.string <| filterEmpty notes )
            , ( "steps", Arg.list <| List.map Arg.string <| filterEmpty steps )
            ]
        |> B.extract
        |> B.mutationDocument
        |> B.request ()



-- UPDATE


updateTransition : Transition -> B.Request B.Mutation Transition
updateTransition t =
    case ( t.id, t.startPosition, t.endPosition ) of
        ( Id id, Id startId, Id endId ) ->
            transition
                |> B.field "updateTransition"
                    [ ( "id", Arg.string id )
                    , ( "name", Arg.string t.name )
                    , ( "startPositionId", Arg.string startId )
                    , ( "endPositionId", Arg.string endId )
                    , ( "notes", Arg.list <| List.map Arg.string <| filterEmpty <| Array.toList t.notes )
                    , ( "steps", Arg.list <| List.map Arg.string <| filterEmpty <| Array.toList t.steps )
                    ]
                |> B.extract
                |> B.mutationDocument
                |> B.request ()


updatePosition : Position -> B.Request B.Mutation Position
updatePosition p =
    let
        (Id id) =
            p.id
    in
        position
            |> B.field "updatePosition"
                [ ( "id", Arg.string id )
                , ( "name", Arg.string p.name )
                , ( "notes", Arg.list <| List.map Arg.string <| filterEmpty <| Array.toList p.notes )
                ]
            |> B.extract
            |> B.mutationDocument
            |> B.request ()


updateTopic : Topic -> B.Request B.Mutation Topic
updateTopic { id, name, notes } =
    case id of
        Id idStr ->
            topic
                |> B.field "updateTopic"
                    [ ( "id", Arg.string idStr )
                    , ( "name", Arg.string name )
                    , ( "notes", Arg.list <| List.map Arg.string <| filterEmpty <| Array.toList notes )
                    ]
                |> B.extract
                |> B.mutationDocument
                |> B.request ()



-- SELECTIONS


topic : B.ValueSpec B.NonNull B.ObjectType Topic vars
topic =
    B.object Topic
        |> B.with (B.field "id" [] (B.map Id B.id))
        |> B.with (B.field "name" [] B.string)
        |> B.with (B.field "notes" [] (B.list B.string |> B.map Array.fromList))


position : B.ValueSpec B.NonNull B.ObjectType Position vars
position =
    B.object Position
        |> B.with (B.field "id" [] (B.id |> B.map Id))
        |> B.with (B.field "name" [] B.string)
        |> B.with (B.field "notes" [] (B.list B.string |> B.map Array.fromList))


submission : B.ValueSpec B.NonNull B.ObjectType Submission vars
submission =
    B.object Submission
        |> B.with (B.field "id" [] (B.map Id B.id))
        |> B.with (B.field "name" [] B.string)
        |> B.with (B.field "steps" [] (B.list B.string |> B.map Array.fromList))
        |> B.with (B.field "notes" [] (B.list B.string |> B.map Array.fromList))
        |> B.with
            (B.field "position"
                []
                (B.field "id" [] (B.map Id B.id) |> B.extract)
            )


transition : B.ValueSpec B.NonNull B.ObjectType Transition vars
transition =
    B.object Transition
        |> B.with (B.field "id" [] (B.map Id B.id))
        |> B.with (B.field "name" [] B.string)
        |> B.with
            (B.field "startPosition"
                []
                (B.field "id" [] (B.map Id B.id) |> B.extract)
            )
        |> B.with
            (B.field "endPosition"
                []
                (B.field "id" [] (B.map Id B.id) |> B.extract)
            )
        |> B.with (B.field "notes" [] (B.list B.string |> B.map Array.fromList))
        |> B.with (B.field "steps" [] (B.list B.string |> B.map Array.fromList))
