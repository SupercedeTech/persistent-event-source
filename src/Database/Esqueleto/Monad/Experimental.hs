-- | Classy shim around @Database.Esqueleto.Experimental@
--
-- In the style of @Database.Persist.Monad@, this exposes a "classy"
-- (typeclass-using) API for Esqueleto functions, allowing them to be
-- used with 'MonadSqlQuery' constraints rather than a
-- @'ReaderT' 'SqlBackend'@ concrete type.
--
-- The goal of this module is to be a drop-in replacement for
-- @Database.Esqueleto.Experimental@.
module Database.Esqueleto.Monad.Experimental
  ( module Database.Esqueleto.Monad.Legacy
  , module Database.Esqueleto.Experimental
  ) where

import Database.Esqueleto.Monad.Legacy hiding
  ( From
  , from
  , on
  )
import Database.Esqueleto.Experimental hiding
  ( select
  , selectOne
  , delete
  , update
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
  , renderQuerySelect
  )
