module Git(Commit,
           commit) where


data Commit
  = Commit String
    deriving (Eq, Ord, Show)

commit name = Commit name
