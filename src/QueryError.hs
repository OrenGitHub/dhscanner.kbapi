{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

-- |
--
-- * The ways a valid 'Kbapi.Query' can fail to produce a 'Kbapi.QueryResult'.
--
-- * An empty answer is /not/ an error : no path, no match, no sink are
--   all 'Kbapi.QueryResult's.
--
-- * A request that is not a valid 'Kbapi.Query' is rejected before it
--   is run, and is not a 'QueryError' either.
--
-- * Each details field is free text, written by the query engine for
--   a human ( or an LLM ) to read : branch on the constructor, never on
--   the text.
--
module QueryError

where

-- general imports
import GHC.Generics
import Data.Aeson

data QueryError
   = Timeout TimeoutContent
   | KBNotFound KBNotFoundContent
   | BackendInfraProblems BackendInfraProblemsContent
   | KBSearchToolNotFound KBSearchToolNotFoundContent
   | KBResponseInvalidSyntax KBResponseInvalidSyntaxContent
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | The HTTP status code a 'QueryError' is returned with.
--
-- One clause per constructor, no wildcard : a new constructor without
-- a code is a compile error ( @-Werror=incomplete-patterns@ ).
httpResponseCodeOf :: QueryError -> Word
httpResponseCodeOf (Timeout _)                 = 504
httpResponseCodeOf (KBNotFound _)              = 404
httpResponseCodeOf (BackendInfraProblems _)    = 500
httpResponseCodeOf (KBSearchToolNotFound _)    = 500
httpResponseCodeOf (KBResponseInvalidSyntax _) = 500

-- | The query did not finish within its time limit.
data TimeoutContent
   = TimeoutContent
     {
         timeoutDetails :: String
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | No knowledge base was found at the requested location.
data KBNotFoundContent
   = KBNotFoundContent
     {
         kbNotFoundDetails :: String
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | The search over the knowledge base started, but failed while running.
data BackendInfraProblemsContent
   = BackendInfraProblemsContent
     {
         backendInfraProblemsDetails :: String
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | The tool that searches the knowledge base could not be started.
data KBSearchToolNotFoundContent
   = KBSearchToolNotFoundContent
     {
         kbSearchToolNotFoundDetails :: String
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | The search finished, but its answer could not be read back.
data KBResponseInvalidSyntaxContent
   = KBResponseInvalidSyntaxContent
     {
         kbResponseInvalidSyntaxDetails :: String
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
