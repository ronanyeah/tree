-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module Api.Interface.Node exposing (..)

import Api.InputObject
import Api.Interface
import Api.Object
import Api.Scalar
import Api.Union
import Graphqelm.Field as Field exposing (Field)
import Graphqelm.Internal.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Internal.Builder.Object as Object
import Graphqelm.Internal.Encode as Encode exposing (Value)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (FragmentSelectionSet(FragmentSelectionSet), SelectionSet(SelectionSet))
import Json.Decode as Decode


{-| Select only common fields from the interface.
-}
commonSelection : (a -> constructor) -> SelectionSet (a -> constructor) Api.Interface.Node
commonSelection constructor =
    Object.selection constructor


{-| Select both common and type-specific fields from the interface.
-}
selection : (Maybe typeSpecific -> a -> constructor) -> List (FragmentSelectionSet typeSpecific Api.Interface.Node) -> SelectionSet (a -> constructor) Api.Interface.Node
selection constructor typeSpecificDecoders =
    Object.interfaceSelection typeSpecificDecoders constructor


onUser : SelectionSet decodesTo Api.Object.User -> FragmentSelectionSet decodesTo Api.Interface.Node
onUser (SelectionSet fields decoder) =
    FragmentSelectionSet "User" fields decoder


onPosition : SelectionSet decodesTo Api.Object.Position -> FragmentSelectionSet decodesTo Api.Interface.Node
onPosition (SelectionSet fields decoder) =
    FragmentSelectionSet "Position" fields decoder


onSubmission : SelectionSet decodesTo Api.Object.Submission -> FragmentSelectionSet decodesTo Api.Interface.Node
onSubmission (SelectionSet fields decoder) =
    FragmentSelectionSet "Submission" fields decoder


onTag : SelectionSet decodesTo Api.Object.Tag -> FragmentSelectionSet decodesTo Api.Interface.Node
onTag (SelectionSet fields decoder) =
    FragmentSelectionSet "Tag" fields decoder


onTransition : SelectionSet decodesTo Api.Object.Transition -> FragmentSelectionSet decodesTo Api.Interface.Node
onTransition (SelectionSet fields decoder) =
    FragmentSelectionSet "Transition" fields decoder


onTopic : SelectionSet decodesTo Api.Object.Topic -> FragmentSelectionSet decodesTo Api.Interface.Node
onTopic (SelectionSet fields decoder) =
    FragmentSelectionSet "Topic" fields decoder


{-| -}
id : Field Api.Scalar.Id Api.Interface.Node
id =
    Object.fieldDecoder "id" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map Api.Scalar.Id)
