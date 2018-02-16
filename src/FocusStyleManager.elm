module FocusStyleManager
    exposing
        ( Model
        , Msg
        , keyboardUser
        , mouseUser
        , styles
        , subscriptions
        , update
        )

{-| Showing focus styles is vital for users who interact with webpages primarily
through keyboard actions.

Focus styles can be confusing/unhelpful for users who interact with applications
primarily through point & click.

Detect whether the user's last interaction was a keyboard event or a mouse event,
and use this information to display the appropriate styles for the user.

@docs Model, keyboardUser, mouseUser

@docs Msg, update, subscriptions

@docs styles

-}

import Keyboard
import Mouse
import Touch


{-| Use `keyboardUser`, `mouseUser`, or `touchUser` to initialize a Model.
-}
type Model
    = KeyboardUser
    | MouseUser
    | TouchUser


{-| Initialize the user as primarily interested in Keyboard use.

    import KeyboardFocusManager

    type alias Model =
        { id : Int
        , name : String
        , focusStyleManager : KeyboardFocusManager.Model
        }

    init : { id : Int, name : String } -> Model
    init flagsData =
        { id = flagsData.id
        , name = flagsData.name
        , focusStyleManager = KeyboardFocusManager.keyboardUser
        }

-}
keyboardUser : Model
keyboardUser =
    KeyboardUser


{-| Initialize the user as primarily interested in Mouse use.

    import KeyboardFocusManager

    type alias Model =
        { id : Int
        , name : String
        , focusStyleManager : KeyboardFocusManager.Model
        }

    init : { id : Int, name : String } -> Model
    init flagsData =
        { id = flagsData.id
        , name = flagsData.name
        , focusStyleManager = KeyboardFocusManager.mouseUser
        }

-}
mouseUser : Model
mouseUser =
    MouseUser


{-| Initialize the user as primarily interested in Touch (aka tablet and phone) use.

    import KeyboardFocusManager

    type alias Model =
        { id : Int
        , name : String
        , focusStyleManager : KeyboardFocusManager.Model
        }

    init : { id : Int, name : String } -> Model
    init flagsData =
        { id = flagsData.id
        , name = flagsData.name
        , focusStyleManager = KeyboardFocusManager.touchUser
        }

-}
touchUser : Model
touchUser =
    TouchUser


{-| -}
type Msg
    = KeyboardInteraction
    | MouseInteraction
    | TouchInteraction


{-| Use this function in your update branch to update the styling when the user
changes interaction styles.

    import FocusStyleManager

    type Msg
        = -- You probably have some other branches here too :)
          FocusStyleManagerMsg FocusStyleManager.Msg

    update msg model =
        case msg of
            FocusStyleManagerMsg focusStyleManagerMsg ->
                let
                    focusStyleManager =
                        FocusStyleManager.update focusStyleManagerMsg model.focusStyleManager
                in
                { model | focusStyleManager = focusStyleManager }

-}
update : Msg -> Model -> Model
update msg model =
    case msg of
        KeyboardInteraction ->
            KeyboardUser

        MouseInteraction ->
            MouseUser

        TouchInteraction ->
            TouchUser


{-| We subscribe to key downs, to mouse downs, and touch starts (not presses, ups, clicks, etc.).
We don't subscribe to events that wouldn't change our user type (e.g., we
care about key downs when we think that the current user only uses the mouse
because it means we need to switch user types).
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch <|
        case model of
            MouseUser ->
                [ Keyboard.downs (always KeyboardInteraction)
                , Touch.start (always TouchInteraction)
                ]

            KeyboardUser ->
                [ Mouse.downs (always MouseInteraction)
                , Touch.start (always TouchInteraction)
                ]

            TouchUser ->
                [ Keyboard.downs (always KeyboardInteraction)
                , Mouse.downs (always MouseInteraction)
                ]


{-| -}
styles : String
styles =
    "TODO"
