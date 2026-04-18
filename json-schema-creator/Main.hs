{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE OverloadedStrings #-}

module Main

where

-- general imports
import Data.Proxy ( Proxy(..) )
import Data.OpenApi ( ToSchema, toSchema, declareSchemaRef )
import Data.OpenApi.Declare ( runDeclare )
import Data.Aeson ( Value(..), toJSON, object, (.=) )
import Data.Aeson.Encode.Pretty ( encodePretty )

-- general qualified imports
import qualified Data.Aeson.KeyMap as KM
import qualified Data.ByteString.Lazy as BL

-- project imports
import Content
import Location
import Kbapi ( Query, QueryResult )

instance ToSchema Query
instance ToSchema QueryResult

instance ToSchema Location

instance ToSchema ConstStringsMatching
instance ToSchema FoundConstStringsMatching
instance ToSchema FoundConstStringMatch

instance ToSchema HttpPostHandlerRequestObject
instance ToSchema FoundHttpPostHandlerRequestObject
instance ToSchema FoundHttpPostHandlerRequestObjectMatch

instance ToSchema HttpGetHandlerRequestObject
instance ToSchema FoundHttpGetHandlerRequestObject
instance ToSchema FoundHttpGetHandlerRequestObjectMatch

instance ToSchema CommentsInFunction
instance ToSchema FoundCommentsInFunction
instance ToSchema Comment

instance ToSchema WriteContentToLocalFile
instance ToSchema FoundWriteContentToLocalFile

instance ToSchema ControlFlowPath
instance ToSchema FoundControlFlowPath

instance ToSchema DataFlowPath
instance ToSchema FoundDataFlowPath

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
