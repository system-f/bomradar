module Data.Weather.BOM.Composite where

import Control.Exitcode
import Control.Lens hiding ((<.>))
import Control.Monad
import Control.Monad.IO.Class
import Data.List
import Control.Monad.Trans.Except
import System.FilePath hiding ((<.>))

import Data.Weather.BOM.ConfigurationT
import Data.Weather.BOM.File
import Data.Weather.BOM.Files
import Data.Weather.BOM.OutputDirectory
import Data.Weather.BOM.Transparency
import Data.Weather.BOM.Util

compositeTransparency ::
  MonadIO io =>
  Files Transparency ()
  -> ConfigurationT (ExceptT f (ExitcodeT io)) [Files Transparency FilePath]
compositeTransparency (Files ds ()) =
  let composite ::
        MonadIO io =>
        FilePath
        -> FilePath
        -> Bool
        -> [File Transparency]
        -> ExitcodeT io [Files Transparency FilePath]
      composite _ _ _ [] =
        pure []
      composite _ _ _ [_] =
        pure []
      composite d e b (File p _ v:ts@(_:g)) =
        let n = intercalate "_" (map (transparencyFilename . (^. file_data)) ts) ++ ".png"
            o = d </> transparencyFilename v ++ "_" ++ n
        in  [Files ts o] <$
              when b ("composite" !-> 
                        [
                          p
                        , (if null g then e else d) </> n
                        , o
                        ])
      powerset ::
        [a]
        -> [[a]]
      powerset =
        filterM (const [False, True])
  in  do  o <- mkdir getCompositeTransparencyRadarOutputDirectory
          w <- mkdir getTransparencyRadarOutputDirectory
          b <- getDoTransparencies
          q <- intoConfiguration (mapM (composite o w b) (powerset ds))
          pure (concat q)

bomCompositeCurrentImages ::
  MonadIO io =>
  Files0 () -- current images
  -> Files Transparency () -- basic transparencies
  -> [Files Transparency FilePath] -- composite transparencies
  -> ConfigurationT (ExceptT f (ExitcodeT io)) [[File (FilePath, FilePath)]]
bomCompositeCurrentImages (Files a _) (Files b _) c =
  let ts ::
        [FilePath]
      ts =
        ordnub ((^. files_data) <$> c) ++ ((^. file_location) <$> b)
      foreach ::
        MonadIO io =>
        (File (), Int)
        -> FilePath
        -> ConfigurationT (ExceptT f (ExitcodeT io)) (File (FilePath, FilePath))
      foreach (f@(File x _ _), n) y =
        let n' =
              showNumber n
        in  do  d <- mkdir (getCurrentCompositeTransparencyRadarOutputDirectory </.> n')
                let out = d </> concat [takeBaseName x, "_", takeFileName y]
                    z = (y, out) <$ f
                z <$
                  intoConfiguration ("composite" !-> 
                                        [
                                          x
                                        , y
                                        , out
                                        ])               
  in  traverse (\t -> traverse (`foreach` t) (zip a [0..])) ts
