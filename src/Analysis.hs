module Analysis(modificationCounts) where

import Data.List as L
import Data.Map as M

modificationCounts :: [[String]] -> Map String Int
modificationCounts strList =
  L.foldl strCounts M.empty strList

strCounts m strs = L.foldl incStrCount m strs

incStrCount m str = case M.lookup str m of
  Just count -> M.insert str (count +1) m
  Nothing -> M.insert str 1 m
