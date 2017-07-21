{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Data.Weather.BOM.ConfigurationT where

import Control.Lens hiding ((<.>))
import Control.Monad.IO.Class
import Control.Monad.Reader.Class
import Control.Monad.Trans.Class
import Control.Monad.Trans.Except
import System.Directory
import System.FilePath hiding ((<.>))

data ConfigurationT f a =
  ConfigurationT (String -> String -> Bool -> FilePath -> f a)

runConfigurationT ::
  ConfigurationT f a
  -> String -- radar
  -> String -- delay
  -> Bool -- download/composite transparencies
  -> FilePath -- outdir
  -> f a
runConfigurationT (ConfigurationT k) =
  k

radarConfiguration ::
  (String -> f a)
  -> ConfigurationT f a
radarConfiguration r =
  ConfigurationT (const . const . const . r)

delayConfiguration ::
  (String -> f a)
  -> ConfigurationT f a
delayConfiguration r =
  ConfigurationT (const (const . const . r))

doTransparenciesConfiguration ::
  (Bool -> f a)
  -> ConfigurationT f a
doTransparenciesConfiguration r =
  ConfigurationT (const (const (const . r)))

outdirConfiguration ::
  (String -> f a)
  -> ConfigurationT f a
outdirConfiguration =
  ConfigurationT . const . const . const
  
instance Functor f => Functor (ConfigurationT f) where
  fmap f (ConfigurationT k) =
    ConfigurationT (\s d y h -> fmap f (k s d y h))

instance Applicative f => Applicative (ConfigurationT f) where
  pure =
    ConfigurationT . const . const . const . const . pure
  ConfigurationT f <*> ConfigurationT a =
    ConfigurationT (\s d y h -> f s d y h <*> a s d y h)

instance Monad f => Monad (ConfigurationT f) where
  return =
    ConfigurationT . const . const . const . const . return
  ConfigurationT k >>= f =
    ConfigurationT (\s d y h -> k s d y h >>= \a -> runConfigurationT (f a) s d y h)

instance MonadTrans ConfigurationT where
  lift =
    ConfigurationT . const . const . const . const

instance Monad f => MonadReader (String, String, Bool, FilePath) (ConfigurationT f) where
  ask =
    ConfigurationT (\s d y h -> pure (s, d, y, h))
  local f (ConfigurationT k) = 
    ConfigurationT (\s d y h -> let (t, e, z, i) = f (s, d, y, h) in k t e z i)

instance MonadIO f => MonadIO (ConfigurationT f) where
  liftIO =
    ConfigurationT . const . const . const . const . liftIO

intoConfiguration ::
  Functor f =>
  f a
  -> ConfigurationT (ExceptT e f) a
intoConfiguration =
  ConfigurationT . const . const . const . const . ExceptT . (<$>) Right

getRadar ::
  Monad f =>
  ConfigurationT f String
getRadar =
  (^. _1) <$> ask

getDelay ::
  Monad f =>
  ConfigurationT f String
getDelay =
  (^. _2) <$> ask

getDoTransparencies ::
  Monad f =>
  ConfigurationT f Bool
getDoTransparencies =
  (^. _3) <$> ask
getOutputDirectory ::
  Monad f =>
  ConfigurationT f FilePath
getOutputDirectory =
  (^. _4) <$> ask

(</.>) ::
  Monad f =>
  ConfigurationT f FilePath
  -> FilePath
  -> ConfigurationT f FilePath
(</.>) o p =
  (</> p) <$> o

infixl 5 </.>

mkdir ::
  MonadIO f =>
  ConfigurationT f FilePath
  -> ConfigurationT f FilePath
mkdir x =
  do  d <- x
      liftIO (createDirectoryIfMissing True d)
      pure d
