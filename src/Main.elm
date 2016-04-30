module Main where

import Html exposing (..)
-- import History exposing (path)
import Effects
import Signal exposing (Address)
import StartApp exposing (start)
import Task

type alias Model =
  { src : String
  , showConfig : Bool
  , currentPath : String
  }

init : Model
init =
  { src = ""
  , showConfig = False
  , currentPath = ""
  }

type Action
  = NoOp

update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case action of
    NoOp -> (model, Effects.none)

view : Address Action -> Model -> Html
view address model =
  div [] [text "Buenos dias!"]


app : StartApp.App Model
app = start
  { init = (init, Effects.none)
  , update = update
  , view = view
  , inputs = []
  }

main : Signal Html
main = app.html

port tasks : Signal.Signal (Task.Task Effects.Never ())
port tasks = app.tasks

-- Load the markdown for the current URL from the server
-- Save markdown for the current URL to the server
-- https://markalicious.firebaseio.com/<path>.json
