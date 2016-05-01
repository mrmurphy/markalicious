module Main (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import History
import Effects
import Signal exposing (Address)
import StartApp exposing (start)
import Task
import Types exposing (..)
import Config.View
import Config.Ajax
import Gallery


clearFlash : Effects.Effects Action
clearFlash =
  Task.sleep 3000
    `Task.andThen` (\_ -> Task.succeed ClearFlash)
    |> Effects.task


update : Action -> Model -> ( Model, Effects.Effects Action )
update action model =
  case Debug.log "action" action of
    ChangeSrc str ->
      ( { model | src = str }, Effects.none )

    ChangeCss str ->
      ( { model | css = str }, Effects.none )

    SaveConfig ->
      ( model
      , Config.Ajax.save model.location (Payload model.src model.css)
      )

    ShowConfig ->
      ( { model | showConfig = True }, Effects.none )

    SaveSuccessful ->
      ( { model | flash = "Save successful!", showConfig = False }
      , clearFlash
      )

    LoadedConfig (Payload src css) ->
      ( { model | src = src, css = css }
      , Effects.none
      )

    Flash str ->
      ( { model | flash = str }
      , clearFlash
      )

    ClearFlash ->
      ( { model | flash = "" }
      , Effects.none
      )

    PathChanged newPath ->
      ( { model | location = newPath }
      , Config.Ajax.load newPath
      )

    NoOp ->
      ( model, Effects.none )


view : Address Action -> Model -> Html
view address model =
  div
    []
    [ Gallery.view address model
    , if model.showConfig then
        Config.View.view address model
      else
        div [] []
    , case model.flash of
        "" ->
          div [] []

        _ ->
          div [ class "flash" ] [ text model.flash ]
    ]


app : StartApp.App Model
app =
  StartApp.start
    { init = ( init initialHash, Config.Ajax.load initialHash )
    , update = update
    , view = view
    , inputs = [ Signal.map PathChanged History.hash ]
    }


main : Signal Html
main =
  app.html


port tasks : Signal.Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks

port css : Signal String
port css = Signal.map .css app.model

port initialHash : String
