module Main where

import Data.Weather.BOM

import Control.Exitcode
import Control.Monad.Trans.Except
import Network.Stream
import System.Environment
import System.IO

runall ::
  [Transparency] -- transparencies
  -> [String]    -- radars to build
  -> String      -- delay
  -> FilePath    -- output directory
  -> Bool        -- to composite or not
  -> IO [Either Int (Either ConnError ())]
runall ts rdr dl out b =
  let testRadar r = runConfigurationT (run ts) r dl b out
  in  traverse (runExitcode . runExceptT . testRadar) rdr

main ::
  IO ()
main =
  do  a <- getArgs
      case a of
        dl:out:r -> 
          runall [Background, Locations, Range, Topography] allRadar dl out (null r) >>= print
        _ -> 
          hPutStrLn stderr "args: <delay> <output-directory> [no-composite]"

