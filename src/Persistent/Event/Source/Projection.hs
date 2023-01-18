{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilyDependencies #-}
module Persistent.Event.Source.Projection where

import Database.Persist.Monad
import Control.Monad.IO.Unlift
import Control.Monad.Logger

class Projection a where
  type Event a = ev | ev -> a

  -- Apply event to this context
  -- Intended to have write access to the database for updating views
  apply :: (MonadUnliftIO m, MonadLogger m, MonadSqlQuery m) => Event a -> m ()
