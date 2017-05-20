module Msgs exposing (..)

import Material
import Navigation exposing (Location)


type alias Mdl =
    Material.Model


type Msg
    = Mdl (Material.Msg Msg)
    | OnLocationChange Location
    | ChangeLocation String
    | Switch Int
