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

data HttpPostHandlerRequestObject
   = HttpPostHandlerRequestObject
     {
         httpPostHandlerRequestObjectUrlParts :: [ String ],
         httpPostHandlerRequestObjectLimit :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FoundHttpPostHandlerRequestObject
   = FoundHttpPostHandlerRequestObject
     {
         foundHttpPostHandlerRequestObjectTotal :: Word,
         foundHttpPostHandlerRequestObjectMatches :: [ FoundHttpPostHandlerRequestObjectMatch ]
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
