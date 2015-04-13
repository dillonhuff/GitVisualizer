module Backend(getProjectData) where

import Data.List as L

import Git
import GitSystem
import Parser
import ProjectData
import ProjectSummary

getProjectData :: FilePath -> String -> IO ProjectData
getProjectData projPath projName = do
  commits <- getCommits projPath
  modFilesList <- modStrings commits projPath
  return $ buildProjectData projName projPath commits modFilesList

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
