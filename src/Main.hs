module Main(main) where

import Control.Monad
import Data.List as L
import Data.Map as M

import Analysis
import Git
import GitSystem
import Parser
import Plot
import HtmlReport

projPath = "/Users/dillon/clojure"
projName = "Clojure"

main = do
  commits <- getCommits projPath
  modFilesList <- modStrings commits projPath
  let report = buildProjectReport projName projPath commits modFilesList in
    generateHtmlReport report

getCommits :: FilePath -> IO [Commit]
getCommits projPath = do
  logStr <- gitLogString projPath
  let logParse = parseGitLogString logStr in
    case logParse of
      Nothing -> error $ "Could not parse " ++ logStr
      Just commits -> return commits
        
modStrings :: [Commit] -> FilePath -> IO [[String]]
modStrings commits projPath =
  sequence (L.map (modifiedFiles projPath) commits)

modifiedFiles :: FilePath -> Commit -> IO [String]
modifiedFiles projPath com = do
  modFilesStr <- filesModifiedByCommitString projPath (commitName com)
  let modFilesParse = parseModifiedFilesString modFilesStr in
      case modFilesParse of
        Nothing -> error $ "Could not parse " ++ modFilesStr
        Just fileNameList -> return fileNameList
