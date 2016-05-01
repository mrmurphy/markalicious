module Config.Ajax where

import Http.Extra exposing (put, get, withHeader, withJsonBody, send, stringReader, jsonReader)
import Effects exposing (Effects)
import Task exposing (toResult)
import Json.Encode as Encode exposing (object, string)
import Json.Decode as Decode exposing (object2, (:=), maybe)
import Types exposing (Action(SaveSuccessful, LoadedConfig, Flash), Payload(Payload), Path, Model)
import String

encode : Payload -> Encode.Value
encode (Payload src css) =
  object
    [ ("markdown", string src)
    , ("css", string css)
    ]

decoder : Decode.Decoder Payload
decoder =
  object2 Payload
    ("markdown" := Decode.string)
    ("css" := Decode.string)
  |> maybe
  |> Decode.map ( \maybePayload ->
    case maybePayload of
      Nothing -> Payload "#Welcome!\nThere's nothing here yet. Click the gear in the bottom right corner to enter your own markdown & css." ""
      Just payload -> payload
    )

safeHash : String -> String
safeHash hash =
  case (List.tail (String.toList hash)) of
    Just t -> String.fromList t
    Nothing  -> ""

save : Path -> Payload -> Effects Action
save path payload =
  put("https://markalicious.firebaseio.com/" ++ (safeHash path) ++ ".json")
  |> withJsonBody (encode payload)
  |> withHeader "Content-Type" "application/json"
  |> send stringReader stringReader
  |> toResult
  |> Effects.task
  |> Effects.map
      ( \result ->
        case result of
          Ok _ -> SaveSuccessful
          Err msg -> Flash (toString msg)
      )

load : String -> Effects Action
load path =
  get("https://markalicious.firebaseio.com/" ++ (safeHash path) ++ ".json")
  |> send (jsonReader decoder) stringReader
  |> toResult
  |> Effects.task
  |> Effects.map
      ( \result ->
        case result of
          Ok response -> LoadedConfig response.data
          Err msg -> Flash (toString msg)
      )
