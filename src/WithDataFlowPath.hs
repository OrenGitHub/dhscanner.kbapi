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

-- |
--
-- * The path visits locations from 'from' ( first ) to 'to' ( last ).
--
-- * When 'to' writes to a database and the path reaches the value of
--   one of its columns, the knowledge base says which model and column
--   the value is stored in ( 'DbWriteDataFlowPath' ), e.g.
--   @Post::where( 'id', $id )->update( [ 'title' => $title ] )@
--   stores @$title@ in model @Post@, column @title@.
--
data Content
   = NoDataFlowPath
   | PlainDataFlowPath PlainDataFlowContent
   | DbWriteDataFlowPath DBWriteDataFlowContent
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data PlainDataFlowContent
   = PlainDataFlowContent
     {
         plainDataFlowPath :: [ Location ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data DBWriteDataFlowContent
   = DBWriteDataFlowContent
     {
         model :: Model,
         column :: Column,
         dbWriteDataFlowPath :: [ Location ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data Model = Model String deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
data Column = Column String deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
