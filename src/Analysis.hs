module Analysis(modCountsListReport) where

import Data.List as L
import Data.Map as M

import ProjectData
import Report

modCountsListReport :: ProjectData -> Report
modCountsListReport projData = sortedReport
  where
    m = projectFileModCounts projData
    sortedCounts = L.sortBy (\(_, y1) (_, y2) -> compare y1 y2) $ M.toList m
    sortedCountsStrs = L.map (\(fileName, modCount) -> fileName ++ ", " ++ show modCount) sortedCounts
    listComp = strListComp "Files and the number of commits that modified them" sortedCountsStrs
    sortedReport = report "File Modification Counts" [listComp]

