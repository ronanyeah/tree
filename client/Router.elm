module Router exposing (router)

import Api.Scalar exposing (Id(..))
import RemoteData exposing (RemoteData(..))
import Types exposing (Route(..))
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, string)


routes : List (Parser (Route -> a) a)
routes =
    [ map Positions (s "app" </> s "positions")
    , map Submissions (s "app" </> s "submissions")
    , map TagsRoute (s "app" </> s "tags")
    , map Topics (s "app" </> s "topics")
    , map Transitions (s "app" </> s "transitions")
    , map CreatePositionRoute (s "app" </> s "positions" </> s "new")
    , map CreateSubmissionRoute (s "app" </> s "submissions" </> s "new")
    , map CreateTagRoute (s "app" </> s "tags" </> s "new")
    , map CreateTopicRoute (s "app" </> s "topics" </> s "new")
    , map CreateTransitionRoute (s "app" </> s "transitions" </> s "new")
    , map (Id >> EditPositionRoute) (s "app" </> s "positions" </> string </> s "edit")
    , map (Id >> EditSubmissionRoute) (s "app" </> s "submissions" </> string </> s "edit")
    , map (Id >> EditTransitionRoute) (s "app" </> s "transitions" </> string </> s "edit")
    , map (Id >> EditTagRoute) (s "app" </> s "tags" </> string </> s "edit")
    , map (Id >> EditTopicRoute) (s "app" </> s "topics" </> string </> s "edit")
    , map (Id >> PositionRoute) (s "app" </> s "positions" </> string)
    , map SettingsRoute (s "app" </> s "settings")
    , map (Id >> SubmissionRoute) (s "app" </> s "submissions" </> string)
    , map (Id >> TagRoute) (s "app" </> s "tags" </> string)
    , map (Id >> TopicRoute) (s "app" </> s "topics" </> string)
    , map (Id >> TransitionRoute) (s "app" </> s "transitions" </> string)
    , map Start (s "app" </> s "start")
    , map Login (s "app" </> s "login")
    , map SignUp (s "app" </> s "sign-up")
    ]


router : Url -> Route
router =
    parse (oneOf routes)
        >> Maybe.withDefault NotFound
