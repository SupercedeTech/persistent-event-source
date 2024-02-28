{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilyDependencies #-}

module Persistent.EventSource.Aggregate where

import Control.Monad.IO.Class
import Database.Persist.Sql (SqlPersistT)
import Persistent.EventSource.Projection

-- | Aggregate is an intermediate step, allowing you to specify how
--   your changeable commands are stored.
--   stored events should be stable like an API.
class Projection a => Aggregate a where
  -- | The command is a sumtype with all your possible event sourced
  --   actions.
  type Command a = cmd | cmd -> a

  -- | allows you to specify who executed a command.
  --   for audit purposes. set this to `()` if you don't care about this.
  type Actor a

  -- TODO: handle invalid actions
  -- | Validate action and generate events, if any.
  act :: MonadIO m => Maybe (Actor a) -> Command a -> SqlPersistT m [Event a]
