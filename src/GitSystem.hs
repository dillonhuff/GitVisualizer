module GitSystem(filesModifiedByCommitString,
                 gitLogString) where

import System.Process

import Git

filesModifiedByCommitString :: FilePath -> String -> IO String
filesModifiedByCommitString repoPath commitStr =
  readProcess "git" ["-C", repoPath, "diff-tree", "--no-commit-id", "--name-only", "-r", commitStr] []

gitLogString :: FilePath -> IO String
gitLogString repoPath =
  readProcess "git" ["-C", repoPath, "log"] []
