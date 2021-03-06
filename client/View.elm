module View exposing (actionIcon, addNewRow, ballIcon, block, blocks, createButtons, createHeader, domain, editButtons, editHeader, editRow, editTags, icons, links, minus, nameEdit, notesEditor, pickPosition, plus, sidebar, spinner, stepsEditor, transitionPositions, view, viewApp, viewErrors, viewNotes, viewPickPosition, viewRemote, viewSteps, viewSubmissionPicker, viewTags, viewTechList, viewTransitionPickers, viewTransitionPositions, viewTransitions)

import Api.Scalar exposing (Id(..))
import Array exposing (Array)
import Browser exposing (Document)
import Dict
import Element exposing (Attribute, Element, alignRight, behindContent, centerX, centerY, column, el, fill, fillPortion, focused, height, htmlAttribute, image, inFront, layoutWith, maximum, mouseOver, newTabLink, noHover, none, padding, paragraph, px, row, scrollbarY, shrink, spaceEvenly, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input exposing (button)
import Html exposing (Html)
import Html.Attributes
import Keydown exposing (onEnter, onKeydown)
import List.Nonempty as Ne
import Regex
import RemoteData exposing (RemoteData(..))
import Style
import Types exposing (..)
import Utils exposing (formatHttpError, icon, isJust, isPositionView, isSubmissionView, isTagView, isTopicView, isTransitionView, matchDomain, matchLink, noLabel, when, whenJust)


view : Model -> Document Msg
view model =
    let
        content =
            case model.view of
                ViewApp appView ->
                    if model.device == Desktop then
                        row
                            [ width fill
                            , height fill
                            ]
                            [ links appView
                            , el
                                [ width <| px <| round <| toFloat model.size.width * 0.8
                                , height <| px model.size.height
                                , scrollbarY
                                ]
                              <|
                                viewApp model appView
                            ]

                    else
                        viewApp model appView

                ViewLogin ->
                    let
                        inputWidth =
                            if model.device == Desktop then
                                px <| model.size.width // 3

                            else
                                fill
                    in
                    el [ centerY, width fill, padding 20 ] <|
                        column
                            [ centerX
                            , spacing 20
                            , Background.color Style.c
                            , width fill
                            , height fill
                            ]
                            [ el
                                [ height <| px 100
                                , width <| px 100
                                , centerX
                                ]
                                Utils.map
                            , el
                                [ Font.size 45, Font.color Style.e, centerX ]
                              <|
                                text "ROTEIRO"
                            , row
                                [ width shrink
                                , centerX
                                , spacing 10
                                , Font.color Style.e
                                ]
                                [ icon SignIn Style.mattIcon, text "Login" ]
                            , viewErrors model.form.status
                            , Input.email
                                ([ centerX
                                 , width inputWidth
                                 ]
                                    ++ Style.field
                                )
                                { onChange = UpdateEmail
                                , text = model.form.email
                                , label =
                                    Input.labelLeft [] <|
                                        icon Email Style.bigIcon
                                , placeholder = Just <| Input.placeholder [] <| el [ centerY ] <| text "email address"
                                }
                            , Input.currentPassword
                                ([ centerX
                                 , width inputWidth
                                 ]
                                    ++ Style.field
                                )
                                { onChange = UpdatePassword
                                , text = model.form.password
                                , label =
                                    Input.labelLeft [] <|
                                        icon Lock Style.bigIcon
                                , placeholder = Just <| Input.placeholder [] <| el [ centerY ] <| text "password"
                                , show = False
                                }
                            , el [ centerX ] <|
                                if model.form.status == Waiting then
                                    spinner

                                else
                                    actionIcon Arrow (Just <| LoginSubmit)
                            , button [ centerX, Font.underline ]
                                { onPress = Just <| NavigateTo SignUp
                                , label = text "Need to sign up?"
                                }
                            ]

                ViewSignUp ->
                    let
                        inputWidth =
                            if model.device == Desktop then
                                px <| model.size.width // 3

                            else
                                fill
                    in
                    el [ centerY, width fill, padding 20 ] <|
                        column
                            [ centerX
                            , spacing 20
                            , Background.color Style.c
                            , width fill
                            , height fill
                            ]
                            [ el
                                [ height <| px 100
                                , width <| px 100
                                , centerX
                                ]
                                Utils.map
                            , el
                                [ Font.size 45, Font.color Style.e, centerX ]
                              <|
                                text "ROTEIRO"
                            , row
                                [ width shrink
                                , centerX
                                , spacing 10
                                , Font.color Style.e
                                ]
                                [ icon NewUser Style.mattIcon, text "Sign Up" ]
                            , viewErrors model.form.status
                            , Input.email
                                ([ centerX, width inputWidth ] ++ Style.field)
                                { onChange = UpdateEmail
                                , text = model.form.email
                                , label =
                                    Input.labelLeft [] <|
                                        icon Email Style.bigIcon
                                , placeholder = Just <| Input.placeholder [] <| el [ centerY ] <| text "email address"
                                }
                            , Input.currentPassword
                                ([ centerX, width inputWidth ] ++ Style.field)
                                { onChange = UpdatePassword
                                , text = model.form.password
                                , label =
                                    Input.labelLeft [] <|
                                        icon Lock Style.bigIcon
                                , placeholder = Just <| Input.placeholder [] <| el [ centerY ] <| text "password"
                                , show = False
                                }
                            , el [ centerX ] <|
                                if model.form.status == Waiting then
                                    spinner

                                else
                                    actionIcon Arrow (Just <| SignUpSubmit)
                            , button [ centerX, Font.underline ]
                                { onPress = Just <| NavigateTo Login
                                , label = text "Need to log in?"
                                }
                            ]

        confirm =
            model.confirm
                |> whenJust
                    (\msg ->
                        el
                            [ centerX
                            , centerY
                            , padding 10
                            , spacing 20
                            , Background.color Style.c
                            , Border.rounded 5
                            , Border.color Style.e
                            , Border.width 2
                            , Border.solid
                            ]
                        <|
                            column
                                []
                                [ icon Question (centerX :: Style.bigIcon)
                                , row
                                    [ spacing 40 ]
                                    [ actionIcon Tick (Just msg)
                                    , actionIcon Cross (Just <| Confirm Nothing)
                                    ]
                                ]
                    )

        modal =
            if isJust model.confirm then
                confirm
                    |> inFront

            else if model.selectingEndPosition then
                viewPickPosition UpdateEndPosition model.positions
                    |> inFront

            else if model.selectingStartPosition then
                viewPickPosition UpdateStartPosition model.positions
                    |> inFront

            else if model.device == Mobile then
                case model.view of
                    ViewApp appView ->
                        sidebar model.sidebarOpen appView

                    _ ->
                        behindContent none

            else
                behindContent none
    in
    { title = "ROTEIRO"
    , body =
        [ layoutWith
            { options =
                [ Element.focusStyle
                    { borderColor = Nothing
                    , backgroundColor = Nothing
                    , shadow = Nothing
                    }
                ]
                    |> (if model.device == Mobile then
                            (::) noHover

                        else
                            identity
                       )
            }
            [ Background.color Style.c
            , Style.font
            , modal
            ]
            content
        ]
    }


viewApp : Model -> AppView -> Element Msg
viewApp model appView =
    let
        col =
            column
                [ shrink |> maximum model.size.height |> height
                , scrollbarY
                , spacing 50
                , padding 20
                ]

        waiting =
            model.form.status == Waiting
    in
    case appView of
        ViewStart ->
            el [ centerY, centerX ] <|
                column [ spacing 20 ]
                    [ el
                        [ height <| px 100
                        , width <| px 100
                        , centerX
                        ]
                        Utils.map
                    , el
                        [ Font.size 45, Font.color Style.e, centerX ]
                      <|
                        text "ROTEIRO"
                    ]

        ViewCreatePosition ->
            col
                [ createHeader Flag
                , viewErrors model.form.status
                , nameEdit model.form
                , notesEditor model.form
                , createButtons waiting SaveCreatePosition
                ]

        ViewCreateSubmission ->
            col
                [ createHeader Bolt
                , viewErrors model.form.status
                , nameEdit model.form
                , viewSubmissionPicker model.form
                , stepsEditor model.form
                , notesEditor model.form
                , createButtons waiting SaveCreateSubmission
                ]

        ViewCreateTag ->
            col
                [ createHeader Tags
                , viewErrors model.form.status
                , nameEdit model.form
                , createButtons waiting SaveCreateTag
                ]

        ViewCreateTopic ->
            col
                [ createHeader Book
                , viewErrors model.form.status
                , nameEdit model.form
                , notesEditor model.form
                , createButtons waiting SaveCreateTopic
                ]

        ViewCreateTransition ->
            col
                [ createHeader Arrow
                , viewErrors model.form.status
                , nameEdit model.form
                , viewTransitionPickers model.form
                , stepsEditor model.form
                , notesEditor model.form
                , createButtons waiting SaveCreateTransition
                ]

        ViewEditPosition _ ->
            col
                [ editHeader Flag
                , viewErrors model.form.status
                , nameEdit model.form
                , notesEditor model.form
                , editButtons waiting SaveEditPosition <| DeletePosition model.form.id
                ]

        ViewEditSubmission _ ->
            col
                [ editHeader Bolt
                , viewErrors model.form.status
                , nameEdit model.form
                , viewSubmissionPicker model.form
                , stepsEditor model.form
                , notesEditor model.form
                , editTags model.tags <| Array.toList model.form.tags
                , editButtons waiting SaveEditSubmission <| DeleteSubmission model.form.id
                ]

        ViewEditTag _ ->
            col
                [ editHeader Tags
                , viewErrors model.form.status
                , nameEdit model.form
                , editButtons waiting SaveEditTag <| DeleteTag model.form.id
                ]

        ViewEditTopic _ ->
            col
                [ editHeader Book
                , viewErrors model.form.status
                , nameEdit model.form
                , notesEditor model.form
                , editButtons waiting SaveEditTopic <| DeleteTopic model.form.id
                ]

        ViewEditTransition _ ->
            col
                [ editHeader Arrow
                , viewErrors model.form.status
                , nameEdit model.form
                , viewTransitionPickers model.form
                , stepsEditor model.form
                , notesEditor model.form
                , editTags model.tags <| Array.toList model.form.tags
                , editButtons waiting SaveEditTransition <| DeleteTransition model.form.id
                ]

        ViewPosition ->
            model.position
                |> viewRemote
                    (\({ name, notes, submissions, transitionsFrom, transitionsTo, id } as position) ->
                        col
                            [ editRow name Flag <| NavigateTo <| EditPositionRoute position.id
                            , viewNotes notes
                            , column
                                [ centerX
                                , Border.rounded 5
                                , Border.width 2
                                , Border.color Style.e
                                , Border.solid
                                , width shrink
                                , padding 30
                                , spacing 10
                                , height shrink
                                ]
                                [ addNewRow Bolt
                                    (SetRouteThenNavigate
                                        (PositionRoute id)
                                        CreateSubmissionRoute
                                    )
                                , viewTechList SubmissionRoute submissions
                                ]
                            , column
                                [ centerX
                                , Border.rounded 5
                                , Border.width 2
                                , Border.color Style.e
                                , Border.solid
                                , width shrink
                                , padding 30
                                , spacing 10
                                , height shrink
                                ]
                                [ addNewRow Arrow
                                    (SetRouteThenNavigate
                                        (PositionRoute id)
                                        CreateTransitionRoute
                                    )
                                , if
                                    List.isEmpty transitionsFrom
                                        && List.isEmpty transitionsTo
                                  then
                                    none

                                  else
                                    column [ spacing 10 ]
                                        [ column [ spacing 10 ]
                                            (transitionsFrom
                                                |> List.map
                                                    (viewTransitionPositions True False True)
                                            )
                                        , column [ spacing 10 ]
                                            (transitionsTo
                                                |> List.map
                                                    (viewTransitionPositions True True False)
                                            )
                                        ]
                                ]
                            ]
                    )

        ViewPositions ->
            model.positions
                |> viewRemote
                    (\positions ->
                        col
                            [ addNewRow Flag <| NavigateTo CreatePositionRoute
                            , blocks PositionRoute positions
                            ]
                    )

        ViewSettings ->
            let
                style =
                    onKeydown [ onEnter ChangePasswordSubmit ] :: Style.field
            in
            column [ padding 20 ]
                [ el [ centerX ] <| icon Cogs Style.mattIcon
                , el [] <| text "Change Password:"
                , viewErrors model.form.status
                , Input.newPassword style
                    { onChange = UpdatePassword
                    , text = model.form.password
                    , label = Input.labelLeft [] none
                    , placeholder = Nothing
                    , show = False
                    }
                , Input.newPassword style
                    { onChange = UpdateConfirmPassword
                    , text = model.form.confirmPassword
                    , label = Input.labelLeft [] none
                    , placeholder = Nothing
                    , show = False
                    }
                , actionIcon SignIn (Just ChangePasswordSubmit)
                ]

        ViewSubmission data ->
            data
                |> viewRemote
                    (\sub ->
                        col
                            [ editRow sub.name Bolt <| NavigateTo <| EditSubmissionRoute sub.id
                            , row
                                [ spacing 10 ]
                                [ icon Flag Style.mattIcon
                                , button []
                                    { onPress = Just <| NavigateTo <| PositionRoute sub.position.id
                                    , label =
                                        el Style.link <|
                                            text sub.position.name
                                    }
                                ]
                            , viewSteps sub.steps
                            , viewNotes sub.notes
                            , viewTags sub.tags
                            ]
                    )

        ViewSubmissions ->
            model.submissions
                |> viewRemote
                    (\submissions ->
                        col
                            [ addNewRow Bolt <|
                                NavigateTo
                                    CreateSubmissionRoute
                            , submissions
                                |> List.foldl
                                    (\sub acc ->
                                        case sub.position.id of
                                            Id id ->
                                                acc
                                                    |> Dict.update
                                                        ( id, sub.position.name )
                                                        (\subs ->
                                                            case subs of
                                                                Just ss ->
                                                                    Just <| sub :: ss

                                                                Nothing ->
                                                                    Just [ sub ]
                                                        )
                                    )
                                    Dict.empty
                                |> Dict.toList
                                |> List.map
                                    (\( ( positionId, positionName ), subs ) ->
                                        column
                                            [ width shrink, centerX ]
                                            [ button [ centerX ]
                                                { onPress =
                                                    Just <|
                                                        NavigateTo <|
                                                            PositionRoute <|
                                                                Id positionId
                                                , label =
                                                    paragraph Style.choice
                                                        [ text positionName ]
                                                }
                                            , blocks SubmissionRoute subs
                                            ]
                                    )
                                |> column [ spacing 20 ]
                            ]
                    )

        ViewTag data ->
            data
                |> viewRemote
                    (\t ->
                        col
                            [ editRow t.name Tags <| NavigateTo <| EditTagRoute t.id
                            , column [ height shrink, width shrink, centerX, spacing 10 ]
                                [ el [ centerX ] <| icon Bolt Style.mattIcon
                                , viewTechList SubmissionRoute t.submissions
                                ]
                            , column [ height shrink, width shrink, centerX, spacing 10 ]
                                [ el [ centerX ] <| icon Arrow Style.mattIcon
                                , viewTechList TransitionRoute t.transitions
                                ]
                            ]
                    )

        ViewTags ->
            model.tags
                |> viewRemote
                    (\tags ->
                        col
                            [ addNewRow Tags <| NavigateTo CreateTagRoute
                            , blocks TagRoute tags
                            ]
                    )

        ViewTopic data ->
            data
                |> viewRemote
                    (\t ->
                        col
                            [ editRow t.name Book <| NavigateTo <| EditTopicRoute t.id
                            , viewNotes t.notes
                            ]
                    )

        ViewTopics ->
            model.topics
                |> viewRemote
                    (\topics ->
                        col
                            [ addNewRow Book <| NavigateTo CreateTopicRoute
                            , blocks TopicRoute topics
                            ]
                    )

        ViewTransition data ->
            data
                |> viewRemote
                    (\t ->
                        col
                            [ editRow t.name Arrow <| NavigateTo <| EditTransitionRoute t.id
                            , viewTransitionPositions False True True t
                            , viewSteps t.steps
                            , viewNotes t.notes
                            , viewTags t.tags
                            ]
                    )

        ViewTransitions ->
            model.transitions
                |> viewRemote
                    (\transitions ->
                        col
                            [ addNewRow Arrow <|
                                NavigateTo
                                    CreateTransitionRoute
                            , transitions
                                |> List.foldl
                                    (\tr acc ->
                                        case tr.startPosition.id of
                                            Id id ->
                                                acc
                                                    |> Dict.update
                                                        ( id, tr.startPosition.name )
                                                        (\trs ->
                                                            case trs of
                                                                Just ts ->
                                                                    Just <| tr :: ts

                                                                Nothing ->
                                                                    Just [ tr ]
                                                        )
                                    )
                                    Dict.empty
                                |> Dict.toList
                                |> List.map
                                    (\( ( startPositionId, startPositionName ), trs ) ->
                                        column
                                            [ width shrink, centerX ]
                                            [ button [ centerX ]
                                                { onPress =
                                                    Just <|
                                                        NavigateTo <|
                                                            PositionRoute <|
                                                                Id startPositionId
                                                , label =
                                                    paragraph Style.choice
                                                        [ text startPositionName ]
                                                }
                                            , blocks TransitionRoute trs
                                            ]
                                    )
                                |> column [ spacing 20 ]
                            ]
                    )


createHeader : Icon -> Element msg
createHeader fa =
    el [ centerX ] <|
        row [ spacing 20, padding 20 ]
            [ icon fa Style.mattIcon
            , icon Plus Style.mattIcon
            ]


editHeader : Icon -> Element msg
editHeader fa =
    el [ centerX ] <|
        row [ spacing 20, padding 20 ]
            [ icon fa Style.mattIcon
            , icon Write Style.mattIcon
            ]


ballIcon : List (Attribute msg)
ballIcon =
    [ Font.color Style.c
    , Font.size 35
    , Background.color Style.e
    , Border.rounded 30
    , width <| px 60
    , height <| px 60
    , mouseOver
        [ Font.color Style.a
        ]
    , focused
        [ Border.glow Style.a 0
        ]
    ]


links : AppView -> Element Msg
links =
    icons NavigateTo
        >> column
            [ padding 20
            , spacing 20
            ]
        >> el [ centerX, centerY ]


sidebar : Bool -> AppView -> Attribute Msg
sidebar isOpen v =
    if isOpen then
        row [ height fill, width fill ]
            [ button [ width <| fillPortion 1, height fill ]
                { onPress = Just ToggleSidebar
                , label = none
                }
            , column
                [ height fill
                , alignRight
                , width <| fillPortion 1
                , Background.color Style.c
                , Border.solid
                , Border.widthEach { bottom = 0, left = 5, right = 0, top = 0 }
                , Border.color Style.e
                , spaceEvenly
                ]
              <|
                (icons SidebarNavigate v
                    ++ [ Input.button (centerX :: Style.actionIcon)
                            { onPress =
                                Just <| ToggleSidebar
                            , label = icon Cross [ centerX, centerY ]
                            }
                       ]
                )
            ]
            |> inFront

    else
        button
            ([ alignRight
             , Element.alignBottom
             , Element.moveLeft 10
             , Element.moveUp 10
             ]
                ++ ballIcon
            )
            { onPress = Just ToggleSidebar
            , label = icon Bars [ centerX, centerY ]
            }
            |> inFront


icons : (Route -> Msg) -> AppView -> List (Element Msg)
icons nav v =
    let
        active isActive =
            if isActive then
                centerX :: ballIcon

            else
                centerX :: Style.actionIcon
    in
    [ button (active <| v == ViewStart)
        { onPress = Just <| nav Start
        , label = icon Home [ centerX, centerY ]
        }
    , button (active <| isPositionView v)
        { onPress = Just <| nav Positions
        , label = icon Flag [ centerX, centerY ]
        }
    , button (active <| isTransitionView v)
        { onPress = Just <| nav Transitions
        , label = icon Arrow [ centerX, centerY ]
        }
    , button (active <| isSubmissionView v)
        { onPress = Just <| nav Submissions
        , label = icon Bolt [ centerX, centerY ]
        }
    , button (active <| isTagView v)
        { onPress = Just <| nav TagsRoute
        , label = icon Tags [ centerX, centerY ]
        }
    , button (active <| isTopicView v)
        { onPress = Just <| nav Topics
        , label = icon Book [ centerX, centerY ]
        }
    , button (active <| v == ViewSettings)
        { onPress = Just <| nav SettingsRoute
        , label = icon Cogs [ centerX, centerY ]
        }
    , button (centerX :: Style.actionIcon)
        { onPress = Just <| Logout
        , label = icon SignOut [ centerX, centerY ]
        }
    ]


transitionPositions : Info -> Info -> Element Msg
transitionPositions startPosition endPosition =
    paragraph
        [ centerY, centerX ]
        [ button []
            { onPress = Just <| NavigateTo <| PositionRoute startPosition.id
            , label =
                el Style.link <|
                    text startPosition.name
            }
        , el [ padding 20 ] <| icon Arrow Style.mattIcon
        , button []
            { onPress = Just <| NavigateTo <| PositionRoute endPosition.id
            , label =
                el Style.link <|
                    text endPosition.name
            }
        ]


blocks : (Id -> Route) -> List { r | id : Id, name : String } -> Element Msg
blocks route =
    List.map
        (\{ id, name } ->
            block name <| NavigateTo <| route id
        )
        >> column []


block : String -> msg -> Element msg
block txt msg =
    button [ padding 10 ]
        { onPress = Just <| msg
        , label =
            paragraph Style.block
                [ text txt
                ]
        }


viewPickPosition : (Info -> Msg) -> GqlRemote (List Info) -> Element Msg
viewPickPosition msg ps =
    el [ width fill, height fill, Background.color Style.c ] <|
        paragraph [ padding 20 ]
            (ps
                |> RemoteData.withDefault []
                |> List.map
                    (\p ->
                        Input.button
                            []
                            { onPress =
                                Just <| msg p
                            , label =
                                el [ padding 10 ] <| el Style.block <| text p.name
                            }
                    )
            )


viewRemote : (a -> Element Msg) -> RemoteData e a -> Element Msg
viewRemote fn data =
    case data of
        NotAsked ->
            el [ centerX ] <| text "not asked"

        Loading ->
            el
                [ Font.color Style.e
                , Font.size 60
                , centerX
                , centerY
                ]
                spinner

        Failure err ->
            --err
            --|> formatHttpError
            --|> Errors
            --|> viewErrors
            el [] <| text "uh oh"

        Success a ->
            fn a


viewSubmissionPicker : Form -> Element Msg
viewSubmissionPicker form =
    column
        [ width shrink, centerX, spacing 20, height shrink ]
        [ el [ centerX ] <| icon Flag Style.mattIcon
        , pickPosition ToggleStartPosition form.startPosition
        ]


viewTransitionPickers : Form -> Element Msg
viewTransitionPickers form =
    column
        [ width shrink, centerX, spacing 20 ]
        [ el [ centerX ] <| pickPosition ToggleStartPosition form.startPosition
        , el [ centerX ] <| icon ArrowDown Style.mattIcon
        , el [ centerX ] <| pickPosition ToggleEndPosition form.endPosition
        ]


pickPosition : Msg -> Maybe Info -> Element Msg
pickPosition msg position =
    case position of
        Nothing ->
            actionIcon Question (Just msg)

        Just { name } ->
            Input.button []
                { onPress =
                    Just msg
                , label =
                    el Style.link <| text name
                }


editRow : String -> Icon -> Msg -> Element Msg
editRow name fa editMsg =
    row
        [ width shrink, height shrink, spacing 20, centerX ]
        [ el [ centerX ] <| icon fa Style.mattIcon
        , paragraph
            [ Font.size 35
            , Font.color Style.e
            , width fill
            ]
            [ text name ]
        , actionIcon Write (Just editMsg)
        ]


addNewRow : Icon -> Msg -> Element Msg
addNewRow fa msg =
    row [ spacing 20, width shrink, centerX ]
        [ icon fa Style.mattIcon
        , plus msg
        ]


nameEdit : Form -> Element Msg
nameEdit form =
    Input.text
        ([ centerX, fill |> maximum 500 |> width ] ++ Style.field)
        { onChange = \str -> UpdateForm { form | name = str }
        , text = form.name
        , label = noLabel
        , placeholder = Nothing
        }


plus : msg -> Element msg
plus msg =
    actionIcon Plus (Just msg)


minus : msg -> Element msg
minus msg =
    actionIcon Minus (Just msg)


editButtons : Bool -> Msg -> Msg -> Element Msg
editButtons waiting save delete =
    el [ centerX ] <|
        if waiting then
            spinner

        else
            row
                [ spacing 20 ]
                [ actionIcon Tick (Just save)
                , actionIcon Cross (Just Cancel)
                , actionIcon Trash (Just <| Confirm <| Just delete)
                ]


createButtons : Bool -> Msg -> Element Msg
createButtons waiting save =
    el [ centerX ] <|
        if waiting then
            spinner

        else
            row
                [ spacing 20 ]
                [ actionIcon Tick (Just save)
                , actionIcon Cross (Just Cancel)
                ]


stepsEditor : Form -> Element Msg
stepsEditor form =
    let
        steps =
            column
                [ spacing 10 ]
                (form.steps
                    |> Array.indexedMap
                        (\i v ->
                            Input.multiline
                                (Style.field
                                    ++ [ htmlAttribute <| Html.Attributes.rows 4
                                       , htmlAttribute <| Html.Attributes.wrap "hard"
                                       , htmlAttribute <| Html.Attributes.style "white-space" "normal"
                                       , centerX
                                       , fill |> maximum 500 |> width
                                       ]
                                )
                                { onChange =
                                    \str ->
                                        UpdateForm
                                            { form | steps = Array.set i str form.steps }
                                , text = v
                                , label = noLabel
                                , placeholder = Nothing
                                , spellcheck = True
                                }
                        )
                    |> Array.toList
                )

        buttons =
            el [ centerX ] <|
                row
                    [ spacing 10 ]
                    [ plus (UpdateForm { form | steps = Array.push "" form.steps })
                    , when (not <| Array.isEmpty form.steps) <|
                        minus (UpdateForm { form | steps = Array.slice 0 -1 form.steps })
                    ]
    in
    column
        [ spacing 10
        , width fill
        , height shrink
        ]
        [ icon Cogs (centerX :: Style.bigIcon)
        , steps
        , buttons
        ]


notesEditor : Form -> Element Msg
notesEditor form =
    let
        notes =
            column
                [ spacing 10 ]
                (form.notes
                    |> Array.indexedMap
                        (\i v ->
                            Input.multiline
                                (Style.field
                                    ++ [ htmlAttribute <| Html.Attributes.rows 4
                                       , htmlAttribute <| Html.Attributes.wrap "hard"
                                       , htmlAttribute <| Html.Attributes.style "white-space" "normal"
                                       , centerX
                                       , fill |> maximum 500 |> width
                                       ]
                                )
                                { onChange =
                                    \str ->
                                        UpdateForm
                                            { form | notes = Array.set i str form.notes }
                                , text = v
                                , label = noLabel
                                , placeholder = Nothing
                                , spellcheck = True
                                }
                        )
                    |> Array.toList
                )

        buttons =
            el [ centerX ] <|
                row
                    [ spacing 10 ]
                    [ plus (UpdateForm { form | notes = Array.push "" form.notes })
                    , when (not <| Array.isEmpty form.notes) <|
                        minus (UpdateForm { form | notes = Array.slice 0 -1 form.notes })
                    ]
    in
    column
        [ spacing 10
        , width fill
        , height shrink
        ]
        [ icon Notes (centerX :: Style.bigIcon)
        , notes
        , buttons
        ]


viewSteps : Array String -> Element Msg
viewSteps =
    Array.toList
        >> List.indexedMap
            (\i step ->
                row [ fill |> maximum 500 |> width ]
                    [ el [ Font.color Style.e, Element.alignTop ] <|
                        text <|
                            (String.fromInt (i + 1) ++ ".")
                    , paragraph
                        [ width fill ]
                        [ text step
                        ]
                    ]
            )
        >> column [ Font.size 25, width shrink, centerX ]


viewNotes : Array String -> Element msg
viewNotes =
    Array.toList
        >> List.map
            (\note ->
                row [ fill |> maximum 500 |> width ]
                    [ el [ Font.color Style.e, Element.alignTop ] <| text "• "
                    , if Regex.contains matchLink note then
                        newTabLink [ Font.underline ]
                            { url = note
                            , label = text <| domain note
                            }

                      else
                        paragraph
                            [ width fill
                            ]
                            [ text note
                            ]
                    ]
            )
        >> column [ Font.size 25, width shrink, centerX ]


viewTransitions : List Transition -> Element Msg
viewTransitions ts =
    column
        []
        (ts
            |> List.map
                (\{ id, endPosition, name } ->
                    paragraph
                        []
                        [ el [ Font.color Style.e ] <| text "• "
                        , button Style.link
                            { onPress = Just <| NavigateTo <| TransitionRoute id
                            , label = text name
                            }
                        , text " "
                        , paragraph
                            []
                            [ text "("
                            , button Style.link
                                { onPress =
                                    Just <| NavigateTo <| PositionRoute endPosition.id
                                , label =
                                    text endPosition.name
                                }
                            , text ")"
                            ]
                        ]
                )
        )


viewTechList : (Id -> Route) -> List { r | name : String, id : Id } -> Element Msg
viewTechList route xs =
    if List.isEmpty xs then
        none

    else
        column
            []
            (xs
                |> List.map
                    (\t ->
                        button []
                            { onPress = Just <| NavigateTo <| route t.id
                            , label =
                                paragraph
                                    [ width fill
                                    ]
                                    [ el [ Font.color Style.e ] <| text "• "
                                    , el Style.link <| text t.name
                                    ]
                            }
                    )
            )


editTags : GqlRemote (List Info) -> List Info -> Element Msg
editTags tags xs =
    column [ spacing 30, width shrink, centerX ]
        [ el [ centerX ] <| icon Tags Style.mattIcon
        , xs
            |> List.indexedMap
                (\i tag ->
                    block (tag.name ++ " -") <| RemoveTag i
                )
            |> paragraph [ width fill ]
        , tags
            |> viewRemote
                (List.filter
                    (\x -> List.member x xs |> not)
                    >> List.map
                        (\tag ->
                            block (tag.name ++ " +") <| AddTag tag
                        )
                    >> paragraph [ width fill ]
                )
        ]


viewTags : List Info -> Element Msg
viewTags tags =
    column [ spacing 20, width shrink, centerX ]
        [ icon Tags Style.mattIcon
        , if List.isEmpty tags then
            el [] <| text "None!"

          else
            column
                []
                (tags
                    |> List.map
                        (\t ->
                            button []
                                { onPress = Just <| NavigateTo <| TagRoute t.id
                                , label =
                                    paragraph
                                        [ width fill ]
                                        [ el [ Font.color Style.e, padding 5 ] <| text "• "
                                        , el Style.link <| text t.name
                                        ]
                                }
                        )
                )
        ]


viewErrors : Status -> Element Msg
viewErrors status =
    case status of
        Waiting ->
            none

        Ready ->
            none

        Errors es ->
            column
                [ spacing 15
                , padding 10
                , height shrink
                , Border.rounded 5
                , Border.color Style.e
                , Border.width 2
                , Border.solid
                , width shrink
                , centerX
                ]
                [ el [ centerX ] <| icon Warning Style.mattIcon
                , viewNotes <| Array.fromList <| Ne.toList es
                ]


viewTransitionPositions : Bool -> Bool -> Bool -> Transition -> Element Msg
viewTransitionPositions showHeader linkFrom linkTo transition =
    column
        [ centerX
        , Border.rounded 5
        , Border.width 2
        , Border.color Style.e
        , Border.solid
        , width shrink
        , padding 30
        , spacing 20
        , height shrink
        ]
        [ when showHeader
            (column [ spacing 20 ]
                [ button [ centerX, width fill ]
                    { onPress = Just <| NavigateTo <| TransitionRoute transition.id
                    , label =
                        el (centerX :: Style.link) <|
                            text transition.name
                    }
                , el [ Background.color Style.e, centerX, width <| px 20, height <| px 2 ] none
                ]
            )
        , if linkFrom then
            button [ centerX ]
                { onPress = Just <| NavigateTo <| PositionRoute transition.startPosition.id
                , label =
                    el Style.link <|
                        text transition.startPosition.name
                }

          else
            el [ Font.color Style.e, centerX ] <| text transition.startPosition.name
        , el [ centerX ] <| icon ArrowDown Style.mattIcon
        , if linkTo then
            button [ centerX ]
                { onPress = Just <| NavigateTo <| PositionRoute transition.endPosition.id
                , label =
                    el Style.link <|
                        text transition.endPosition.name
                }

          else
            el [ Font.color Style.e, centerX ] <| text transition.endPosition.name
        ]


domain : String -> String
domain s =
    Regex.findAtMost 10 matchDomain s
        |> List.head
        |> Maybe.andThen (.submatches >> List.head)
        |> Maybe.andThen identity
        |> Maybe.withDefault s


actionIcon : Icon -> Maybe msg -> Element msg
actionIcon fa msg =
    Input.button
        [ Font.color Style.e
        , Border.solid
        , Border.width 2
        , Border.color Style.e
        , padding 5
        , Border.rounded 5
        , mouseOver
            [ Background.color Style.e
            , Font.color Style.c
            ]
        ]
        { onPress = msg
        , label = icon fa [ centerX, centerY ]
        }


spinner : Element msg
spinner =
    icon Spinner
        ((Html.Attributes.style
            "animation"
            "rotation 2s infinite linear"
            |> Element.htmlAttribute
         )
            :: Style.mattIcon
        )
