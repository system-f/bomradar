module Data.Weather.BOM.OutputDirectory where

import System.FilePath((</>))
import Data.Weather.BOM.ConfigurationT

getRadarOutputDirectory ::
  Monad f =>
  ConfigurationT f FilePath
getRadarOutputDirectory =
  do  r <- getRadar
      d <- getOutputDirectory
      pure (d </> r)

getCurrentRadarOutputDirectory ::
  Monad f =>
  ConfigurationT f FilePath
getCurrentRadarOutputDirectory =
  getRadarOutputDirectory </.> "current"
  
getArchiveRadarOutputDirectory ::
  Monad f =>
  ConfigurationT f FilePath
getArchiveRadarOutputDirectory =
  getRadarOutputDirectory </.> "archive"
  
getAnimatedRadarOutputDirectory ::
  Monad f =>
  ConfigurationT f FilePath
getAnimatedRadarOutputDirectory =
  getRadarOutputDirectory </.> "animated"
  
getTransparencyRadarOutputDirectory ::
  Monad f =>
  ConfigurationT f FilePath
getTransparencyRadarOutputDirectory =
  getRadarOutputDirectory </.> "transparency"
  
getCompositeTransparencyRadarOutputDirectory ::
  Monad f =>
  ConfigurationT f FilePath
getCompositeTransparencyRadarOutputDirectory =
  getTransparencyRadarOutputDirectory </.> "composite"
  
getCurrentCompositeTransparencyRadarOutputDirectory ::
  Monad f =>
  ConfigurationT f FilePath
getCurrentCompositeTransparencyRadarOutputDirectory =
  getCurrentRadarOutputDirectory </.> "composite"
  
getCurrentAnimatedTransparencyRadarOutputDirectory ::
  Monad f =>
  ConfigurationT f FilePath
getCurrentAnimatedTransparencyRadarOutputDirectory =
  getCurrentRadarOutputDirectory </.> "animated"
