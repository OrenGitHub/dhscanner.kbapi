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
import qualified Content

data Query
   = ConstStringsMatching Content.ConstStringsMatching
   | HttpGetHandlerRequestObject Content.HttpGetHandlerRequestObject
   | HttpPostHandlerRequestObject Content.HttpPostHandlerRequestObject
   | CommentsInFunction Content.CommentsInFunction
   | WriteContentToLocalFile Content.WriteContentToLocalFile
   | ControlFlowPath Content.ControlFlowPath
   | DataFlowPath Content.DataFlowPath
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data QueryResult
   = FoundConstStringsMatching Content.FoundConstStringsMatching
   | FoundHttpGetHandlerRequestObject Content.FoundHttpGetHandlerRequestObject
   | FoundHttpPostHandlerRequestObject Content.FoundHttpPostHandlerRequestObject
   | FoundCommentsInFunction Content.FoundCommentsInFunction
   | FoundWriteContentToLocalFile Content.FoundWriteContentToLocalFile
   | FoundControlFlowPath Content.FoundControlFlowPath
   | FoundDataFlowPath Content.FoundDataFlowPath
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
