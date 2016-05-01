module Types (..) where


type alias Path =
  String


type alias Src =
  String


type alias Css =
  String


type Payload
  = Payload Src Css


type Action
  = NoOp
  | ChangeSrc String
  | ChangeCss String
  | SaveConfig
  | SaveSuccessful
  | ShowConfig
  | LoadedConfig Payload
  | Flash String
  | ClearFlash
  | PathChanged String


type alias Model =
  { src : String
  , css : String
  , showConfig : Bool
  , location : String
  , flash : String
  }


init : String -> Model
init hash =
  { src = ""
  , css = ""
  , showConfig = False
  , location = hash
  , flash = ""
  }
