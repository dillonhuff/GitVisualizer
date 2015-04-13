module ProjectData(ProjectData,
                   projectName, projectDir, projectCommits, projectFileMods,
                   buildProjectData) where

import Data.List as L
import Data.Map as M

import Git

data ProjectData
  = ProjectData {
    projectName :: String,
    projectDir :: String,
    projectCommits :: [Commit],
    projectFileMods :: [[String]]
    } deriving (Eq, Ord, Show)


buildProjectData :: String -> String -> [Commit] -> [[String]] -> ProjectData
buildProjectData name dir commits mods =
  ProjectData name dir commits mods
