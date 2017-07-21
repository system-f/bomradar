module Data.Weather.BOM.Http where

import Control.Exitcode
import Control.Lens hiding ((<.>))
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Class
import Control.Monad.Trans.Except
import Data.List
import Network.HTTP
import Network.URI
import System.FilePath hiding ((<.>))

import Data.Weather.BOM.AsConnError
import Data.Weather.BOM.ConfigurationT
import Data.Weather.BOM.File
import Data.Weather.BOM.Files
import Data.Weather.BOM.OutputDirectory
import Data.Weather.BOM.Transparency
import Data.Weather.BOM.Util

bomLoopImages ::
  (MonadIO io, AsConnError f) =>
  ConfigurationT (ExceptT f io) [String]
bomLoopImages =
  let bomLoop ::
        Applicative f =>
        ConfigurationT f (Request String)
      bomLoop =
        radarConfiguration (\s -> 
          pure (mkRequest GET (URI "http:" (Just (URIAuth "" "www.bom.gov.au" "")) ("/products/" ++ s ++ ".loop.shtml") "" "")))
      bomLoopBody ::
        (MonadIO io, AsConnError f) =>
        ConfigurationT (ExceptT f io) String
      bomLoopBody = 
        bomLoop >>= lift . withExceptT (_ConnError #) . mapExceptT liftIO . (rspBody <$>) . ExceptT . simpleHTTP
      getImageNames ::
        String
        -> [String]
      getImageNames s =
        lines s >>= \x -> case x of
          't':'h':'e':'I':'m':'a':'g':'e':'N':'a':'m':'e':'s':'[':_:']':' ':'=':' ':'"':q ->
            [takeWhile (/= '"') q]
          _ ->
            []
  in  getImageNames <$> bomLoopBody

bomDownloadImages ::
  MonadIO io =>
  [String]
  -> ConfigurationT (ExceptT f (ExitcodeT io)) (Files0 ())
bomDownloadImages i =
  do  c <- mkdir getArchiveRadarOutputDirectory
      let out ::
            [File0]
          out =
            (\x -> file0 ((c </>) . reverse . takeWhile (('/') /=) . reverse $ x) x) <$> i
      intoConfiguration (mapM_ (\x -> "wget" !-> ["-c", "-q", x ^. file_uri, "-O", x ^. file_location]) out)
      pure (files0 out)

bomDownloadCurrentImages ::
  MonadIO io =>
  [String]
  -> ConfigurationT (ExceptT f (ExitcodeT io)) (Files0 ())
bomDownloadCurrentImages i =
  do  d <- mkdir getCurrentRadarOutputDirectory
      r <- getRadar
      let out ::
            [File0]
          out =
            zipWith (\n u -> file0 (d </> concat [r, ".", showNumber n, ".png"]) u) ([0..] :: [Int]) i
      intoConfiguration (mapM_ (\x -> "wget" !-> ["-q", x ^. file_uri, "-O", x ^. file_location]) out)
      pure (files0 out)

downloadTransparency ::
  MonadIO io =>
  [Transparency]
  -> ConfigurationT (ExceptT f (ExitcodeT io)) (Files Transparency ())
downloadTransparency t =
  let backgroundCompare ::
        Transparency
        -> Transparency
        -> Ordering
      backgroundCompare Background _ =
        GT
      backgroundCompare _ Background =
        LT
      backgroundCompare x y =
        compare x y
  in  do  d <- mkdir getTransparencyRadarOutputDirectory
          r <- getRadar
          let out ::
                [File Transparency]
              out =
                (\s ->  let y = transparencyFilename s
                        in  File (d </> y ++ ".png") ("ftp://ftp.bom.gov.au/anon/gen/radar_transparencies/" ++ r ++ "." ++ y ++ ".png") s) <$> sortBy backgroundCompare t
          b <- getDoTransparencies
          intoConfiguration (when b (mapM_ (\x -> "wget" !-> ["-c", "-q", x ^. file_uri, "-O", x ^. file_location]) out))
          pure (files0 out)
