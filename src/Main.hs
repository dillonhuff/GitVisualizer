module Main(main) where

import Control.Monad
import Data.List as L
import Data.Map as M

import Analysis
import Git
import GitSystem
import Parser
import Plot

dataBars :: [(Int, [Int])]
dataBars = [(1, [3]), (2, [7]), (3, [15]), (4, [128])]

linData :: Int -> [(Int, Int)]
linData n = L.zip [1..n] $ L.map (\x -> x * 5) [1..n]

dataPts :: [(Int, Int)]
dataPts = [(12, 3), (9, 7), (8, 15)]

projectPath = "/Users/dillon/clojure"
resFileName = "clojure_changes"

main = do
  modStrs <- modStrings projectPath
  let modCounts = modificationCounts modStrs
      modCountList = modCountsToList modCounts in
    plotModificationData resFileName modCountList

modCountsToList :: Map String Int -> [(Int, Int)]
modCountsToList m = L.zip [1..((length sortedCounts) - 1)] sortedCounts
  where
    sortedCounts = L.sort $ L.map snd $ M.toList m

modStrings :: FilePath -> IO [[String]]
modStrings projPath = do
  logStr <- gitLogString projPath
  let logParse = parseGitLogString logStr in
    case logParse of
      Nothing -> error $ "Could not parse " ++ logStr
      Just commits -> do
        changes <- sequence (L.map (modifiedFiles projPath) commits)
        return changes

modifiedFiles :: FilePath -> Commit -> IO [String]
modifiedFiles projPath com = do
  modFilesStr <- filesModifiedByCommitString projPath (commitName com)
  let modFilesParse = parseModifiedFilesString modFilesStr in
      case modFilesParse of
        Nothing -> error $ "Could not parse " ++ modFilesStr
        Just fileNameList -> return fileNameList
