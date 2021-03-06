module Main exposing (..)

import Css
import Css.Colors
import Css.Foreign
import FocusStyleManager
import Html.Styled as Html
import Html.Styled.Attributes as Attributes


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
        [ Html.h1 [] [ Html.text "tesk9/focus-style-manager example using rtfeldman/elm-css" ]
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
        , FocusStyleManager.customStyle
            { styleToTag =
                \relevantStyle ->
                    Css.Foreign.global
                        [ Css.Foreign.everything [ Css.focus [ relevantStyle ] ]
                        ]
            , keyboardUser = Css.outline3 (Css.px 3) Css.solid Css.Colors.fuchsia
            , mouseUser = Css.outline Css.none
            }
            model.focusStyleManager
        ]


viewInput : String -> Html.Html msg
viewInput description =
    Html.label []
        [ Html.input
            [ Attributes.type_ "radio"
            , Attributes.name "alphabet"
            , Attributes.value description
            , Attributes.id description
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
