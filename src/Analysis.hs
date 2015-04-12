module Analysis(modificationCounts,
                ProjectReport,
                projectName, projectDir, projectCommits, projectFileMods, projectFileModCounts,
                buildProjectReport,
                modCountsToList) where

import Data.List as L
import Data.Map as M

import Git

data ProjectReport
  = ProjectReport {
    projectName :: String,
    projectDir :: String,
    projectCommits :: [Commit],
    projectFileMods :: [[String]],
    projectFileModCounts :: Map String Int
    } deriving (Eq, Ord, Show)

buildProjectReport :: String -> String -> [Commit] -> [[String]] -> ProjectReport
buildProjectReport name dir commits mods =
  ProjectReport name dir commits mods (modificationCounts mods)

modificationCounts :: [[String]] -> Map String Int
modificationCounts strList =
  L.foldl strCounts M.empty strList

strCounts m strs = L.foldl incStrCount m strs

incStrCount m str = case M.lookup str m of
  Just count -> M.insert str (count +1) m
  Nothing -> M.insert str 1 m

modCountsToList :: Map String Int -> [(String, Int)]
modCountsToList m = sortedCounts
  where
    sortedCounts = L.sortBy (\(_, y1) (_, y2) -> compare y1 y2) $ M.toList m
