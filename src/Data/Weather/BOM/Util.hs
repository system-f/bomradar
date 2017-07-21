module Data.Weather.BOM.Util where

import Control.Exitcode
import Control.Monad.IO.Class
import qualified Data.Set as Set
import System.Process

(!->) ::
  MonadIO f =>
  String
  -> [String]
  -> ExitcodeT0 f
(!->) s ss =
  do  liftIO (putStrLn (concat ["%% ", s, " !-> ", show ss]))
      fromExitCode (liftIO (rawSystem s ss))

infixl 5 !->

showNumber ::
  (Show a, Ord a, Num a) =>
  a
  -> String
showNumber n =
  if n < 10
    then '0' : show n
    else show n

ordnub ::
  Ord a =>
  [a]
  -> [a]
ordnub =
  Set.toList . Set.fromList

allRadar ::
  [String]
allRadar =
  [
    "IDR773"
  , "IDR093"
  , "IDR633"
  , "IDR783"
  , "IDR423"
  , "IDR073"
  , "IDR413"
  , "IDR363"
  , "IDR193"
  , "IDR173"
  , "IDR393"
  , "IDR733"
  , "IDR243"
  , "IDR163"
  , "IDR153"
  , "IDR753"
  , "IDR223"
  , "IDR293"
  , "IDR563"
  , "IDR723"
  , "IDR253"
  , "IDR233"
  , "IDR053"
  , "IDR443"
  , "IDR083"
  , "IDR673"
  , "IDR503"
  , "IDR663"
  , "IDR063"
  , "IDR623"
  , "IDR533"
  , "IDR283"
  , "IDR793"
  , "IDR483"
  , "IDR693"
  , "IDR273"
  , "IDR583"
  , "IDR333"
  , "IDR703"
  , "IDR043"
  , "IDR383"
  , "IDR713"
  , "IDR323"
  , "IDR303"
  , "IDR033"
  , "IDR643"
  , "IDR313"
  , "IDR553"
  , "IDR463"
  , "IDR403"
  , "IDR493"
  , "IDR143"
  , "IDR023"
  , "IDR683"
  , "IDR523"
  , "IDR763"
  ]
