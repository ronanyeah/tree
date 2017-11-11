module View exposing (..)

import Array exposing (Array)
import Dict
import Editable
import Element exposing (Element, column, el, empty, header, layout, modal, paragraph, row, text, when, whenJust)
import Element.Attributes exposing (center, class, fill, height, maxWidth, padding, px, spacing, verticalCenter, width)
import Element.Events exposing (onClick)
import Element.Input as Input
import Html exposing (Html)
import Styling exposing (styling)
import Types exposing (..)
import Utils exposing (get, unwrap, unwrap2)


view : Model -> Html Msg
view model =
    let
        content =
            case model.view of
                ViewAll ->
                    (case
                        model.positions
                            |> Dict.values
                     of
                        [] ->
                            []

                        xs ->
                            xs
                                |> List.map
                                    (\p ->
                                        el Button
                                            [ padding 10
                                            , onClick <| SelectPosition p
                                            ]
                                        <|
                                            text p.name
                                    )
                                |> flip (++)
                                    [ plus CreatePosition
                                    , el Line [ width <| px 100, height <| px 2 ] empty
                                    ]
                    )
                        ++ [ el Topics
                                [ padding 10
                                , onClick <| SelectTopics
                                , class "fa fa-book"
                                ]
                                empty
                           ]

                ViewCreateTopic form ->
                    [ el Title [ center ] <| text "CREATE TOPIC"
                    , nameEdit form FormUpdate
                    , notesEditor form FormUpdate
                    , saveCancel
                    ]

                ViewCreateTransition form ->
                    [ nameEdit form FormUpdate
                    , pickStartPosition form
                    , pickEndPosition form
                    , stepsEditor form FormUpdate
                    , notesEditor form FormUpdate
                    , saveCancel
                    ]

                ViewCreateSubmission form ->
                    [ nameEdit form FormUpdate
                    , pickStartPosition form
                    , stepsEditor form FormUpdate
                    , notesEditor form FormUpdate
                    , saveCancel
                    ]

                ViewCreatePosition form ->
                    [ nameEdit form FormUpdate
                    , stepsEditor form FormUpdate
                    , notesEditor form FormUpdate
                    , saveCancel
                    ]

                ViewPosition data ->
                    case data of
                        Editable.Editable _ position ->
                            [ nameEdit position EditPosition
                            , notesEditor position EditPosition
                            , saveCancel
                            ]

                        Editable.ReadOnly ({ id, notes } as p) ->
                            let
                                transitions =
                                    model.transitions
                                        |> Dict.values
                                        |> List.filter (.startPosition >> (==) id)

                                submissions =
                                    model.submissions
                                        |> Dict.values
                                        |> List.filter (.position >> (==) id)
                            in
                                [ editRow p EditPosition
                                , viewNotes notes
                                , el None [] <| text "Transitions"
                                , viewTechList SelectTransition transitions
                                , plus <| CreateTransition p
                                , el None [] <| text "Submissions"
                                , viewTechList SelectSubmission submissions
                                , plus <| CreateSubmission p
                                ]

                ViewSubmission data ->
                    case data of
                        Editable.ReadOnly ({ name, steps, position, notes } as s) ->
                            get position model.positions
                                |> unwrap oopsView
                                    (\p ->
                                        [ editRow s EditSubmission
                                        , row None
                                            []
                                            [ text (name ++ " from ")
                                            , el Link [ onClick <| SelectPosition p ] <| text p.name
                                            ]
                                        , viewSteps steps
                                        , viewNotes notes
                                        ]
                                    )

                        Editable.Editable _ submission ->
                            [ nameEdit submission EditSubmission
                            , model.positions
                                |> Dict.get (submission.position |> (\(Id id) -> id))
                                |> flip whenJust
                                    (\p ->
                                        el None
                                            [ onClick <|
                                                ChoosePosition
                                                    (\{ id } ->
                                                        EditSubmission { submission | position = id }
                                                    )
                                            ]
                                        <|
                                            text <|
                                                "Start Position: "
                                                    ++ p.name
                                    )
                            , notesEditor submission EditSubmission
                            , stepsEditor submission EditSubmission
                            , saveCancel
                            ]

                ViewTransition data ->
                    case data of
                        Editable.Editable _ transition ->
                            [ nameEdit transition EditTransition
                            , model.positions
                                |> Dict.get (transition.startPosition |> (\(Id id) -> id))
                                |> flip whenJust
                                    (\p ->
                                        el None
                                            [ onClick <|
                                                ChoosePosition
                                                    (\{ id } ->
                                                        EditTransition { transition | startPosition = id }
                                                    )
                                            ]
                                        <|
                                            text <|
                                                "Start Position: "
                                                    ++ p.name
                                    )
                            , model.positions
                                |> Dict.get (transition.endPosition |> (\(Id id) -> id))
                                |> flip whenJust
                                    (\p ->
                                        el None
                                            [ onClick <|
                                                ChoosePosition
                                                    (\{ id } ->
                                                        EditTransition { transition | endPosition = id }
                                                    )
                                            ]
                                        <|
                                            text <|
                                                "End Position: "
                                                    ++ p.name
                                    )
                            , notesEditor transition EditTransition
                            , stepsEditor transition EditTransition
                            , saveCancel
                            ]

                        Editable.ReadOnly ({ name, steps, startPosition, endPosition, notes } as t) ->
                            unwrap2 oopsView
                                (get startPosition model.positions)
                                (get endPosition model.positions)
                                (\start end ->
                                    [ editRow t EditTransition
                                    , row None
                                        [ verticalCenter ]
                                        [ el Link [ onClick <| SelectPosition start ] <| text start.name
                                        , el Icon
                                            [ padding 10
                                            , class "fa fa-long-arrow-right"
                                            ]
                                            empty
                                        , el Link [ onClick <| SelectPosition end ] <|
                                            text end.name
                                        ]
                                    , viewSteps steps
                                    , viewNotes notes
                                    ]
                                )

                ViewTopics maybeEdit ->
                    model.topics
                        |> Dict.values
                        |> List.indexedMap
                            (\i ({ id, name, notes } as topic) ->
                                case
                                    maybeEdit
                                        |> Maybe.andThen
                                            (\e ->
                                                if e.id == id then
                                                    Just e
                                                else
                                                    Nothing
                                            )
                                of
                                    Just edit ->
                                        column None
                                            [ center, maxWidth <| px 500 ]
                                            [ nameEdit edit EditTopic
                                            , notesEditor edit EditTopic
                                            , saveCancel
                                            ]

                                    Nothing ->
                                        column None
                                            [ center, maxWidth <| px 500 ]
                                            [ editRow topic EditTopic
                                            , viewNotes notes
                                            ]
                            )
                        |> (::) (plus CreateTopic)

        roteiro =
            header None [] <| el Header [ center, onClick Reset ] <| text "ROTEIRO"

        picker =
            case model.choosingPosition of
                Just msg ->
                    modal Picker [ center, verticalCenter ] <|
                        column None [] <|
                            List.map
                                (\p ->
                                    el None [ onClick <| msg p ] <| text p.name
                                )
                            <|
                                Dict.values model.positions

                Nothing ->
                    empty
    in
        Html.div []
            [ Html.node "style"
                []
                [ Html.text """
                    body { background-color: #B63730; }
                    .style-elements .fa { font-family: FontAwesome; }
                  """
                ]
            , layout styling <|
                column Body
                    [ height fill
                    , center
                    , width fill
                    , spacing 30
                    , padding 30
                    ]
                    (picker :: roteiro :: content)
            ]


pickStartPosition : Form -> Element Styles vs Msg
pickStartPosition form =
    case form.startPosition of
        Nothing ->
            el None [ onClick <| ChoosePosition <| \p -> FormUpdate { form | startPosition = Just p } ] <| text "Select A Position"

        Just { name } ->
            el None [ onClick <| ChoosePosition <| \p -> FormUpdate { form | startPosition = Just p } ] <| text <| "Start Position: " ++ name


pickEndPosition : Form -> Element Styles vs Msg
pickEndPosition form =
    case form.endPosition of
        Nothing ->
            el None [ onClick <| ChoosePosition <| \p -> FormUpdate { form | endPosition = Just p } ] <| text "Select A Position"

        Just endP ->
            el None [ onClick <| ChoosePosition <| \p -> FormUpdate { form | endPosition = Just p } ] <| text <| "End Position: " ++ endP.name


editRow : { r | name : String } -> ({ r | name : String } -> msg) -> Element Styles vs msg
editRow r msg =
    row None
        [ spacing 50, verticalCenter ]
        [ el Subtitle [] <| text r.name
        , el Icon
            [ padding 10
            , class "fa fa-edit"
            , onClick <| msg r
            ]
            empty
        ]


nameEdit : { r | name : String } -> ({ r | name : String } -> Msg) -> Element Styles vs Msg
nameEdit r msg =
    Input.text
        None
        [ maxWidth <| px 300, center ]
        { onChange = \str -> msg { r | name = str }
        , value = r.name
        , label = Input.labelAbove <| el Title [ center ] <| text "NAME"
        , options = []
        }


plus : msg -> Element Styles vs msg
plus msg =
    el Icon
        [ padding 10
        , onClick msg
        , class "fa fa-plus"
        ]
        empty


minus : msg -> Element Styles vs msg
minus msg =
    el Icon
        [ padding 10
        , onClick msg
        , class "fa fa-minus"
        ]
        empty


saveCancel : Element Styles vs Msg
saveCancel =
    row None
        []
        [ el Icon
            [ padding 10
            , onClick Save
            , class "fa fa-check"
            ]
            empty
        , el Icon
            [ padding 10
            , onClick Cancel
            , class "fa fa-times"
            ]
            empty
        ]


stepsEditor : { r | steps : Array String } -> ({ r | steps : Array String } -> Msg) -> Element Styles vs Msg
stepsEditor form msg =
    let
        steps =
            column None
                [ spacing 10 ]
                (form.steps
                    |> Array.indexedMap
                        (\i v ->
                            Input.multiline
                                None
                                []
                                { onChange = \str -> msg { form | steps = Array.set i str form.steps }
                                , value = v
                                , label = Input.hiddenLabel ""
                                , options = []
                                }
                        )
                    |> Array.toList
                )

        buttons =
            row None
                [ center ]
                [ plus (msg { form | steps = Array.push "" form.steps })
                , when (not <| Array.isEmpty form.steps) <|
                    minus (msg { form | steps = Array.slice 0 -1 form.steps })
                ]
    in
        column None
            []
            [ el Icon [ class "fa fa-cogs", center ] empty
            , steps
            , buttons
            ]


notesEditor : { r | notes : Array String } -> ({ r | notes : Array String } -> Msg) -> Element Styles vs Msg
notesEditor form msg =
    let
        notes =
            column None
                [ spacing 10 ]
                (form.notes
                    |> Array.indexedMap
                        (\i v ->
                            Input.multiline
                                None
                                []
                                { onChange = \str -> msg { form | notes = Array.set i str form.notes }
                                , value = v
                                , label = Input.hiddenLabel ""
                                , options = []
                                }
                        )
                    |> Array.toList
                )

        buttons =
            row None
                [ center ]
                [ plus (msg { form | notes = Array.push "" form.notes })
                , when (not <| Array.isEmpty form.notes) <|
                    minus (msg { form | notes = Array.slice 0 -1 form.notes })
                ]
    in
        column None
            []
            [ el Icon [ class "fa fa-sticky-note-o" ] empty
            , notes
            , buttons
            ]


oopsView : List (Element Styles vs Msg)
oopsView =
    [ text "oops!" ]


viewSteps : Array String -> Element Styles vs Msg
viewSteps steps =
    when (not (Array.isEmpty steps)) <|
        (steps
            |> Array.toList
            |> List.indexedMap
                (\i step ->
                    paragraph None
                        []
                        [ Element.bold <| (toString (i + 1) ++ ".")
                        , text <| " " ++ step
                        ]
                )
            |> column None [ maxWidth <| px 700 ]
        )


viewNotes : Array String -> Element Styles vs msg
viewNotes =
    Array.toList
        >> List.map
            (\x ->
                paragraph None [] [ el Dot [] <| text "• ", text x ]
            )
        >> column None [ center, maxWidth <| px 500 ]


viewTechList : ({ r | name : String } -> Msg) -> List { r | name : String } -> Element Styles vs Msg
viewTechList msg =
    List.map
        (\t ->
            row None
                []
                [ el Dot [] <| text "• "
                , el Link [ onClick <| msg t ] <| text t.name
                ]
        )
        >> column None []