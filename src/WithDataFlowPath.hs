{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module WithDataFlowPath

where

-- general imports
import GHC.Generics
import Data.Aeson

-- project imports
import Location

data Features
   = Features
     {
        from :: Location,
        to :: Location,
        maxNumIntraProceduralEdges :: Word,
        maxNumInterProceduralEdges :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data Content
   = Content
     {
         path :: Maybe [ Location ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
