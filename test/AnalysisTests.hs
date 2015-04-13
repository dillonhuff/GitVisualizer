module AnalysisTests(allAnalysisTests,
                     allModificationCountsTests) where

import Data.Map as M

import Analysis
import TestUtils

allAnalysisTests = do
  allModificationCountsTests

allModificationCountsTests = do
  testFunction modificationCounts modCountsCases

modCountsCases =
  [([], M.empty),
   ([["a"]], M.fromList [("a", 1)]),
   ([["x", "y"], ["x", "k"]], M.fromList [("x", 2), ("y", 1), ("k", 1)])]
