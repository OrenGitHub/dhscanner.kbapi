{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module WithControlFlowReachableSinks

where

-- general imports
import GHC.Generics
import Data.Aeson
import Data.Set ( Set )

-- project imports
import Location

data Features
   = Features
     {
        from :: Location,
        sinks :: Set Sink,
        maxNumHops :: Word,
        maxNumSinks :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data Sink
   = FileOperationRead
   | FileOperationWrite
   | FileOperationDelete
   | OpenRedirect
   | SSRF
   | SQL
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data Content
   = Content
     {
        total :: Word,
        matches :: [ Match ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data Match
   = Match
     {
        location :: Location,
        qualifiedName :: String,
        kind :: Sink
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
