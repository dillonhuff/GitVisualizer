module Analysis(modCountsListReport,
                modCountsBarChartReport,
                analyzers) where

import Data.List as L
import Data.Map as M

import ProjectData
import Report

analyzers =
  [modCountsListReport,
   modCountsBarChartReport]

modCountsListReport :: ProjectData -> Report
modCountsListReport projData = sortedReport
  where
    m = projectFileModCounts projData
    sortedCounts = L.sortBy (\(_, y1) (_, y2) -> compare y1 y2) $ M.toList m
    sortedCountsStrs = L.reverse $ L.map (\(fileName, modCount) -> fileName ++ ", " ++ show modCount) sortedCounts
    listComp = strListComp "Files and the number of commits that modified them" sortedCountsStrs
    sortedReport = report "FileModificationCounts" [listComp]

modCountsBarChartReport :: ProjectData -> Report
modCountsBarChartReport projData = modsBarChart
  where
    m = projectFileModCounts projData
    sortedCounts = L.sortBy (\(_, y1) (_, y2) -> compare y1 y2) $ M.toList m
    sortedCountsByInd = L.zip [1..(length sortedCounts)] $ L.map snd sortedCounts
    barChartComp = intBarPlotComp "files_by_num_modifying_commits" "# of modifying commits" sortedCountsByInd
    modsBarChart = report "FileModificationChart" [barChartComp]
