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

-- | Evidence carrier for authenticated-handler classifications.
--
-- Same "one concept, N payload shapes" tagged-union pattern that
-- 'Kbapi.Query' itself uses. Each constructor names a distinct
-- structural recognition path in the KB and carries whatever
-- payload that path can bind. New auth mechanisms are pure leaf
-- additions here : add a constructor + a matching Prolog clause
-- + one line in the queryengine decoder \- no existing consumer
-- changes.
--
-- Current constructors :
--
-- * @ByHeaderNullCheck HeaderKey@ \- the authenticating function
--   implements the strict @Request.headers.get( key ) ; if(!v)
--   return null@ idiom. @HeaderKey@ is the header name string
--   ( e.g. @\"x-api-key\"@ ). Bound by the KB rule
--   @utils_early_return_null_on_missing_request_header_value@.
--
-- * @ByAllButOneBadReturn@ \- the authenticating function's body
--   shape is "K-1 bad-http returns + 1 parser-injected fall-through"
--   (e.g. formbricks @checkAuth@ : returns
--   @responses.notAuthenticatedResponse()@ /
--   @responses.unauthorizedResponse()@ in every failure path and
--   falls through on success). No payload \- the evidence /is/ the
--   shape, and the callable\'s name is already carried by
--   @foundAuthenticatedHttpPostHandlerAuthenticatingFunctionName@
--   ( or its GET twin ) on the enclosing match record.
data AuthEvidence
   = ByHeaderNullCheck String
   | ByAllButOneBadReturn
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | A match for an authenticated POST handler request object query.
--
-- Same shape as 'FoundHttpPostHandlerRequestObjectMatch', plus two
-- structurally discovered pieces of metadata that identify /how/ the
-- handler is authenticated :
--
-- * @foundAuthenticatedHttpPostHandlerAuthenticatingFunctionName@ \-
--   the name of the callable that gates the handler ( e.g. tier-1
--   catalog name @\'authenticateRequest\'@, or @\'checkAuth\'@ when
--   the shape catalog fires ).
--
-- * @foundAuthenticatedHttpPostHandlerAuthEvidence@ \-
--   an 'AuthEvidence' tagged union describing /which/ structural
--   recognition path bound this match, plus any mechanism-specific
--   payload ( e.g. the header key for @ByHeaderNullCheck@ ). See the
--   'AuthEvidence' haddock for the current constructors.
data FoundAuthenticatedHttpPostHandlerRequestObjectMatch
   = FoundAuthenticatedHttpPostHandlerRequestObjectMatch
     {
         foundAuthenticatedHttpPostHandlerLocation :: Location,
         foundAuthenticatedHttpPostHandlerRequestObjectLocation :: Location,
         foundAuthenticatedHttpPostHandlerRequestObjectMatchUrl :: String,
         foundAuthenticatedHttpPostHandlerAuthenticatingFunctionName :: String,
         foundAuthenticatedHttpPostHandlerAuthEvidence :: AuthEvidence
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

-- | Symmetric GET variant of 'UnauthenticatedHttpPostHandlerRequestObject'.
-- Enumerates HTTP GET handlers whose bodies contain /no/ call to any
-- recognized authenticating function (per the Prolog predicate
-- @utils_unauthenticated_http_get_handler_request_object/3@ ).
--
-- Together with 'AuthenticatedHttpGetHandlerRequestObject' this is the
-- GET half of the "first fork" the LLM agent hits : auth vs pre-auth
-- endpoints. See the OWASP-IL 2026 talk notes ("first move" bridge
-- slide) for the harness-side story.
data UnauthenticatedHttpGetHandlerRequestObject
   = UnauthenticatedHttpGetHandlerRequestObject
     {
         unauthenticatedHttpGetHandlerRequestObjectUrlParts :: [ String ],
         unauthenticatedHttpGetHandlerRequestObjectLimit :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | Result payload for 'UnauthenticatedHttpGetHandlerRequestObject'. The
-- per-match shape reuses 'FoundHttpGetHandlerRequestObjectMatch' because
-- an unauthenticated GET handler carries no auth metadata to surface --
-- symmetric to how 'FoundUnauthenticatedHttpPostHandlerRequestObject'
-- reuses 'FoundHttpPostHandlerRequestObjectMatch'.
data FoundUnauthenticatedHttpGetHandlerRequestObject
   = FoundUnauthenticatedHttpGetHandlerRequestObject
     {
         foundUnauthenticatedHttpGetHandlerRequestObjectTotal :: Word,
         foundUnauthenticatedHttpGetHandlerRequestObjectMatches :: [ FoundHttpGetHandlerRequestObjectMatch ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | Symmetric GET variant of 'AuthenticatedHttpPostHandlerRequestObject'.
-- Enumerates HTTP GET handlers whose bodies contain a call to a
-- recognized authenticating function that itself satisfies the strict
-- "early-return-null on missing request-header value" structural gate.
-- See @utils_authenticated_http_get_handler_request_object/5@ in
-- utils.pl and the Prolog-side notes on the corresponding POST /5
-- predicate.
data AuthenticatedHttpGetHandlerRequestObject
   = AuthenticatedHttpGetHandlerRequestObject
     {
         authenticatedHttpGetHandlerRequestObjectUrlParts :: [ String ],
         authenticatedHttpGetHandlerRequestObjectLimit :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FoundAuthenticatedHttpGetHandlerRequestObject
   = FoundAuthenticatedHttpGetHandlerRequestObject
     {
         foundAuthenticatedHttpGetHandlerRequestObjectTotal :: Word,
         foundAuthenticatedHttpGetHandlerRequestObjectMatches :: [ FoundAuthenticatedHttpGetHandlerRequestObjectMatch ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | A match for an authenticated GET handler request object query. Same
-- shape as 'FoundAuthenticatedHttpPostHandlerRequestObjectMatch', with
-- @GetHandler@ substituted for @PostHandler@ throughout the field
-- naming to keep POST/GET results distinguishable at the JSON layer.
data FoundAuthenticatedHttpGetHandlerRequestObjectMatch
   = FoundAuthenticatedHttpGetHandlerRequestObjectMatch
     {
         foundAuthenticatedHttpGetHandlerLocation :: Location,
         foundAuthenticatedHttpGetHandlerRequestObjectLocation :: Location,
         foundAuthenticatedHttpGetHandlerRequestObjectMatchUrl :: String,
         foundAuthenticatedHttpGetHandlerAuthenticatingFunctionName :: String,
         foundAuthenticatedHttpGetHandlerAuthEvidence :: AuthEvidence
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
