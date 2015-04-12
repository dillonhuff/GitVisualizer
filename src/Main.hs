module Main(main) where

import Data.List as L

import Plot

dataBars :: [(Int, [Int])]
dataBars = [(1, [3]), (2, [7]), (3, [15]), (4, [128])]

linData :: Int -> [(Int, Int)]
linData n = L.zip [1..n] $ L.map (\x -> x * 5) [1..n]

dataPts :: [(Int, Int)]
dataPts = [(12, 3), (9, 7), (8, 15)]

main = plotModificationData "fake_modification_data" $ linData 239
