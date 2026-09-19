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
--   shape is "K-1 bad-http returns + 1 parser-injected fall-through" :
--   every failing path emits an error response, the single success
--   path falls through implicitly. No payload \- the evidence /is/
--   the shape, and the callable\'s name is already carried by
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

-- | Symmetric PUT variant of 'UnauthenticatedHttpPostHandlerRequestObject'.
-- Enumerates HTTP PUT handlers whose bodies contain /no/ call to any
-- recognized authenticating function.
--
-- Adding any other HTTP verb ( PATCH, DELETE, HEAD, OPTIONS, ... ) is
-- a pure leaf addition : mirror this block, add a new Query
-- constructor + a new KB-side clause + a new queryengine handler.
-- No existing consumer needs to change.
data UnauthenticatedHttpPutHandlerRequestObject
   = UnauthenticatedHttpPutHandlerRequestObject
     {
         unauthenticatedHttpPutHandlerRequestObjectUrlParts :: [ String ],
         unauthenticatedHttpPutHandlerRequestObjectLimit :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | Result payload for 'UnauthenticatedHttpPutHandlerRequestObject'.
-- Reuses 'FoundHttpPutHandlerRequestObjectMatch' because an
-- unauthenticated PUT handler carries no auth metadata to surface --
-- symmetric to how 'FoundUnauthenticatedHttpPostHandlerRequestObject'
-- reuses 'FoundHttpPostHandlerRequestObjectMatch'.
data FoundUnauthenticatedHttpPutHandlerRequestObject
   = FoundUnauthenticatedHttpPutHandlerRequestObject
     {
         foundUnauthenticatedHttpPutHandlerRequestObjectTotal :: Word,
         foundUnauthenticatedHttpPutHandlerRequestObjectMatches :: [ FoundHttpPutHandlerRequestObjectMatch ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | Symmetric PUT variant of 'AuthenticatedHttpPostHandlerRequestObject'.
-- Same @AuthEvidence@ catalog + @AuthFuncName@ metadata as the POST
-- twin; see the POST record's haddock for the tagged-union rationale.
data AuthenticatedHttpPutHandlerRequestObject
   = AuthenticatedHttpPutHandlerRequestObject
     {
         authenticatedHttpPutHandlerRequestObjectUrlParts :: [ String ],
         authenticatedHttpPutHandlerRequestObjectLimit :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FoundAuthenticatedHttpPutHandlerRequestObject
   = FoundAuthenticatedHttpPutHandlerRequestObject
     {
         foundAuthenticatedHttpPutHandlerRequestObjectTotal :: Word,
         foundAuthenticatedHttpPutHandlerRequestObjectMatches :: [ FoundAuthenticatedHttpPutHandlerRequestObjectMatch ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | A match for an authenticated PUT handler request object query. Same
-- shape as 'FoundAuthenticatedHttpPostHandlerRequestObjectMatch', with
-- @PutHandler@ substituted for @PostHandler@ throughout the field
-- naming to keep POST/GET/PUT results distinguishable at the JSON layer.
data FoundAuthenticatedHttpPutHandlerRequestObjectMatch
   = FoundAuthenticatedHttpPutHandlerRequestObjectMatch
     {
         foundAuthenticatedHttpPutHandlerLocation :: Location,
         foundAuthenticatedHttpPutHandlerRequestObjectLocation :: Location,
         foundAuthenticatedHttpPutHandlerRequestObjectMatchUrl :: String,
         foundAuthenticatedHttpPutHandlerAuthenticatingFunctionName :: String,
         foundAuthenticatedHttpPutHandlerAuthEvidence :: AuthEvidence
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | A match for an ( unauthenticated ) PUT handler request object query.
-- Same shape as 'FoundHttpPostHandlerRequestObjectMatch', with
-- @PutHandler@ substituted for @PostHandler@ throughout the field
-- naming to keep POST/PUT results distinguishable at the JSON layer.
data FoundHttpPutHandlerRequestObjectMatch
   = FoundHttpPutHandlerRequestObjectMatch
     {
         foundHttpPutHandlerLocation :: Location,
         foundHttpPutHandlerRequestObjectLocation :: Location,
         foundHttpPutHandlerRequestObjectMatchUrl :: String
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

-- | Enumeration query \- SQL sinks control-flow-reachable from an
-- entry point.
--
-- Coarse tier of the coarse-to-fine reachability pipeline.
-- Control-flow reachability is a /sound over-approximation/ of
-- dataflow reachability under a sound call graph, which makes it
-- suitable as a shortlist \- not as a citation. Callers that need
-- to verify a specific sink is actually reached by attacker-
-- controlled input compose this query with a dataflow-path query
-- on top.
--
-- Enumeration ( sink side free ) rather than verification ( sink
-- side bound ) is a deliberate shape choice : callers almost
-- always want /the set/ of reachable sinks per entry point, not a
-- per-site yes\/no. Per-site verification remains available via
-- 'ControlFlowPath'.
--
-- The result payload carries per-kind sub-totals
-- ( 'SqlSinkKindCount' ) so callers can rank entry points by their
-- sink profile without iterating the matches list.
data ControlFlowReachableSqlSink
   = ControlFlowReachableSqlSink
     {
         controlFlowReachableSqlSinkFrom :: Location,
         controlFlowReachableSqlSinkLimitNumHops :: Word,
         controlFlowReachableSqlSinkLimit :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | Structural classifier for a single SQL sink call site.
--
-- Same \"one concept, N structural paths\" tagged-union pattern as
-- 'AuthEvidence' : each constructor names a distinct sink shape a
-- KB-side recognizer can classify against. Framework-agnostic \-
-- the same two shapes appear across every ORM \/ DB library. The
-- concrete library name ( eg the resolved FQN of the sink call )
-- is carried separately on each match as a plain string ; this
-- classifier abstracts over it.
--
-- Current constructors :
--
-- * @SqlPreparedStatement@ \- the sink parameterizes caller input
--   by construction ( bound parameters, ORM object-form APIs, ... ).
--   Injection-safe under the library's contract ; no additional
--   structural gate needed.
--
-- * @SqlRaw@ \- the sink executes a caller-supplied SQL string.
--   Injection risk lives on the caller ; additional structural
--   gates ( eg proof that all interpolations are bound, or that
--   the string is a compile-time constant ) are needed to clear it.
--
-- Adding a new shape is a pure leaf addition here + a matching
-- KB-side clause. No existing consumer needs to change.
data SqlSinkKind
   = SqlPreparedStatement
   | SqlRaw
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | Per-kind sink count. Present in the enumeration payload as a
-- pre-aggregated ranking signal. Every constructor of 'SqlSinkKind'
-- is expected to appear in the payload's counts list ( zero-filled
-- when absent ) so callers can direct-lookup without existence
-- checks.
data SqlSinkKindCount
   = SqlSinkKindCount
     {
         sqlSinkKindCountKind :: SqlSinkKind,
         sqlSinkKindCountCount :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | Result payload for 'ControlFlowReachableSqlSink'.
--
-- @Total@ is the sum across all kinds ; @CountsByKind@ is the per-kind
-- breakdown ( a pre-aggregated ranking signal ) ; @Matches@ is the
-- flat list of individual sink call sites. Match ordering is
-- implementation-defined \- callers that need a specific ordering
-- should sort client-side on the fields exposed by
-- 'FoundControlFlowReachableSqlSinkMatch'.
data FoundControlFlowReachableSqlSink
   = FoundControlFlowReachableSqlSink
     {
         foundControlFlowReachableSqlSinkTotal :: Word,
         foundControlFlowReachableSqlSinkCountsByKind :: [ SqlSinkKindCount ],
         foundControlFlowReachableSqlSinkMatches :: [ FoundControlFlowReachableSqlSinkMatch ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | A single reachable SQL sink match.
--
-- Fields :
--
-- * @Location@ \- the sink call site. Anchors downstream refinement
--   ( eg a structural clearance predicate or a dataflow query ).
--
-- * @QualifiedName@ \- the fully qualified name of the sink callee
--   as a plain string ( a human-readable label for context ). Do
--   not dispatch on it ; dispatch on @Kind@ so the structural
--   classification stays authoritative. This is the naming
--   convention future kbapi additions should follow for FQN-shaped
--   string fields ; see the OWASP-IL talk notes for the
--   \"Qualified Names\" pedagogical framing.
--
-- * @Kind@ \- structural classifier bound by the KB-side recognizer.
--   See 'SqlSinkKind' for the current catalog.
data FoundControlFlowReachableSqlSinkMatch
   = FoundControlFlowReachableSqlSinkMatch
     {
         foundControlFlowReachableSqlSinkMatchLocation :: Location,
         foundControlFlowReachableSqlSinkMatchQualifiedName :: String,
         foundControlFlowReachableSqlSinkMatchKind :: SqlSinkKind
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | Enumeration query \- file-action sinks control-flow-reachable
-- from an entry point. Symmetric to 'ControlFlowReachableSqlSink' ;
-- see that record for the coarse-to-fine framing.
data ControlFlowReachableFileActionSink
   = ControlFlowReachableFileActionSink
     {
         controlFlowReachableFileActionSinkFrom :: Location,
         controlFlowReachableFileActionSinkLimitNumHops :: Word,
         controlFlowReachableFileActionSinkLimit :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | Structural classifier for a single file-action sink call site.
--
-- Same tagged-union pattern as 'SqlSinkKind' and 'AuthEvidence'.
-- Framework-agnostic \- the same shapes appear across every
-- filesystem API ( Node.js, Python, Go, Ruby, ... ). The concrete
-- library name is carried separately on each match as a plain
-- string ; this classifier abstracts over it.
--
-- Current constructors :
--
-- * @FileWrite@ \- content-writing sinks ( create \/ overwrite \/
--   append file contents ).
--
-- Reserved for future leaf additions :
--
-- * @FileDelete@ \- removal sinks ( unlink \/ rmdir \/ recursive
--   remove ).
data FileActionKind
   = FileWrite
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | Per-kind file-action sink count. Symmetric to 'SqlSinkKindCount'.
data FileActionKindCount
   = FileActionKindCount
     {
         fileActionKindCountKind :: FileActionKind,
         fileActionKindCountCount :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | Result payload for 'ControlFlowReachableFileActionSink'.
-- Symmetric to 'FoundControlFlowReachableSqlSink' ; see that record
-- for the field semantics.
data FoundControlFlowReachableFileActionSink
   = FoundControlFlowReachableFileActionSink
     {
         foundControlFlowReachableFileActionSinkTotal :: Word,
         foundControlFlowReachableFileActionSinkCountsByKind :: [ FileActionKindCount ],
         foundControlFlowReachableFileActionSinkMatches :: [ FoundControlFlowReachableFileActionSinkMatch ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | A single reachable file-action sink match. Symmetric to
-- 'FoundControlFlowReachableSqlSinkMatch' ; see that record for
-- the field semantics.
data FoundControlFlowReachableFileActionSinkMatch
   = FoundControlFlowReachableFileActionSinkMatch
     {
         foundControlFlowReachableFileActionSinkMatchLocation :: Location,
         foundControlFlowReachableFileActionSinkMatchQualifiedName :: String,
         foundControlFlowReachableFileActionSinkMatchKind :: FileActionKind
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
