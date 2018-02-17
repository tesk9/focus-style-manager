module FocusStyleManager
    exposing
        ( CustomStyle
        , Model
        , Msg
        , Style
        , customStyle
        , keyboardUser
        , mouseUser
        , styles
        , subscriptions
        , update
        )

{-|

@docs Model, keyboardUser, mouseUser

@docs Msg, update, subscriptions

@docs Style, styles

@docs CustomStyle, customStyle

-}

import Html
import Html.Attributes
import Json.Encode
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

    import FocusStyleManager

    type alias Model =
        { id : Int
        , name : String
        , focusStyleManager : FocusStyleManager.Model
        }

    init : { id : Int, name : String } -> Model
    init flagsData =
        { id = flagsData.id
        , name = flagsData.name
        , focusStyleManager = FocusStyleManager.keyboardUser
        }

-}
keyboardUser : Model
keyboardUser =
    KeyboardUser


{-| Initialize the user as primarily interested in Mouse use.

    import FocusStyleManager

    type alias Model =
        { id : Int
        , name : String
        , focusStyleManager : FocusStyleManager.Model
        }

    init : { id : Int, name : String } -> Model
    init flagsData =
        { id = flagsData.id
        , name = flagsData.name
        , focusStyleManager = FocusStyleManager.mouseUser
        }

-}
mouseUser : Model
mouseUser =
    MouseUser


{-| Initialize the user as primarily interested in Touch (aka tablet and phone) use.

    import FocusStyleManager

    type alias Model =
        { id : Int
        , name : String
        , focusStyleManager : FocusStyleManager.Model
        }

    init : { id : Int, name : String } -> Model
    init flagsData =
        { id = flagsData.id
        , name = flagsData.name
        , focusStyleManager = FocusStyleManager.touchUser
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


{-| We subscribe to key downs, to mouse moves, and touch starts (not presses, ups, clicks, etc.).
We don't subscribe to events that wouldn't change our user type (e.g., we
care about key downs when we think that the current user only uses the mouse
because it means we need to switch user types).
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        MouseUser ->
            Sub.batch [ keyDowns, touchStarts ]

        KeyboardUser ->
            Sub.batch [ mouseMoves, touchStarts ]

        TouchUser ->
            Sub.batch [ keyDowns, mouseMoves ]


keyDowns : Sub Msg
keyDowns =
    Keyboard.downs (always KeyboardInteraction)


mouseMoves : Sub Msg
mouseMoves =
    Mouse.moves (always MouseInteraction)


touchStarts : Sub Msg
touchStarts =
    Touch.start (always TouchInteraction)


{-| -}
type alias Style =
    { keyboardUser : List ( String, String )
    , mouseUser : List ( String, String )
    , touchUser : List ( String, String )
    }


{-| -}
styles : Style -> Model -> Html.Html msg
styles style =
    customStyle
        { styleToTag = stylesToStyleElement
        , keyboardUser = style.keyboardUser
        , mouseUser = style.mouseUser
        , touchUser = style.touchUser
        }


stylesToStyleElement : List ( String, String ) -> Html.Html msg
stylesToStyleElement stylePairs =
    Html.node "style"
        [ stylePairs
            |> List.map styleToCss
            |> String.join ""
            |> addFocusPseudoSelector
            |> Json.Encode.string
            |> Html.Attributes.property "innerHTML"
        , Html.Attributes.scoped True
        ]
        []


addFocusPseudoSelector : String -> String
addFocusPseudoSelector styles =
    ":focus {" ++ styles ++ "}"


styleToCss : ( String, String ) -> String
styleToCss ( propertyName, value ) =
    propertyName ++ ": " ++ value ++ ";"


{-| Configuration for `customStyle`. Unless you're using an elm-based css
preprocesor of some kind, you probably want `Style` instead.
-}
type alias CustomStyle a html =
    { styleToTag : a -> html
    , keyboardUser : a
    , mouseUser : a
    , touchUser : a
    }


{-| Create a custom output for your styles. Unless you're using an elm-based css
preprocesor of some kind, you probably want `style` instead.
-}
customStyle : CustomStyle a html -> Model -> html
customStyle { keyboardUser, mouseUser, touchUser, styleToTag } model =
    styleToTag <|
        case model of
            KeyboardUser ->
                keyboardUser

            MouseUser ->
                mouseUser

            TouchUser ->
                touchUser
