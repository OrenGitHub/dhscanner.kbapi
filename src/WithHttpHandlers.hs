{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module WithHttpHandlers

where

-- general imports
import GHC.Generics
import Data.Aeson
import Data.Set ( Set )

-- project imports
import Location

data Features
   = Features
     {
        verbs :: Set HttpVerb,
        authentications :: Set AuthFilter,
        routeContainsUrlParts :: Maybe [ String ], -- ^ Nothing = don't filter
        maxNumHttpHandlers :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data HttpVerb = Get | Post | Put | Delete | Patch
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data AuthFilter = Unauthenticated | Authenticated
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data Content
   = Content
     {
         total :: Word,
         matches :: [ HttpHandler ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data HttpHandler
   = HttpHandler
     {
         httpHandlerVerb :: HttpVerb,
         httpHandlerLocation :: Location,
         httpHandlerDef :: HttpHandlerDef,
         httpHandlerUrl :: String,
         httpHandlerUserInputs :: [ UserInput ],
         httpHandlerAuth :: Maybe Authentication
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data HttpHandlerDef
   = MethodOfClass MethodName ClassName
   | NamedFunction FunctionName
   | AnonymousFunction
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data MethodName = MethodName String deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
data ClassName = ClassName String deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
data FunctionName = FunctionName String deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data UserInput
   = RequestObjectCtor RequestObject
   | RequestParamCtor RequestParam
   | PathVariableCtor PathVariable
   | RequestBodyCtor RequestBody
   | RequestHeaderCtor RequestHeader
   | CookieValueCtor CookieValue
   | RequestPartCtor RequestPart
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data RequestObject = RequestObject Location deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data RequestParam
   = RequestParam
     {
         requestParamName :: String,
         requestParamLocation :: Location
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data PathVariable = PathVariable Location deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
data RequestBody = RequestBody Location deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
data RequestHeader = RequestHeader Location deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
data CookieValue = CookieValue Location deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
data RequestPart = RequestPart Location deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data Authentication
   = Authentication
     {
         authenticationFunctionName :: String,
         authenticationEvidence :: AuthEvidence
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
--   'authenticationFunctionName'.
data AuthEvidence
   = ByHeaderNullCheck String
   | ByAllButOneBadReturn
   deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
