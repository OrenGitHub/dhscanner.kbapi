{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Common

where

-- general imports
import GHC.Generics
import Data.Aeson

-- | A 1st party database model, by its class name ( e.g. @Post@ ).
data Model = Model String deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
-- | A column of a 'Model', by its name ( e.g. @title@ ).
data Column = Column String deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
