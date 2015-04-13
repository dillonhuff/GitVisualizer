module Main(main) where

import Control.Monad
import Data.List as L
import System.Environment

import Analysis
import Backend
import ProjectSummary

main = do
  args <- getArgs
  let projPath = args !! 0
      projName = args !! 1 in
    do
      projData <- getProjectData projPath projName
      let reports = L.map (\f -> f projData) analyzers
          projSummary = projectSummary projName reports in
        writeProjectSummaryHtml projSummary
