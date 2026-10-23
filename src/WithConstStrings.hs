{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module WithConstStrings

where

-- general imports
import GHC.Generics
import Data.Aeson

-- project imports
import Location

data Features
   = Features
     {
        matchingRegex :: String,
        maxNumConstStrings :: Word
     }
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
         value :: String
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
