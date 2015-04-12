module Plot(plotModificationData) where

import Control.Monad
import Data.List as L
import Graphics.Rendering.Chart.Easy
import Graphics.Rendering.Chart.Backend.Diagrams

plotModificationData :: String -> [(Int, Int)] -> IO ()
plotModificationData fileName fileNoModNoPairs =
  toFile def (fileName ++ ".svg") $ do
    plot $ liftM plotBars $ bars ["# of modifications"] $ L.map (\(x, y) -> (x, [y])) fileNoModNoPairs  
