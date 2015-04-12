module ParserTests(allParseModifiedFilesStringTests,
                   allParseGitLogStringTests) where

import Data.List as L

import Git
import Parser
import TestUtils

allParseModifiedFilesStringTests = do
  testFunction parseModifiedFilesString modStringCases

allParseGitLogStringTests = do
  testFunction parseGitLogString gitLogStringCases
  
modStringCases =
  L.map (\(x, y) -> (x, Just y))
  [("", []),
   ("src/nope.py", ["src/nope.py"]),
   ("src/LLDLA/runtimeTest.cpp\nsrc/LLDLA/runtimeTest.h\n",
    ["src/LLDLA/runtimeTest.cpp", "src/LLDLA/runtimeTest.h"])]

gitLogStringCases =
    L.map (\(x, y) -> (x, Just y))
    [("", []),
     ("commit 3f0dbedff54d81fce5acf4d4517563d9f91af6b5\nAuthor: Dillon Huff <dillonhuff@gmail.com>\nDate:   Sun Apr 12 02:09:28 2015 -0500\n\n    the most basic of the two parsers is now done\n\ncommit a5bc8929e982cc703a85b1d5c55725488f894fe6\nAuthor: Dillon Huff <dillonhuff@gmail.com>\nDate:   Sun Apr 12 01:59:42 2015 -0500\n\n    can now get git logs and string showing changed files for a commit from Haskell\n\ncommit f7866c5dc5d8a659deb54aed26f84231839e0e37\nAuthor: Dillon Huff <dillonhuff@gmail.com>\nDate:   Sun Apr 12 01:19:05 2015 -0500\n\n    initial commit\n", [commit "3f0dbedff54d81fce5acf4d4517563d9f91af6b5", commit "a5bc8929e982cc703a85b1d5c55725488f894fe6", commit "f7866c5dc5d8a659deb54aed26f84231839e0e37"])]
