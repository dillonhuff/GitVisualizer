module AllTests(main) where

import AnalysisTests
import ParserTests

main = do
  allAnalysisTests
  allParserTests
