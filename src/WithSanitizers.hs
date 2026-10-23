{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module WithSanitizers

where

-- general imports
import GHC.Generics
import Data.Aeson

-- project imports
import Location

data Features
   = Features
     {
        userInput :: Location,
        sink :: Location,
        maxNumSanitizers :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data Content
   = Content
     {
        total :: Word,
        matches :: [ Sanitizer ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | One constructor per gadget kind ; tagged in JSON even while it is the only one
data Sanitizer
   = TopLevelIfThenElse IfThenElse
   deriving ( Show, Eq, Ord, Generic )

instance ToJSON Sanitizer where
    toJSON = genericToJSON defaultOptions { tagSingleConstructors = True }
    toEncoding = genericToEncoding defaultOptions { tagSingleConstructors = True }

instance FromJSON Sanitizer where
    parseJSON = genericParseJSON defaultOptions { tagSingleConstructors = True }

data IfThenElse
   = IfThenElse
     {
         cond :: PartCall,
         userInputArgIndex :: Word,
         userInputFlow :: [ FlowStep ],
         thenPart :: [ PartCall ],
         elsePart :: [ PartCall ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data FlowStep
   = FlowStep
     {
         flowStepLocation :: Location,
         flowStepQualifiedName :: Maybe String
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data PartCall
   = PartCall
     {
         location :: Location,
         qualifiedName :: Maybe String,
         constStringArgs :: [ String ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
