{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE CPP #-}

module Persistent.EventSource.EventStore.Default where

import qualified Database.Esqueleto.Monad.Experimental as Ex
import Database.Persist.Monad.Class
import Database.Persist.Monad
import Data.Dynamic
import Data.Time
import Control.Monad.IO.Class
import Control.Monad
import Database.Persist.Class(EntityField, PersistField, PersistEntity, PersistEntityBackend, PersistRecordBackend)
import Database.Persist.Class.PersistEntity(Entity(..), Key, SelectOpt(..))
#if MIN_VERSION_persistent(2,14,0)
import Database.Persist.Class.PersistEntity(SafeToInsert)
#endif
import Database.Persist.Sql(SqlBackend)

#if MIN_VERSION_persistent(2,14,0)
defaultStoreMany :: (PersistRecordBackend record SqlBackend, Typeable record, MonadSqlQuery m, SafeToInsert record) => [record] -> m [Key record]
#else
defaultStoreMany :: (PersistRecordBackend record SqlBackend, Typeable record, MonadSqlQuery m) => [record] -> m [Key record]
#endif
defaultStoreMany = insertMany

defaultGetLastAppliedEventId :: (PersistEntity record, Typeable record,
                             MonadSqlQuery m,
                             PersistEntityBackend record ~ SqlBackend) =>
                            EntityField record typ -> (record -> b) -> m (Maybe b)
defaultGetLastAppliedEventId sortField extractId = do
    lastEvent <- selectFirst [] [Desc sortField]
    pure $ (extractId . entityVal) <$> lastEvent

defaultMarkEventsApplied :: (MonadIO m, PersistEntity record,
                                   Typeable record,
                                    MonadSqlQuery m,
                                   PersistEntityBackend record ~ SqlBackend) =>
                                  (t -> Key record) -> (UTCTime -> t -> record) -> [t] -> m ()
defaultMarkEventsApplied toKey toRecord eventIds = do
    appliedEvents <- forM eventIds $ \eventId -> do
      time' <- liftIO getCurrentTime
      pure $ Entity (toKey eventId) $ toRecord time' eventId
    insertEntityMany appliedEvents


defaultLoadUnappliedEvents :: (Traversable t,
                    MonadSqlQuery m,
              PersistEntity val1, PersistEntity val2,
              PersistField a) =>
             EntityField val1 a -> EntityField val2 a -> t a -> m [Entity val1]
defaultLoadUnappliedEvents eventId appliedId mapplied = do
    Ex.select $ do
          event <- Ex.from $ Ex.table
          void $ forM mapplied $ \applied ->
            Ex.where_ $ event Ex.^. eventId Ex.>. Ex.val applied
          Ex.where_ $ Ex.notExists $ do
            applied <- Ex.from $ Ex.table
            Ex.where_ $ event Ex.^. eventId Ex.==. applied Ex.^. appliedId
          Ex.orderBy
            [ Ex.asc $ event Ex.^. eventId
            ]
          pure event
