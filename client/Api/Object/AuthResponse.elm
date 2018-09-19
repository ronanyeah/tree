-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.Object.AuthResponse exposing (email, id, selection, token)

import Api.InputObject
import Api.Interface
import Api.Object
import Api.Scalar
import Api.Union
import Graphql.Field as Field exposing (Field)
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


{-| Select fields to build up a SelectionSet for this object.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) Api.Object.AuthResponse
selection constructor =
    Object.selection constructor


{-| -}
id : Field Api.Scalar.Id Api.Object.AuthResponse
id =
    Object.fieldDecoder "id" [] (Object.scalarDecoder |> Decode.map Api.Scalar.Id)


{-| -}
email : Field String Api.Object.AuthResponse
email =
    Object.fieldDecoder "email" [] Decode.string


{-| -}
token : Field String Api.Object.AuthResponse
token =
    Object.fieldDecoder "token" [] Decode.string
