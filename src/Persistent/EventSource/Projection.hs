{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilyDependencies #-}

module Persistent.EventSource.Projection where

import Database.Persist.Sql (SqlPersistT)
import Control.Monad.IO.Unlift (MonadUnliftIO)
import Control.Monad.Logger (MonadLogger)

-- | Projection is about setting your event sourced table to
--   data in the event.
class Projection a where
  type Event a = ev | ev -> a

  -- | Apply event to this context
  -- Intended to have write access to the database for updating views
  apply :: (MonadUnliftIO m, MonadLogger m) => Event a -> SqlPersistT m ()
