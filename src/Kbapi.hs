-- |
--
-- * The [abstract ayntax tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree) ( ast )
--   aims to be a data structure able to:
--
--     * represent /multiple/ ( native ) ast kinds
--     * from /various/ programming languages
--

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
