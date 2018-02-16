module Main exposing (..)

import FocusStyleManager
import Html


{-| Compile using `elm-make Main.elm --output index.html`
-}
main : Program Never Model Msg
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


init : ( Model, Cmd Msg )
init =
    ( { focusStyleManager = FocusStyleManager.keyboardUser
      }
    , Cmd.none
    )


view : Model -> Html.Html Msg
view model =
    Html.div [] []


type Msg
    = FocusStyleManagerMsg FocusStyleManager.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map FocusStyleManagerMsg
        (FocusStyleManager.subscriptions model.focusStyleManager)
