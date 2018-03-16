module Main exposing (..)

import FocusStyleManager
import Html
import Html.Attributes


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
    Html.main_ []
        [ Html.h1 [] [ Html.text "tesk9/focus-style-manager example" ]
        , viewInputs model
        ]


viewInputs : Model -> Html.Html Msg
viewInputs model =
    Html.div []
        [ Html.fieldset []
            [ Html.legend [] [ Html.text "Try clicking through these options. Then try tabbing/arrowing!" ]
            , viewInput "a"
            , viewInput "b"
            , viewInput "c"
            , viewInput "d"
            ]
        , FocusStyleManager.style
            { keyboardUser = [ ( "outline", "3px solid pink" ) ]
            , mouseUser = [ ( "outline", "none" ) ]
            }
            model.focusStyleManager
        ]


viewInput : String -> Html.Html msg
viewInput description =
    Html.label []
        [ Html.input
            [ Html.Attributes.type_ "radio"
            , Html.Attributes.name "alphabet"
            , Html.Attributes.value description
            , Html.Attributes.id description
            ]
            []
        , Html.text description
        ]


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
