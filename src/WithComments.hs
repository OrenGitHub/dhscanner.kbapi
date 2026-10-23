{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module WithComments

where

-- general imports
import GHC.Generics
import Data.Aeson

-- project imports
import Location

data Features
   = Features
     {
        inFunction :: Location,
        maxNumComments :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data Content
   = Content
     {
         total :: Word,
         matches :: [ Comment ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data Comment
   = Comment
     {
         commentLocation :: Location,
         commentContent :: String
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
