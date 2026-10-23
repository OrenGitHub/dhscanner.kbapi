{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE OverloadedStrings #-}

module Main

where

-- general imports
import Data.Proxy ( Proxy(..) )
import Data.OpenApi ( ToSchema(..), SchemaOptions(..), NamedSchema(..), toSchema, declareSchemaRef, defaultSchemaOptions, genericDeclareNamedSchema )
import GHC.Generics ( Generic )
import Data.OpenApi.Declare ( runDeclare )
import Data.Aeson ( Value(..), toJSON, object, (.=) )
import Data.Aeson.Encode.Pretty ( encodePretty )

-- general qualified imports
import qualified Data.Aeson.KeyMap as KM
import qualified Data.ByteString.Lazy as BL

-- project imports
import Location
import Kbapi ( Query, QueryResult )

-- project qualified imports
import qualified WithHttpHandlers
import qualified WithControlFlowReachableSinks
import qualified WithConstStrings
import qualified WithComments
import qualified WithDataFlowPath
import qualified WithSanitizers

-- every query module names its type Features : qualify the schema name
qualifiedAs :: String -> SchemaOptions
qualifiedAs m = defaultSchemaOptions { datatypeNameModifier = ((m ++ ".") ++) }

instance ToSchema Query
instance ToSchema QueryResult

instance ToSchema Location

instance ToSchema WithHttpHandlers.Features where declareNamedSchema = genericDeclareNamedSchema (qualifiedAs "WithHttpHandlers")
instance ToSchema WithHttpHandlers.HttpVerb
instance ToSchema WithHttpHandlers.AuthFilter
instance ToSchema WithHttpHandlers.Content where declareNamedSchema = genericDeclareNamedSchema (qualifiedAs "WithHttpHandlers")
instance ToSchema WithHttpHandlers.HttpHandler
instance ToSchema WithHttpHandlers.HttpHandlerDef
instance ToSchema WithHttpHandlers.MethodName
instance ToSchema WithHttpHandlers.ClassName
instance ToSchema WithHttpHandlers.FunctionName
instance ToSchema WithHttpHandlers.UserInput
instance ToSchema WithHttpHandlers.RequestObject
instance ToSchema WithHttpHandlers.RequestParam
instance ToSchema WithHttpHandlers.PathVariable
instance ToSchema WithHttpHandlers.RequestBody
instance ToSchema WithHttpHandlers.RequestHeader
instance ToSchema WithHttpHandlers.CookieValue
instance ToSchema WithHttpHandlers.RequestPart
instance ToSchema WithHttpHandlers.Authentication
instance ToSchema WithHttpHandlers.AuthEvidence

instance ToSchema WithControlFlowReachableSinks.Features where declareNamedSchema = genericDeclareNamedSchema (qualifiedAs "WithControlFlowReachableSinks")
instance ToSchema WithControlFlowReachableSinks.Sink
instance ToSchema WithControlFlowReachableSinks.Content where declareNamedSchema = genericDeclareNamedSchema (qualifiedAs "WithControlFlowReachableSinks")
instance ToSchema WithControlFlowReachableSinks.Match where declareNamedSchema = genericDeclareNamedSchema (qualifiedAs "WithControlFlowReachableSinks")

instance ToSchema WithConstStrings.Features where declareNamedSchema = genericDeclareNamedSchema (qualifiedAs "WithConstStrings")
instance ToSchema WithConstStrings.Content where declareNamedSchema = genericDeclareNamedSchema (qualifiedAs "WithConstStrings")
instance ToSchema WithConstStrings.Match where declareNamedSchema = genericDeclareNamedSchema (qualifiedAs "WithConstStrings")

instance ToSchema WithComments.Features where declareNamedSchema = genericDeclareNamedSchema (qualifiedAs "WithComments")
instance ToSchema WithComments.Content where declareNamedSchema = genericDeclareNamedSchema (qualifiedAs "WithComments")
instance ToSchema WithComments.Comment

instance ToSchema WithDataFlowPath.Features where declareNamedSchema = genericDeclareNamedSchema (qualifiedAs "WithDataFlowPath")
instance ToSchema WithDataFlowPath.Content where declareNamedSchema = genericDeclareNamedSchema (qualifiedAs "WithDataFlowPath")

instance ToSchema WithSanitizers.Features where declareNamedSchema = genericDeclareNamedSchema (qualifiedAs "WithSanitizers")
instance ToSchema WithSanitizers.Content where declareNamedSchema = genericDeclareNamedSchema (qualifiedAs "WithSanitizers")
instance ToSchema WithSanitizers.IfThenElse
instance ToSchema WithSanitizers.PartCall
instance ToSchema WithSanitizers.FlowStep

-- openapi3 ignores tagSingleConstructors : describe the tagged Sanitizer
-- through a mirror ( drop it once Sanitizer has a second constructor )
data SanitizerTag = TopLevelIfThenElse deriving ( Generic )
data SanitizerMirror = SanitizerMirror { tag :: SanitizerTag, contents :: WithSanitizers.IfThenElse } deriving ( Generic )

instance ToSchema SanitizerTag
instance ToSchema SanitizerMirror

instance ToSchema WithSanitizers.Sanitizer where
    declareNamedSchema _ = do
        NamedSchema _ s <- declareNamedSchema (Proxy :: Proxy SanitizerMirror)
        pure (NamedSchema (Just "Sanitizer") s)

schemaWithDefs :: ToSchema a => Proxy a -> Value
schemaWithDefs p =
    let (defs, _) = runDeclare (declareSchemaRef p) mempty
        top = toJSON (toSchema p)
        components = object [ "schemas" .= defs ]
    in case top of
         Object o -> Object (KM.insert "components" components o)
         v -> v

main :: IO ()
main = do
    BL.writeFile "query.schema.json" (encodePretty (schemaWithDefs (Proxy :: Proxy Query)))
    BL.writeFile "query_result.schema.json" (encodePretty (schemaWithDefs (Proxy :: Proxy QueryResult)))
    putStrLn "wrote query.schema.json"
    putStrLn "wrote query_result.schema.json"
