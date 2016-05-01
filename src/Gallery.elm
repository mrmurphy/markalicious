module Gallery (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Signal exposing (Address)
import Types exposing (..)
import Markdown


view : Address Action -> Model -> Html
view address model =
  div
    [ classList
        [ ( "page-gallery", True )
        , ( "container", True )
        , ( "full-height", not model.showConfig )
        ]
    ]
    [ if (model.location == "") then
        Markdown.toHtml """
# Welcome to Markalicious!

If you came here because you love markdown, and you want a beautiful way to render small blocks of text in the middle of your browser page, then you came to the right place.

To get started:

  - Add a `#<some text here>` to the url, for example: [markalicious.murph.xyz/#dinosaurs](#dinosaurs)
  - Click the gear in the bottom right corner of the page
  - Change the markdown & CSS to your heart's content
  - Click save, and stare at your beautiful work
  - Feel free to leave the page, and come back later. Your changes will stick around.

Toodles!

"""
      else
        Markdown.toHtml model.src
    , if (model.location == "") then
        div [] []
      else
        button
          [ class "show-config"
          , onClick address ShowConfig
          ]
          [ i [ class "fa fa-gear" ] []
          ]
    ]
