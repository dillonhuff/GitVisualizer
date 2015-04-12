module ParserTests(allParseModifiedFilesStringTests) where

import Data.List as L

import Parser
import TestUtils

allParseModifiedFilesStringTests = do
  testFunction parseModifiedFilesString modStringCases

modStringCases =
  L.map (\(x, y) -> (x, Just y))
  [("", []),
   ("src/nope.py", ["src/nope.py"]),
   ("src/LLDLA/runtimeTest.cpp\nsrc/LLDLA/runtimeTest.h\n",
    ["src/LLDLA/runtimeTest.cpp", "src/LLDLA/runtimeTest.h"])]
