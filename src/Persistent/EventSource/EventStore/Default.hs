{-# LANGUAGE CPP #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE TypeFamilies #-}

module Persistent.EventSource.EventStore.Default where

import Control.Monad
import Control.Monad.IO.Class
import Data.Time
import Database.Esqueleto.Experimental as E
import Database.Persist
#if MIN_VERSION_persistent(2,14,0)
import Database.Persist.Class.PersistEntity(SafeToInsert)
#endif

#if MIN_VERSION_persistent(2,14,0)
defaultStoreMany ::
  ( MonadIO m
  , PersistRecordBackend record SqlBackend
  , SafeToInsert record
  )
  => [record]
  -> SqlPersistT m [Key record]
#else
defaultStoreMany ::
  (MonadIO m, PersistRecordBackend record SqlBackend)
  => [record]
  -> SqlPersistT m [Key record]
#endif
defaultStoreMany = insertMany

defaultGetLastAppliedEventId ::
  ( MonadIO m
  , PersistEntity record
  , PersistEntityBackend record ~ SqlBackend
  )
  => EntityField record typ
  -> (record -> b)
  -> SqlPersistT m (Maybe b)
defaultGetLastAppliedEventId sortField extractId = do
  lastEvent <- selectFirst [] [Desc sortField]
  pure $ extractId . entityVal <$> lastEvent

defaultMarkEventsApplied ::
  ( MonadIO m
  , PersistEntity record
  , PersistEntityBackend record ~ SqlBackend
  )
  => (t -> Key record)
  -> (UTCTime -> t -> record)
  -> [t]
  -> SqlPersistT m ()
defaultMarkEventsApplied toKey toRecord eventIds = do
  appliedEvents <- forM eventIds $ \eventId -> do
    time' <- liftIO getCurrentTime
    pure $ Entity (toKey eventId) $ toRecord time' eventId
  insertEntityMany appliedEvents


defaultLoadUnappliedEvents ::
  ( MonadIO m
  , Traversable t
  , PersistEntity val1
  , PersistEntity val2
  , PersistField a
  )
  => EntityField val1 a
  -> EntityField val2 a
  -> t a
  -> SqlPersistT m [Entity val1]
defaultLoadUnappliedEvents eventId appliedId mapplied = select $ do
  event <- from table
  forM_ mapplied $ \applied ->
    where_ $ event E.^. eventId E.>. val applied
  where_ $ notExists $ do
    applied <- from table
    where_ $ event E.^. eventId E.==. applied E.^. appliedId
  orderBy [asc $ event E.^. eventId]
  pure event
