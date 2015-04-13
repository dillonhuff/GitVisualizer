module ProjectData(ProjectData,
                   projectName, projectDir, projectCommits, projectFileMods, projectFileModCounts,
                   buildProjectData) where

import Data.List as L
import Data.Map as M

import Git

data ProjectData
  = ProjectData {
    projectName :: String,
    projectDir :: String,
    projectCommits :: [Commit],
    projectFileMods :: [[String]],
    projectFileModCounts :: Map String Int
    } deriving (Eq, Ord, Show)


buildProjectData :: String -> String -> [Commit] -> [[String]] -> ProjectData
buildProjectData name dir commits mods =
  ProjectData name dir commits mods (modificationCounts mods)

modificationCounts :: [[String]] -> Map String Int
modificationCounts strList =
  L.foldl strCounts M.empty strList

strCounts m strs = L.foldl incStrCount m strs

incStrCount m str = case M.lookup str m of
  Just count -> M.insert str (count +1) m
  Nothing -> M.insert str 1 m

