module Config.View (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import EasyEvents exposing (onInput)
import Signal exposing (Address)
import Types exposing (..)


view : Address Action -> Model -> Html
view address model =
  div
    [ class "page-config container" ]
    [ label [] [text "Markdown"]
    , textarea
        [ onInput address ChangeSrc
        , class "input-src form-control"
        , id "edit-markdown"
        , rows 20
        ]
        [ text model.src ]
    , label [] [text "CSS"]
    , textarea
        [ onInput address ChangeCss
        , class "input-css form-control"
        , id "edit-css"
        , rows 20
        ]
        [ text model.css ]
    , button [ class "btn btn-primary btn-lg", onClick address SaveConfig ] [ text "save" ]
    ]
