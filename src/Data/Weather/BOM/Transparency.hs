module Data.Weather.BOM.Transparency where

data Transparency =
  Background
  | Catchments
  | Locations
  | Rail
  | Range
  | RiverBasins
  | Roads
  | Topography
  | Waterways
  | WeatherDistricts
  deriving (Eq, Ord, Show)

transparencyFilename ::
 Transparency
 -> String
transparencyFilename t =
  case t of
    Background -> "background"
    Catchments -> "catchments"
    Locations -> "locations"
    Rail -> "rail"
    Range -> "range"
    RiverBasins -> "riverBasins"
    Roads -> "roads"
    Topography -> "topography"
    Waterways -> "waterways"
    WeatherDistricts -> "wthrDistricts"

allTransparency ::
  [Transparency]
allTransparency =
  [
    Background
  , Catchments
  , Locations
  , Rail
  , Range
  , RiverBasins
  , Roads
  , Topography
  , Waterways
  , WeatherDistricts
  ]
