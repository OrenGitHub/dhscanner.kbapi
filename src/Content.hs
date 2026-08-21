{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Content

where

-- general imports
import GHC.Generics
import Data.Aeson
-- project imports
import Location

data ConstStringsMatching
   = ConstStringsMatching
     {
         constStringsMatchingThisRegex :: String,
         constStringsMatchingLimit :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FoundConstStringsMatching
   = FoundConstStringsMatching
     {
         foundConstStringsMatchingThisRegex :: String,
         foundConstStringsMatchesTotal :: Word,
         foundConstStringsMatches :: [ FoundConstStringMatch ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FoundConstStringMatch
   = FoundConstStringMatch
     {
         foundConstStringMatchLocation :: Location,
         foundConstStringMatchValue :: String
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data UnauthenticatedHttpPostHandlerRequestObject
   = UnauthenticatedHttpPostHandlerRequestObject
     {
         unauthenticatedHttpPostHandlerRequestObjectUrlParts :: [ String ],
         unauthenticatedHttpPostHandlerRequestObjectLimit :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FoundUnauthenticatedHttpPostHandlerRequestObject
   = FoundUnauthenticatedHttpPostHandlerRequestObject
     {
         foundUnauthenticatedHttpPostHandlerRequestObjectTotal :: Word,
         foundUnauthenticatedHttpPostHandlerRequestObjectMatches :: [ FoundHttpPostHandlerRequestObjectMatch ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data AuthenticatedHttpPostHandlerRequestObject
   = AuthenticatedHttpPostHandlerRequestObject
     {
         authenticatedHttpPostHandlerRequestObjectUrlParts :: [ String ],
         authenticatedHttpPostHandlerRequestObjectLimit :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FoundAuthenticatedHttpPostHandlerRequestObject
   = FoundAuthenticatedHttpPostHandlerRequestObject
     {
         foundAuthenticatedHttpPostHandlerRequestObjectTotal :: Word,
         foundAuthenticatedHttpPostHandlerRequestObjectMatches :: [ FoundAuthenticatedHttpPostHandlerRequestObjectMatch ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | A match for an authenticated POST handler request object query.
--
-- Same shape as 'FoundHttpPostHandlerRequestObjectMatch', plus two
-- structurally discovered pieces of metadata that identify /how/ the
-- handler is authenticated :
--
-- * @foundAuthenticatedHttpPostHandlerAuthenticatingFunctionName@ \-
--   the name of the callable that gates the handler ( e.g. tier-1
--   catalog name @\'authenticateRequest\'@ ).
--
-- * @foundAuthenticatedHttpPostHandlerHeaderKeyName@ \-
--   the string constant passed to @Request.headers.get( ... )@ inside
--   that authenticating function ( e.g. @\'x-api-key\'@ ). Bound by
--   the KB rule @utils_early_return_null_on_missing_request_header_value@.
--   Intentionally /not/ named @ApiKey...@ \- other authentication styles
--   ( bearer tokens, session cookies, custom headers ) all end up
--   reading a header key too, so the field stays neutral.
data FoundAuthenticatedHttpPostHandlerRequestObjectMatch
   = FoundAuthenticatedHttpPostHandlerRequestObjectMatch
     {
         foundAuthenticatedHttpPostHandlerLocation :: Location,
         foundAuthenticatedHttpPostHandlerRequestObjectLocation :: Location,
         foundAuthenticatedHttpPostHandlerRequestObjectMatchUrl :: String,
         foundAuthenticatedHttpPostHandlerAuthenticatingFunctionName :: String,
         foundAuthenticatedHttpPostHandlerHeaderKeyName :: String
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FoundHttpPostHandlerRequestObjectMatch
   = FoundHttpPostHandlerRequestObjectMatch
     {
         foundHttpPostHandlerLocation :: Location,
         foundHttpPostHandlerRequestObjectLocation :: Location,
         foundHttpPostHandlerRequestObjectMatchUrl :: String
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data HttpGetHandlerRequestObject
   = HttpGetHandlerRequestObject
     {
         httpGetHandlerRequestObjectUrlParts :: [ String ],
         httpGetHandlerRequestObjectLimit :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FoundHttpGetHandlerRequestObject
   = FoundHttpGetHandlerRequestObject
     {
         foundHttpGetHandlerRequestObjectTotal :: Word,
         foundHttpGetHandlerRequestObjectMatches :: [ FoundHttpGetHandlerRequestObjectMatch ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FoundHttpGetHandlerRequestObjectMatch
   = FoundHttpGetHandlerRequestObjectMatch
     {
         foundHttpGetHandlerLocation :: Location,
         foundHttpGetHandlerRequestObjectMatchLocation :: Location,
         foundHttpGetHandlerRequestObjectMatchUrl :: String
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data CommentsInFunction
   = CommentsInFunction
     {
         commentsInFunctionLocation :: Location,
         commentsInFunctionLimit :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FoundCommentsInFunction
   = FoundCommentsInFunction
     {
         foundCommentsInFunctionLocation :: Location,
         foundCommentsInFunctionTotal :: Word,
         foundCommentsInFunctionComments :: [ Comment ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data Comment
   = Comment
     {
         commentLocation :: Location,
         commentContent :: String
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data WriteContentToLocalFile
   = WriteContentToLocalFile
     {
         writeContentToLocalFileLimit :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FoundWriteContentToLocalFile
   = FoundWriteContentToLocalFile
     {
         foundWriteContentToLocalFileTotal :: Word,
         foundWriteContentToLocalFileLocations :: [ Location ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data ControlFlowPath
   = ControlFlowPath
     {
         controlFlowPathCaller :: Location,
         controlFlowPathCallee :: Location,
         controlFlowPathLimitNumHops :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FoundControlFlowPath
   = FoundControlFlowPath
     {
         foundControlFlowPathPath :: Maybe [ Location ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data DataFlowPath
   = DataFlowPath
     {
         dataFlowPathFrom :: Location,
         dataFlowPathTo :: Location,
         dataFlowPathLimitLength :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FoundDataFlowPath
   = FoundDataFlowPath
     {
         foundDataFlowPathPath :: Maybe [ Location ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
