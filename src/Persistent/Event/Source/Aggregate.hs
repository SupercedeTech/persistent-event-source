{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilyDependencies #-}

module Persistent.Event.Source.Aggregate where

import Database.Persist.Monad (MonadSqlQuery)
import Persistent.Event.Source.Projection
import Control.Monad.IO.Class

class Projection a => Aggregate a where
  type Command a = cmd | cmd -> a
  type Actor a = user | user -> a

  -- Validate action and generate events, if any.
  -- TODO: handle invalid actions
  act :: ( MonadSqlQuery m, MonadIO m ) =>
         Maybe (Actor a) -> Command a -> m [Event a]
