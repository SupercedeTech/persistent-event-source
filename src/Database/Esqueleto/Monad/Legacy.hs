{-# LANGUAGE FlexibleContexts #-}

-- | Classy shim around @Database.Esqueleto.Legacy@
--
-- In the style of @Database.Persist.Monad@, this exposes a "classy"
-- (typeclass-using) API for Esqueleto functions, allowing them to be
-- used with 'MonadSqlQuery' constraints rather than a
-- @'ReaderT' 'SqlBackend'@ concrete type.
--
-- The goal of this module is to be a drop-in replacement for
-- @Database.Esqueleto.Legacy@.
module Database.Esqueleto.Monad.Legacy
  ( select
  , selectOne
  , delete
  , update
  , renderQuerySelect
  , P.deleteWhere
  , P.get
  , P.getBy
  , P.getEntity
  , P.getMany
  , P.insert
  , P.insert_
  , P.insertKey
  , P.insertMany_
  , P.insertEntityMany
  , P.selectFirst
  , P.updateWhere
  , module Database.Esqueleto.Legacy
  ) where

import Data.Text(Text)
import Database.Esqueleto.Internal.Internal (SqlSelect)
import qualified Database.Esqueleto.Legacy as E
import Database.Esqueleto.Legacy hiding
  ( select
  , selectOne
  , delete
  , update
  , renderQuerySelect

  -- Persistent re-exports
  , deleteWhere
  , get
  , getBy
  , getEntity
  , getMany
  , insert
  , insert_
  , insertKey
  , insertMany_
  , insertEntityMany
  , selectFirst
  , updateWhere
  )
import qualified Database.Persist.Monad as P

-- | Classy version of 'E.select'
select :: (P.MonadSqlQuery m, SqlSelect a r) => SqlQuery a -> m [r]
select query = P.unsafeLiftSql "esqueleto-select" (E.select query)

-- | Classy version of 'E.selectOne'
selectOne :: (P.MonadSqlQuery m, SqlSelect a r) => SqlQuery a -> m (Maybe r)
selectOne query = P.unsafeLiftSql "esqueleto-selectOne" (E.selectOne query)

-- | Classy version of 'E.delete'
delete :: (P.MonadSqlQuery m) => SqlQuery () -> m ()
delete query = P.unsafeLiftSql "esqueleto-delete" (E.delete query)

-- | Classy version of 'E.update'
update ::
     ( P.MonadSqlQuery m
     , PersistEntity val
     , BackendCompatible SqlBackend (PersistEntityBackend val)
     )
  => (SqlExpr (Entity val) -> SqlQuery ()) -> m ()
update query = P.unsafeLiftSql "esqueleto-update" (E.update query)

renderQuerySelect :: (P.MonadSqlQuery m, SqlSelect a r) => SqlQuery a -> m (Text, [PersistValue])
renderQuerySelect query = P.unsafeLiftSql "esqueleto-renderQuerySelect" (E.renderQuerySelect query)
