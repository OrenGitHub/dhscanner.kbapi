-- |
--
-- This package defines the API for the /knowledge base/ used by [dhscanner](https://dhscanner.org/docs/).
--
-- * Documentation is intended for both humans🚶and LLM agents 🤖.
--
-- * In this context, a knowledge base is a structured collection of /code facts/.
--    
-- * Code facts form an /abstraction layer/ over a /data representation/.
--
-- Data representations come in /many/ forms, for example:
--
-- * Graph databases
-- * Relational databases
-- * Logic programs
-- * Datalog programs
--
-- The design aims to /decouple/ (as much as possible) the layers:
--
-- * Data representation
-- * Code facts abstraction
-- * Knowledge base API
--
-- For instance, migrating from a graph database to a logic program representation
--
-- * conceptually straightforward
--
-- As another example, changes to the knowledge base API
--
-- * ideally do not require fundamental modifications of code facts
--
-- ==== Learn more 💡
--
-- For a detailed explanation of code facts and how they are generated,
-- see [dhscanner-kbgen](https://hackage.haskell.org/package/dhscanner-kbgen)
-- on [Hackage](https://hackage.haskell.org/).


{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Kbapi

where

-- general imports
import Data.Aeson
import GHC.Generics

-- project imports
import qualified WithHttpHandlers
import qualified WithControlFlowReachableSinks
import qualified WithDataFlowPath
import qualified WithConstStrings
import qualified WithComments
import qualified WithSanitizers

data Query
   = SelectHttpHandlers WithHttpHandlers.Features
   | SelectControlFlowReachableSinks WithControlFlowReachableSinks.Features
   | SelectDataFlowPath WithDataFlowPath.Features
   | SelectConstStrings WithConstStrings.Features
   | SelectComments WithComments.Features
   | SelectSanitizers WithSanitizers.Features
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data QueryResult
   = FoundHttpHandlers WithHttpHandlers.Content
   | FoundControlFlowReachableSinks WithControlFlowReachableSinks.Content
   | FoundConstStringsMatching WithConstStrings.Content
   | FoundCommentsInFunction WithComments.Content
   | FoundDataFlowPath WithDataFlowPath.Content
   | FoundSanitizers WithSanitizers.Content
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
