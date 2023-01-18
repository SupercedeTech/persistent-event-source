{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilyDependencies #-}

module Persistent.Event.Source.EventStore where

import Persistent.Event.Source.Projection
import Control.Monad.IO.Unlift
import Database.Persist.Monad(MonadSqlQuery)
import Database.Persist.Class.PersistEntity

-- | Determines how events are stored and retrieved.
class Projection a => EventStore a where

  storeMany :: (MonadIO m, MonadSqlQuery m) => [Event a] -> m [Key (Event a)]

  -- | Nothing if no last applied event found.
  getLastAppliedEventId :: (MonadIO m, MonadSqlQuery m) => m (Maybe (Key (Event a)))

  markEventsApplied :: (MonadIO m, MonadSqlQuery m) => [Key (Event a)] -> m ()

  -- | Will load all events on nothing
  loadUnappliedEvents :: (MonadIO m, MonadSqlQuery m) => Maybe (Key (Event a)) -> m [Entity (Event a)]

