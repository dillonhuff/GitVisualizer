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
  commitName <- pCommitLine
  pLine
  pLine
  pLine
  pLine
  return $ commit commitName

pCommitLine = do
  string "commit"
  many space
  commitName <- many1 alphaNum
  newline
  return commitName
  
pLine = do
  many $ noneOf "\n"
  newline
