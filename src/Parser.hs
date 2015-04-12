module Parser(parseModifiedFilesString,
              parseGitLogString) where

import Text.ParserCombinators.Parsec

import Git

parseModifiedFilesString :: String -> Maybe [String]
parseModifiedFilesString str = Just $ lines str

parseGitLogString :: String -> Maybe [Commit]
parseGitLogString str = case parse pLogString "Log string parser" str of
  Left err -> error $ show err
  Right commits -> Just commits

pLogString = sepBy pCommit (char '\n')

pCommit = do
  commitName <- (try pCommitMergeLines) <|> pCommitLine
  pLine
  pLine
  pLine
  pCommitMessage
  return $ commit commitName

pCommitMergeLines = do
  commit <- pCommitLine
  pMergeLine
  return commit

pMergeLine = do
  string "Merge:"
  pLine

pCommitLine = do
  string "commit"
  many space
  commitName <- many1 alphaNum
  newline
  return commitName

pCommitMessage = do
  many1 pCommitMessageLine

pCommitMessageLine = do
  char ' '
  char ' '
  char ' '
  char ' '
  pLine

pLine = do
  many $ noneOf "\n"
  newline
