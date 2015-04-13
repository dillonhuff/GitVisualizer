module Main(main) where

import Control.Monad
import Data.List as L
import Data.Map as M
import System.Environment

import Analysis
import Git
import GitSystem
import Parser
import Plot
import ProjectData
import ProjectSummary

analyzers =
  [modCountsListReport,
   modCountsBarChartReport]

main = do
  args <- getArgs
  let projPath = args !! 0
      projName = args !! 1 in
    do
      commits <- getCommits projPath
      modFilesList <- modStrings commits projPath
      let projData = buildProjectData projName projPath commits modFilesList
          reports = L.map (\f -> f projData) analyzers
          projSummary = projectSummary projName reports in
        writeProjectSummaryHtml projSummary

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
