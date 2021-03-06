-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql
module Api.Mutation exposing (..)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Field as Field exposing (Field)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)
import Api.Object
import Api.Interface
import Api.Union
import Api.Scalar
import Api.InputObject
import Graphql.Internal.Builder.Object as Object
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Json.Decode as Decode exposing (Decoder)
import Graphql.Internal.Encode as Encode exposing (Value)



{-| Select fields to build up a top-level mutation. The request can be sent with
functions from `Graphql.Http`.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) RootMutation
selection constructor =
    Object.selection constructor
type alias AuthenticateUserRequiredArguments = { email : String, password : String }

{-| 

  - email - 
  - password - 

-}
authenticateUser : AuthenticateUserRequiredArguments -> SelectionSet decodesTo Api.Object.AuthResponse -> Field decodesTo RootMutation
authenticateUser requiredArgs object_ =
      Object.selectionField "authenticateUser" [ Argument.required "email" requiredArgs.email (Encode.string), Argument.required "password" requiredArgs.password (Encode.string) ] (object_) (identity)


type alias SignUpUserRequiredArguments = { email : String, password : String }

{-| 

  - email - 
  - password - 

-}
signUpUser : SignUpUserRequiredArguments -> SelectionSet decodesTo Api.Object.AuthResponse -> Field decodesTo RootMutation
signUpUser requiredArgs object_ =
      Object.selectionField "signUpUser" [ Argument.required "email" requiredArgs.email (Encode.string), Argument.required "password" requiredArgs.password (Encode.string) ] (object_) (identity)


type alias ChangePasswordRequiredArguments = { password : String }

{-| 

  - password - 

-}
changePassword : ChangePasswordRequiredArguments -> Field Bool RootMutation
changePassword requiredArgs =
      Object.fieldDecoder "changePassword" [ Argument.required "password" requiredArgs.password (Encode.string) ] (Decode.bool)


type alias CreatePositionRequiredArguments = { name : String, notes : (List String) }

{-| 

  - name - 
  - notes - 

-}
createPosition : CreatePositionRequiredArguments -> SelectionSet decodesTo Api.Object.Position -> Field decodesTo RootMutation
createPosition requiredArgs object_ =
      Object.selectionField "createPosition" [ Argument.required "name" requiredArgs.name (Encode.string), Argument.required "notes" requiredArgs.notes (Encode.string |> Encode.list) ] (object_) (identity)


type alias CreateTransitionRequiredArguments = { name : String, notes : (List String), steps : (List String), startPosition : Api.Scalar.Id, endPosition : Api.Scalar.Id, tags : (List Api.Scalar.Id) }

{-| 

  - name - 
  - notes - 
  - steps - 
  - startPosition - 
  - endPosition - 
  - tags - 

-}
createTransition : CreateTransitionRequiredArguments -> SelectionSet decodesTo Api.Object.Transition -> Field decodesTo RootMutation
createTransition requiredArgs object_ =
      Object.selectionField "createTransition" [ Argument.required "name" requiredArgs.name (Encode.string), Argument.required "notes" requiredArgs.notes (Encode.string |> Encode.list), Argument.required "steps" requiredArgs.steps (Encode.string |> Encode.list), Argument.required "startPosition" requiredArgs.startPosition ((\(Api.Scalar.Id raw) -> Encode.string raw)), Argument.required "endPosition" requiredArgs.endPosition ((\(Api.Scalar.Id raw) -> Encode.string raw)), Argument.required "tags" requiredArgs.tags ((\(Api.Scalar.Id raw) -> Encode.string raw) |> Encode.list) ] (object_) (identity)


type alias CreateSubmissionRequiredArguments = { name : String, notes : (List String), steps : (List String), tags : (List Api.Scalar.Id), position : Api.Scalar.Id }

{-| 

  - name - 
  - notes - 
  - steps - 
  - tags - 
  - position - 

-}
createSubmission : CreateSubmissionRequiredArguments -> SelectionSet decodesTo Api.Object.Submission -> Field decodesTo RootMutation
createSubmission requiredArgs object_ =
      Object.selectionField "createSubmission" [ Argument.required "name" requiredArgs.name (Encode.string), Argument.required "notes" requiredArgs.notes (Encode.string |> Encode.list), Argument.required "steps" requiredArgs.steps (Encode.string |> Encode.list), Argument.required "tags" requiredArgs.tags ((\(Api.Scalar.Id raw) -> Encode.string raw) |> Encode.list), Argument.required "position" requiredArgs.position ((\(Api.Scalar.Id raw) -> Encode.string raw)) ] (object_) (identity)


type alias CreateTagRequiredArguments = { name : String }

{-| 

  - name - 

-}
createTag : CreateTagRequiredArguments -> SelectionSet decodesTo Api.Object.Tag -> Field decodesTo RootMutation
createTag requiredArgs object_ =
      Object.selectionField "createTag" [ Argument.required "name" requiredArgs.name (Encode.string) ] (object_) (identity)


type alias CreateTopicRequiredArguments = { name : String, notes : (List String) }

{-| 

  - name - 
  - notes - 

-}
createTopic : CreateTopicRequiredArguments -> SelectionSet decodesTo Api.Object.Topic -> Field decodesTo RootMutation
createTopic requiredArgs object_ =
      Object.selectionField "createTopic" [ Argument.required "name" requiredArgs.name (Encode.string), Argument.required "notes" requiredArgs.notes (Encode.string |> Encode.list) ] (object_) (identity)


type alias UpdatePositionRequiredArguments = { id : Api.Scalar.Id, name : String, notes : (List String) }

{-| 

  - id - 
  - name - 
  - notes - 

-}
updatePosition : UpdatePositionRequiredArguments -> SelectionSet decodesTo Api.Object.Position -> Field decodesTo RootMutation
updatePosition requiredArgs object_ =
      Object.selectionField "updatePosition" [ Argument.required "id" requiredArgs.id ((\(Api.Scalar.Id raw) -> Encode.string raw)), Argument.required "name" requiredArgs.name (Encode.string), Argument.required "notes" requiredArgs.notes (Encode.string |> Encode.list) ] (object_) (identity)


type alias UpdateTransitionRequiredArguments = { id : Api.Scalar.Id, name : String, notes : (List String), steps : (List String), startPosition : Api.Scalar.Id, endPosition : Api.Scalar.Id, tags : (List Api.Scalar.Id) }

{-| 

  - id - 
  - name - 
  - notes - 
  - steps - 
  - startPosition - 
  - endPosition - 
  - tags - 

-}
updateTransition : UpdateTransitionRequiredArguments -> SelectionSet decodesTo Api.Object.Transition -> Field decodesTo RootMutation
updateTransition requiredArgs object_ =
      Object.selectionField "updateTransition" [ Argument.required "id" requiredArgs.id ((\(Api.Scalar.Id raw) -> Encode.string raw)), Argument.required "name" requiredArgs.name (Encode.string), Argument.required "notes" requiredArgs.notes (Encode.string |> Encode.list), Argument.required "steps" requiredArgs.steps (Encode.string |> Encode.list), Argument.required "startPosition" requiredArgs.startPosition ((\(Api.Scalar.Id raw) -> Encode.string raw)), Argument.required "endPosition" requiredArgs.endPosition ((\(Api.Scalar.Id raw) -> Encode.string raw)), Argument.required "tags" requiredArgs.tags ((\(Api.Scalar.Id raw) -> Encode.string raw) |> Encode.list) ] (object_) (identity)


type alias UpdateSubmissionRequiredArguments = { id : Api.Scalar.Id, name : String, notes : (List String), steps : (List String), tags : (List Api.Scalar.Id), position : Api.Scalar.Id }

{-| 

  - id - 
  - name - 
  - notes - 
  - steps - 
  - tags - 
  - position - 

-}
updateSubmission : UpdateSubmissionRequiredArguments -> SelectionSet decodesTo Api.Object.Submission -> Field decodesTo RootMutation
updateSubmission requiredArgs object_ =
      Object.selectionField "updateSubmission" [ Argument.required "id" requiredArgs.id ((\(Api.Scalar.Id raw) -> Encode.string raw)), Argument.required "name" requiredArgs.name (Encode.string), Argument.required "notes" requiredArgs.notes (Encode.string |> Encode.list), Argument.required "steps" requiredArgs.steps (Encode.string |> Encode.list), Argument.required "tags" requiredArgs.tags ((\(Api.Scalar.Id raw) -> Encode.string raw) |> Encode.list), Argument.required "position" requiredArgs.position ((\(Api.Scalar.Id raw) -> Encode.string raw)) ] (object_) (identity)


type alias UpdateTagRequiredArguments = { id : Api.Scalar.Id, name : String }

{-| 

  - id - 
  - name - 

-}
updateTag : UpdateTagRequiredArguments -> SelectionSet decodesTo Api.Object.Tag -> Field decodesTo RootMutation
updateTag requiredArgs object_ =
      Object.selectionField "updateTag" [ Argument.required "id" requiredArgs.id ((\(Api.Scalar.Id raw) -> Encode.string raw)), Argument.required "name" requiredArgs.name (Encode.string) ] (object_) (identity)


type alias UpdateTopicRequiredArguments = { id : Api.Scalar.Id, name : String, notes : (List String) }

{-| 

  - id - 
  - name - 
  - notes - 

-}
updateTopic : UpdateTopicRequiredArguments -> SelectionSet decodesTo Api.Object.Topic -> Field decodesTo RootMutation
updateTopic requiredArgs object_ =
      Object.selectionField "updateTopic" [ Argument.required "id" requiredArgs.id ((\(Api.Scalar.Id raw) -> Encode.string raw)), Argument.required "name" requiredArgs.name (Encode.string), Argument.required "notes" requiredArgs.notes (Encode.string |> Encode.list) ] (object_) (identity)


type alias DeletePositionRequiredArguments = { id : Api.Scalar.Id }

{-| 

  - id - 

-}
deletePosition : DeletePositionRequiredArguments -> Field Api.Scalar.Id RootMutation
deletePosition requiredArgs =
      Object.fieldDecoder "deletePosition" [ Argument.required "id" requiredArgs.id ((\(Api.Scalar.Id raw) -> Encode.string raw)) ] (Object.scalarDecoder |> Decode.map Api.Scalar.Id)


type alias DeleteTransitionRequiredArguments = { id : Api.Scalar.Id }

{-| 

  - id - 

-}
deleteTransition : DeleteTransitionRequiredArguments -> Field Api.Scalar.Id RootMutation
deleteTransition requiredArgs =
      Object.fieldDecoder "deleteTransition" [ Argument.required "id" requiredArgs.id ((\(Api.Scalar.Id raw) -> Encode.string raw)) ] (Object.scalarDecoder |> Decode.map Api.Scalar.Id)


type alias DeleteSubmissionRequiredArguments = { id : Api.Scalar.Id }

{-| 

  - id - 

-}
deleteSubmission : DeleteSubmissionRequiredArguments -> Field Api.Scalar.Id RootMutation
deleteSubmission requiredArgs =
      Object.fieldDecoder "deleteSubmission" [ Argument.required "id" requiredArgs.id ((\(Api.Scalar.Id raw) -> Encode.string raw)) ] (Object.scalarDecoder |> Decode.map Api.Scalar.Id)


type alias DeleteTagRequiredArguments = { id : Api.Scalar.Id }

{-| 

  - id - 

-}
deleteTag : DeleteTagRequiredArguments -> Field Api.Scalar.Id RootMutation
deleteTag requiredArgs =
      Object.fieldDecoder "deleteTag" [ Argument.required "id" requiredArgs.id ((\(Api.Scalar.Id raw) -> Encode.string raw)) ] (Object.scalarDecoder |> Decode.map Api.Scalar.Id)


type alias DeleteTopicRequiredArguments = { id : Api.Scalar.Id }

{-| 

  - id - 

-}
deleteTopic : DeleteTopicRequiredArguments -> Field Api.Scalar.Id RootMutation
deleteTopic requiredArgs =
      Object.fieldDecoder "deleteTopic" [ Argument.required "id" requiredArgs.id ((\(Api.Scalar.Id raw) -> Encode.string raw)) ] (Object.scalarDecoder |> Decode.map Api.Scalar.Id)
