{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
-- See https://github.com/haskell/haddock/issues/565
{-# OPTIONS_HADDOCK prune #-}

module Data.Weather.BOM.File where

import Control.Lens

data File a =
  File {
    _file_location ::
      FilePath
  , _file_uri ::
      String
  , _file_data ::
      a
  } deriving (Eq, Ord, Show)

file0 ::
  FilePath
  -> String
  -> File0
file0 p s =
  File p s ()

instance Functor File where
  fmap f (File p s a) =
    File p s (f a)

type File0 =
  File ()

makeClassy ''File
