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
    Html.div []
        [ Html.fieldset []
            [ Html.legend [] [ Html.text "Try clicking through these options. Then try tabbing/arrowing!" ]
            , viewInput model.focusStyleManager "a"
            , viewInput model.focusStyleManager "b"
            , viewInput model.focusStyleManager "c"
            , viewInput model.focusStyleManager "d"
            ]
        ]


viewInput : FocusStyleManager.Model -> String -> Html.Html msg
viewInput focusStyleManager description =
    Html.label []
        [ Html.input
            [ Html.Attributes.type_ "radio"
            , Html.Attributes.name "alphabet"
            , Html.Attributes.value description
            , Html.Attributes.id description
            , inputFocusStyles focusStyleManager
            ]
            []
        , Html.text description
        ]


inputFocusStyles : FocusStyleManager.Model -> Html.Attribute msg
inputFocusStyles focusStyleManager =
    FocusStyleManager.styles
        { keyboardUser = Html.Attributes.style [ ( "outline", "2px solid pink" ) ]
        , mouseUser = Html.Attributes.style [ ( "outline", "1px dashed red" ) ]
        , touchUser = Html.Attributes.style [ ( "outline", "none" ) ]
        }
        focusStyleManager


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
