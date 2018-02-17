# Focus Style Manager

## What is this and why?

Showing focus styles is vital for users who interact with webpages primarily
through keyboard actions.

Focus styles can be confusing/unhelpful for users who interact with applications
primarily through point & click.

This library will detect whether the user's last interaction was a keyboard event,
mouse event, or touch event.

Then, it will use this state to display the styles that you specify for this
type of user.

Suppose you hate the look of little blue outline that shows around radio inputs
when they're focused. You can change the styles so that it's a nice fuschia
color for keyboard users, and never shown for point & click users.

## How do I use this module?

This library follows the Elm architecture (model passed into the view,
user actions trigger updates which change the model... if this isn't familiar,
please check out [the elm-lang guide](https://guide.elm-lang.org/architecture/).)

Note that the library uses subscriptions rather than Html events to track user events --
be sure to wire those up!

### Example Use

![Demonstration of behavior](https://user-images.githubusercontent.com/8811312/36335614-0c391842-1336-11e8-8571-863221bae289.gif)

### Example Code

```
import FocusStyleManager

main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

type alias Model =
    { focusStyleManager : FocusStyleManager.Model
    }

init =
    ( { focusStyleManager = FocusStyleManager.keyboardUser
      }
    , Cmd.none
    )

view model =
    Html.main_ []
        [ FocusStyleManager.style
            { keyboardUser = [ ( "outline", "3px solid pink" ) ]
            , mouseUser = [ ( "outline", "none" ) ]
            , touchUser = [ ( "outline", "none" ) ]
            }
            model.focusStyleManager
        , Html.text "Probably your application has other content too!"
        ]


type Msg
    = FocusStyleManagerMsg FocusStyleManager.Msg

update msg model =
    case msg of
        FocusStyleManagerMsg focusStyleManagerMsg ->
            let
                focusStyleManager =
                    FocusStyleManager.update focusStyleManagerMsg model.focusStyleManager
            in
            ( { model | focusStyleManager = focusStyleManager }
            , Cmd.none
            )

subscriptions model =
    Sub.map FocusStyleManagerMsg
        (FocusStyleManager.subscriptions model.focusStyleManager)
```

Note:

The repository contains two examples, one of which is using this module with
[elm-css](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest).
If your application uses elm-css or another styling pre-processor,
please be sure to check out the examples folder on github.
