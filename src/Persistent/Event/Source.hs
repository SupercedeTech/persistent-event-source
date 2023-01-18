module Persistent.Event.Source
  ( handleCmdWithAuthor
  , applyEventsSince
  , module X
  )
where

import Persistent.Event.Source.Projection as X
import Persistent.Event.Source.Aggregate as X
import Persistent.Event.Source.EventStore as X
import Database.Persist.Monad(MonadSqlQuery)
import Database.Persist.Class.PersistEntity
import Control.Monad.IO.Unlift
import Control.Monad.Logger
import Data.Foldable

-- TODO: handle potential concurrency problems, catch errors from invalid commands
-- | Executes command and applies events, as well as storing them, aka `transact` or `actAndApply`
handleCmdWithAuthor :: ( Aggregate a, EventStore a, MonadUnliftIO m, MonadSqlQuery m, MonadLogger m) =>
  Maybe (Actor a) -> Command a -> m [Entity (Event a)]
handleCmdWithAuthor mAuthorId cmd = do
  events <- act mAuthorId cmd
  traverse_ apply events
  eventIds <- storeMany events
  markEventsApplied eventIds
  pure $ zipWith Entity eventIds events

applyEventsSince :: (EventStore a, MonadUnliftIO m, MonadSqlQuery m, MonadLogger m) => Maybe (Key (Event a)) -> m ()
applyEventsSince lastEventId = do
  events <- loadUnappliedEvents lastEventId
  traverse_ (apply . entityVal) events
  markEventsApplied $ entityKey <$> events
