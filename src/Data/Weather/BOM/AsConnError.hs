module Data.Weather.BOM.AsConnError where

import Control.Lens hiding (Prism)
import Network.Stream

class AsConnError a where
  _ConnError ::
    Prism' a ConnError

instance AsConnError ConnError where
  _ConnError =
    id
