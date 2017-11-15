module Types exposing (..)

import Array exposing (Array)
import Dict exposing (Dict)
import Editable exposing (Editable)
import GraphQL.Client.Http as GQLH
import Window


type Msg
    = Cancel
    | CancelPicker
    | CbData (Result GQLH.Error AllData)
    | CbPosition (Result GQLH.Error Position)
    | CbSubmission (Result GQLH.Error Submission)
    | CbTopic (Result GQLH.Error Topic)
    | CbTransition (Result GQLH.Error Transition)
    | ChoosePosition (Position -> Msg)
    | CreatePosition
    | CreateSubmission Position
    | CreateTopic
    | CreateTransition Position
    | EditPosition Position
    | EditTopic Topic
    | EditSubmission Submission
    | EditTransition Transition
    | FormUpdate Form
    | Save
    | SetRoute Route
    | WindowSize Window.Size


type View
    = ViewAll
    | ViewCreatePosition Form
    | ViewCreateSubmission Form
    | ViewCreateTopic Form
    | ViewCreateTransition Form
    | ViewPosition (Editable Position)
    | ViewSubmission (Editable Submission)
    | ViewTopics (Maybe Topic)
    | ViewTransition (Editable Transition)


type Styles
    = BigIcon
    | Body
    | Button
    | Choice
    | ChooseBox
    | Dot
    | Header
    | Icon
    | Line
    | Link
    | MattIcon
    | None
    | Picker
    | PickerCancel
    | SetBox
    | Subtitle
    | Title
    | Topics


type Id
    = Id String


type alias Model =
    { view : View
    , positions : Dict String Position
    , transitions : Dict String Transition
    , submissions : Dict String Submission
    , topics : Dict String Topic
    , url : String
    , choosingPosition : Maybe (Position -> Msg)
    , device : Device
    }


type Device
    = Desktop
    | Mobile


type Route
    = Ps
    | P Id
    | Ts
    | S Id
    | T Id
    | NotFoundRoute


type alias Topic =
    { id : Id
    , name : String
    , notes : Array String
    }


type alias Position =
    { id : Id
    , name : String
    , notes : Array String
    }


type alias Submission =
    { id : Id
    , name : String
    , steps : Array String
    , notes : Array String
    , position : Id
    }


type alias Form =
    { name : String
    , startPosition : Maybe Position
    , endPosition : Maybe Position
    , notes : Array String
    , steps : Array String
    }


type alias Transition =
    { id : Id
    , name : String
    , startPosition : Id
    , endPosition : Id
    , notes : Array String
    , steps : Array String
    }


type alias AllData =
    { transitions : List Transition
    , positions : List Position
    , submissions : List Submission
    , topics : List Topic
    }
