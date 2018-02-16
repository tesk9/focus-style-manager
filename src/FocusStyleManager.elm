module FocusStyleManager
    exposing
        ( Model
        , Msg
        , keyboardUser
        , mouseUser
        , styles
        , subscriptions
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


{-| -}
type Model
    = KeyboardUser
    | MouseUser


{-| -}
keyboardUser : Model
keyboardUser =
    KeyboardUser


{-| -}
mouseUser : Model
mouseUser =
    MouseUser


type Msg
    = KeyboardInteraction
    | MouseInteraction


{-| -}
update : Msg -> Model -> Model
update msg model =
    case msg of
        KeyboardInteraction ->
            KeyboardUser

        MouseInteraction ->
            MouseUser


{-| -}
subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        MouseUser ->
            Keyboard.downs (always KeyboardInteraction)

        KeyboardUser ->
            Mouse.downs (always MouseInteraction)


{-| -}
styles : String
styles =
    "TODO"
