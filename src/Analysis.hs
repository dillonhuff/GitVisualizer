module Analysis(modCountsListReport,
                modCountsBarChartReport,
                modificationCounts,
                analyzers) where

import Data.List as L
import Data.Map as M

import ProjectData
import Report

analyzers =
  [modCountsListReport,
   modCountsBarChartReport,
   filesChangedByCommitReport]

modCountsListReport :: ProjectData -> Report
modCountsListReport projData = sortedReport
  where
    m = modificationCounts $ projectFileMods projData
    sortedCounts = L.sortBy (\(_, y1) (_, y2) -> compare y1 y2) $ M.toList m
    sortedCountsStrs = L.reverse $ L.map (\(fileName, modCount) -> fileName ++ ", " ++ show modCount) sortedCounts
    listComp = strListComp "Files and the number of commits that modified them" sortedCountsStrs
    sortedReport = report "FileModificationCounts" [listComp]

modCountsBarChartReport :: ProjectData -> Report
modCountsBarChartReport projData = modsBarChart
  where
    m = modificationCounts $ projectFileMods projData
    sortedCounts = L.sortBy (\(_, y1) (_, y2) -> compare y1 y2) $ M.toList m
    sortedCountsByInd = L.zip [1..(length sortedCounts)] $ L.map snd sortedCounts
    barChartComp = intBarPlotComp "files_by_num_modifying_commits" "# of modifying commits" sortedCountsByInd
    modsBarChart = report "FileModificationChart" [barChartComp]

modificationCounts :: [[String]] -> Map String Int
modificationCounts strList =
  L.foldl strCounts M.empty strList

strCounts m strs = L.foldl incStrCount m strs

incStrCount m str = case M.lookup str m of
  Just count -> M.insert str (count +1) m
  Nothing -> M.insert str 1 m

filesChangedByCommitReport :: ProjectData -> Report
filesChangedByCommitReport projData = changesByCommitBarChart
  where
    modCounts = L.map L.length $ projectFileMods projData
    commitNoModCount = L.zip [1..(length modCounts)] modCounts
    changesByCommitBar = intBarPlotComp "commits_with_num_modified_files" "files modified by commit" commitNoModCount
    changesByCommitBarChart = report "NumFilesChangedByCommitNumber" [changesByCommitBar]
    
