module HtmlReport(generateHtmlReport,
                  writeHtmlReport) where

import Graphics.Rendering.Chart.Easy hiding (toValue)
import Control.Monad (forM_, sequence_)
import Data.List as L
import Data.Map as M hiding ((!))
import System.Directory
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A

import Analysis
import Plot
import Utils

data HtmlReport l x y = HtmlReport {
  reportName :: String,
  htmlData :: Html,
  plots :: [GChart l x y]
  }

newHtmlReport name =
  HtmlReport name startHt []
  where
    startHt = docTypeHtml $ do
      H.head $ do
        H.title $ toHtml (name ++ " Git Report")
      body $ do blurb

addChart c (HtmlReport n h p) = HtmlReport n h (c:p)

setHtml f (HtmlReport n h p) =
  let newHtml = do { h ; f } in
  HtmlReport n newHtml p

addBarChart cName cSeriesName cData rep =
  let ct = barChart cName cSeriesName cData
      repC = addChart ct rep
      resC = setHtml (chartHtml cName "default alt") repC in
  resC

generateHtmlReport projRep =
  let newR = newHtmlReport (projectName projRep)
      modFilesList = modCountsToList $ projectFileModCounts projRep
      modFileInds = L.zip [1..(length modFilesList)] $ L.map snd modFilesList
      rWithChart = addBarChart "files_by_num_mod_commits" "# of modifying commits" modFileInds newR
      finalReport = setHtml (mostModifiedList $ L.reverse modFilesList) rWithChart in
  setHtml (a ! href (toValue "otherPage.html") $ toHtml "otherPage") finalReport

writeHtmlReport :: HtmlReport (Layout Int Int) Int Int -> IO ()
writeHtmlReport (HtmlReport n h p) = do
  topDirName <- createReportDirs n
  sequence_ $ L.map (gChartToSVG (chartsDirName n ++ "/")) p
  writeHtmlToFile (topDirName ++ "/" ++ "otherPage") $ docTypeHtml $ do
      H.head $ do
        H.title $ toHtml (n ++ " Git Report")
      body $ do blurb
  writeHtmlToFile (topDirName ++ "/" ++ n) h

createReportDirs :: String -> IO String
createReportDirs projName =
  do
    createDirectoryIfMissing True $ topLevelDirName projName
    createDirectoryIfMissing True $ chartsDirName projName
    return $ topLevelDirName projName

topLevelDirName :: String -> String
topLevelDirName projName = projName ++ "_git_report"

chartsDirName projName = (topLevelDirName projName) ++ "/charts"



modStr :: (String, Int) -> String
modStr (name, num) = name ++ ", " ++ show num
