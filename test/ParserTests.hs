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
     
     ("commit 3f0dbedff54d81fce5acf4d4517563d9f91af6b5\nAuthor: Dillon Huff <dillonhuff@gmail.com>\nDate:   Sun Apr 12 02:09:28 2015 -0500\n\n    the most basic of the two parsers is now done\n\ncommit a5bc8929e982cc703a85b1d5c55725488f894fe6\nAuthor: Dillon Huff <dillonhuff@gmail.com>\nDate:   Sun Apr 12 01:59:42 2015 -0500\n\n    can now get git logs and string showing changed files for a commit from Haskell\n\ncommit f7866c5dc5d8a659deb54aed26f84231839e0e37\nAuthor: Dillon Huff <dillonhuff@gmail.com>\nDate:   Sun Apr 12 01:19:05 2015 -0500\n\n    initial commit\n",
      [commit "3f0dbedff54d81fce5acf4d4517563d9f91af6b5", commit "a5bc8929e982cc703a85b1d5c55725488f894fe6", commit "f7866c5dc5d8a659deb54aed26f84231839e0e37"]),
     
     ("commit 718a20902a7d282abfa3d7421c81cb58ca2e8032\nAuthor: Dillon Huff <dillonhuff@gmail.com>\nDate:   Fri Apr 10 21:19:26 2015 -0500\n\n    some minor code cleanup in RuntimeTest\n\ncommit 8ee85848ca6448312df66335d7136d08395796e7\nAuthor: Dillon Huff <dillonhuff@gmail.com>\nDate:   Fri Apr 10 21:10:54 2015 -0500\n\n    output buffer sanity checks passing tests\n\ncommit 3d6a1f2942855f6e3bd8c1795bf47e89abf9da78\nAuthor: Dillon Huff <dillonhuff@gmail.com>\nDate:   Fri Apr 10 20:58:41 2015 -0500\n\n    refactoring RuntimeTest even more to support only sanity checking outputs of computations\n\ncommit e2ee864afb67e1350f046e54e5fe07dbdc2d86d5\nMerge: 5cb2a23 402f590\nAuthor: Dillon Huff <dillonhuff@gmail.com>\nDate:   Fri Apr 10 19:04:15 2015 -0500\n\n    pulled\n\ncommit 5cb2a230317f684b155e75fcdc2a2a8c53106bc5\nAuthor: Dillon Huff <dillonhuff@gmail.com>\nDate:   Fri Apr 10 19:04:04 2015 -0500\n\n    have now removed all superfluous loads and stores from axpy and 31\n\ncommit 402f590745efeab3774cac6e85c93cfd4508f523\nMerge: d7f28c4 d50a460\nAuthor: Bryan Marker <bamarker@cs.utexas.edu>\nDate:   Fri Apr 10 10:20:10 2015 -0500\n\n    Merge branch 'master' of https://github.com/DxTer-project/dxter\n\ncommit d7f28c4cb8283166963d59d3372717d06dea2715\nAuthor: Bryan Marker <bamarker@cs.utexas.edu>\nDate:   Fri Apr 10 10:20:05 2015 -0500\n\n    removing parFactor from sizes class - blis stuff will break\n",
      [commit "718a20902a7d282abfa3d7421c81cb58ca2e8032",
       commit "8ee85848ca6448312df66335d7136d08395796e7",
       commit "3d6a1f2942855f6e3bd8c1795bf47e89abf9da78",
       commit "e2ee864afb67e1350f046e54e5fe07dbdc2d86d5",
       commit "5cb2a230317f684b155e75fcdc2a2a8c53106bc5",
       commit "402f590745efeab3774cac6e85c93cfd4508f523",
       commit "d7f28c4cb8283166963d59d3372717d06dea2715"]),
     
     (multiLineCommitMessage, [commit "c6331da594479a41f8ba9e62bd2440804ccedbc8", commit "a04a57357683d4fe3e874ea71ae082094d9f894c", commit "e223765d1eef99d0fa7dce9742fd931c53b43f64"])]

multiLineCommitMessage =
  "commit c6331da594479a41f8ba9e62bd2440804ccedbc8\nMerge: a04a573 bcd7cc3\nAuthor: Bryan Marker <bamarker@cs.utexas.edu>\nDate:   Sun Mar 1 11:15:01 2015 -0600\n\n    Merge branch 'master' of https://github.com/DxTer-project/dxter\n    \n    Conflicts:\n    \tsrc/tensors/driverTensors.cpp\n\ncommit a04a57357683d4fe3e874ea71ae082094d9f894c\nAuthor: Bryan Marker <bamarker@cs.utexas.edu>\nDate:   Sun Mar 1 11:13:39 2015 -0600\n\n    xqup\n\ncommit e223765d1eef99d0fa7dce9742fd931c53b43f64\nAuthor: Bryan Marker <bamarker@cs.utexas.edu>\nDate:   Sun Mar 1 10:23:32 2015 -0600\n\n    adding UQP driver\n"

