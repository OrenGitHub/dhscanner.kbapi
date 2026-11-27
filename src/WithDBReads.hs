{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module WithDBReads

where

-- general imports
import GHC.Generics
import Data.Aeson

-- project imports
import Location
import Common

-- |
--
-- * The reads of 'column' of the 1st party 'model' that 'endpoint'
--   reaches within 'maxNumInterProceduralHops' calls ( @0@ : reads
--   'endpoint' itself contains ), at most 'maxNumMatches' of them.
--
-- * 'model' and 'column' are spelled as a 'WithDataFlowPath.DBWriteDataFlowPath'
--   reports them : ask this query on an endpoint after another endpoint
--   was found to store user input in that column ( stored, or second
--   order, taint ).
--
-- * A read of every column ( @select *@ ) is a read of 'column' too.
--
-- Code snippet ( PHP, Laravel ):
--
-- @
-- public function show( Request $request, $slug ) {
--     $post = Post::select( \'title\', \'body\' )->where( \'slug\', $slug )->first();
--     return view( \'posts.show\', [ \'post\' => $post ] );
-- }
-- @
--
-- With @endpoint@ = @show@, @model@ = @Post@, @column@ = @title@, the read is
-- the @Post::select( .. )->first()@ call, contained in @show@.
--
data Features
   = Features
     {
        endpoint :: Location,
        model :: Model,
        column :: Column,
        maxNumInterProceduralHops :: Word,
        maxNumMatches :: Word
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

data Content
   = Content
     {
        total :: Word,
        matches :: [ Match ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- |
--
-- * 'dbRead' : the read call, whose value holds the column. It is the @from@
--   of a 'WithDataFlowPath.Features' query towards a sink 'endpoint' reaches.
--
-- * 'endpointToDBRead' : the call sites from 'endpoint' down to the call
--   that holds 'dbRead', 'endpoint' side first ; @[]@ when 'endpoint'
--   contains the read. Together with the data flow path from 'dbRead' it
--   is the read side of a stored taint finding.
--
data Match
   = Match
     {
        dbRead :: DBRead,
        endpointToDBRead :: [ Location ]
     }
     deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )

-- | A database read : the location of the read call.
data DBRead = DBRead Location deriving ( Show, Eq, Ord, Generic, ToJSON, FromJSON )
