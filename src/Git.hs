module Git(Commit,
           commit,
           commitName) where


data Commit
  = Commit String
    deriving (Eq, Ord, Show)

commit name = Commit name

commitName (Commit str) = str
