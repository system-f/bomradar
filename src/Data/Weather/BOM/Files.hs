{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
-- See https://github.com/haskell/haddock/issues/565
{-# OPTIONS_HADDOCK prune #-}

module Data.Weather.BOM.Files where

import Control.Lens
import Data.Weather.BOM.File

data Files a b =
  Files {
    _filelist ::
      [File a]
  , _files_data ::
      b
  } deriving (Eq, Ord, Show)
  
files0 ::
  [File a]
  -> Files0 a
files0 x =
  Files x ()

type Files0 a =
  Files a ()

instance Functor (Files a) where
  fmap f (Files a b) =
    Files a (f b)

instance Monoid b => Monoid (Files a b) where
  Files a1 b1 `mappend` Files a2 b2 =
    Files
      (a1 `mappend` a2)
      (b1 `mappend` b2)
  mempty =
    Files
      mempty
      mempty

makeClassy ''Files
