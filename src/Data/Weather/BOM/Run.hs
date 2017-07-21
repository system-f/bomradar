module Data.Weather.BOM.Run where

import Control.Exitcode
import Control.Monad.IO.Class
import Control.Monad.Trans.Except

import Data.Weather.BOM.Animate
import Data.Weather.BOM.AsConnError
import Data.Weather.BOM.ConfigurationT
import Data.Weather.BOM.Composite
import Data.Weather.BOM.Http
import Data.Weather.BOM.Transparency

run ::
  (AsConnError f, MonadIO io) =>
  [Transparency]
  -> ConfigurationT (ExceptT f (ExitcodeT io)) ()  
run ts =
  do  i <- bomLoopImages
      _ <- bomDownloadImages i
      e <- bomDownloadCurrentImages i
      f <- downloadTransparency ts
      g <- compositeTransparency f
      h <- bomCompositeCurrentImages e f g
      bomAnimateCurrentImages h
