module FocusStyleManager
    exposing
        ( CustomStyle
        , Model
        , Msg
        , Style
        , customStyle
        , keyboardUser
        , mouseUser
        , style
        , subscriptions
        , update
        )

{-|

@docs Model, keyboardUser, mouseUser

@docs Msg, update, subscriptions

@docs Style, style

@docs CustomStyle, customStyle

-}

import Html
import Html.Attributes
import Json.Encode
import Keyboard
import Mouse


{-| Use `keyboardUser` or `mouseUser` to initialize a Model.
-}
type Model
    = KeyboardUser
    | MouseUser


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


{-| -}
type Msg
    = KeyboardInteraction
    | MouseInteraction


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


{-| We subscribe to key downs and to mouse moves (not presses, ups, clicks, etc.).
We don't subscribe to events that wouldn't change our user type (e.g., we
care about key downs when we think that the current user only uses the mouse
because it means we need to switch user types).
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        MouseUser ->
            keyDowns

        KeyboardUser ->
            mouseMoves


keyDowns : Sub Msg
keyDowns =
    Keyboard.downs (always KeyboardInteraction)


mouseMoves : Sub Msg
mouseMoves =
    Mouse.moves (always MouseInteraction)


{-| Specify the styles that you want to use for each user type.

    styleSet : FocusStyleManager.style
    styleSet =
        { keyboardUser = [ ( "outline", "3px solid pink" ) ]
        , mouseUser = [ ( "outline", "none" ) ]
        }

-}
type alias Style =
    { keyboardUser : List ( String, String )
    , mouseUser : List ( String, String )
    }


{-| Creates a scoped [style html node](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/style).
The appropriate styles for the user will be applied to elements with the
`:focus` pseudoselector.

    view model =
        div []
            [ FocusStyleManager.style
                { keyboardUser = [ ( "outline", "3px solid pink" ) ]
                , mouseUser = [ ( "outline", "none" ) ]
                }
                model.focusStyleManager
            ]

-}
style : Style -> Model -> Html.Html msg
style style =
    customStyle
        { styleToTag = stylesToStyleElement
        , keyboardUser = style.keyboardUser
        , mouseUser = style.mouseUser
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
    }


{-| Create a custom output for your styles. Unless you're using an elm-based css
preprocesor of some kind, you probably want `style` instead.
-}
customStyle : CustomStyle a html -> Model -> html
customStyle { keyboardUser, mouseUser, styleToTag } model =
    styleToTag <|
        case model of
            KeyboardUser ->
                keyboardUser

            MouseUser ->
                mouseUser
