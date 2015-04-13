module SystemTest(main) where

import Data.List as L

import Analysis
import Backend
import ProjectSummary

projPath = "/Users/dillon/Haskell/GitVisualizer"
projName = "GitVisualizer"

main = do
  projData <- getProjectData projPath projName
  let reports = L.map (\f -> f projData) analyzers
      projSummary = projectSummary projName reports in
    writeProjectSummaryHtml projSummary
