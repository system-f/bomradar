module Data.Weather.BOM.Animate where

import Control.Exitcode
import Control.Lens hiding ((<.>))
import Control.Monad.IO.Class
import Data.List
import Control.Monad.Trans.Except
import System.FilePath hiding ((<.>))

import Data.Weather.BOM.ConfigurationT
import Data.Weather.BOM.File
import Data.Weather.BOM.OutputDirectory
import Data.Weather.BOM.Util

bomAnimateCurrentImages ::
  MonadIO io =>
  [[File (FilePath, FilePath)]]
  -> ConfigurationT (ExceptT f (ExitcodeT io)) ()
bomAnimateCurrentImages =
  let foreach ::
        MonadIO io =>
        [File (FilePath, FilePath)]
        -> ConfigurationT (ExceptT f (ExitcodeT io)) ()
      foreach f =
        let name ::
              MonadIO io =>
              ConfigurationT (ExceptT f (ExitcodeT io)) FilePath
            name =
              do  r <- getRadar
                  pure (concat [r, "_", intercalate "_" (ordnub ((\t -> takeBaseName (t ^. file_data . _1)) <$> f)), ".gif"])
            input =
              (^. file_data . _2) <$> f
        in  do  y <- getDelay
                d <- mkdir (getCurrentAnimatedTransparencyRadarOutputDirectory </.> y)
                n <- name
                intoConfiguration ("convert" !-> 
                                      ([
                                        "-dispose"
                                      , "previous"
                                      , "-delay"
                                      , y
                                      , "-loop"
                                      , "0"
                                      ] ++ 
                                      input ++
                                      [d </> n]))
  in  mapM_ foreach
