module Plot(GChart, barChart, gChartToSVG) where

import Control.Monad
import Data.List as L
import Graphics.Rendering.Chart.Easy
import Graphics.Rendering.Chart.Backend.Cairo

data GChart l x y = GChart {
  plotName :: String,
  chart :: EC l (Plot x y)
  }

gChart n c = GChart n c

barChart :: String -> String -> [(Int, Int)] -> GChart l Int Int
barChart name seriesName dataPts =
  gChart name $ liftM (plotBars) $ bars [seriesName] $ L.map (\(x, y) -> (x, [y])) dataPts

gChartToSVG :: String -> GChart (Layout Int Int) Int Int -> IO ()
gChartToSVG filePath ct =
  toFile def (filePath ++ "/" ++ plotName ct ++ ".png") $ plot $ chart ct
