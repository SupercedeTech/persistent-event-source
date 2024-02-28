{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilyDependencies #-}

module Persistent.EventSource.EventStore where

import Control.Monad.IO.Unlift
import Database.Persist.Class.PersistEntity
import Database.Persist.Sql (SqlPersistT)
import Persistent.EventSource.Projection

-- | Determines how events are stored and retrieved.
class Projection a => EventStore a where

  storeMany :: MonadIO m => [Event a] -> SqlPersistT m [Key (Event a)]

  -- | Nothing if no last applied event found.
  getLastAppliedEventId :: MonadIO m => SqlPersistT m (Maybe (Key (Event a)))

  markEventsApplied :: MonadIO m => [Key (Event a)] -> SqlPersistT m ()

  -- | Will load all events on nothing
  loadUnappliedEvents :: MonadIO m => Maybe (Key (Event a)) -> SqlPersistT m [Entity (Event a)]

