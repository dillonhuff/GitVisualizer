module HtmlReport(generateHtmlReport,
                  writeHtmlReport) where

import Graphics.Rendering.Chart.Easy hiding (toValue)
import Control.Monad (forM_, sequence_)
import Data.List as L
import Data.Map as M hiding ((!))
import System.Directory
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.String

import Analysis
import Plot

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
      rWithChart = addBarChart "files_by_num_mod_commits" "# of modifying commits" modFileInds newR in
  rWithChart

writeHtmlReport :: HtmlReport (Layout Int Int) Int Int -> IO ()
writeHtmlReport (HtmlReport n h p) = do
  topDirName <- createReportDirs n
  sequence_ $ L.map (gChartToSVG (chartsDirName n ++ "/")) p
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

chartHtml :: String -> String -> Html
chartHtml imgPath imgAltTagText =
  img ! src (toValue ("charts/" ++ imgPath ++ ".svg")) ! alt (toValue imgAltTagText)

reportTitle :: String -> Html
reportTitle projectName = H.title $ toHtml $ projectName ++ " Git Report"

blurb :: Html
blurb = toHtml "This report was automatically generated by GitVisualizer, a code analysis tool written by Dillon Huff"

mostModifiedList :: [(String, Int)] -> Html
mostModifiedList mostModifiedFiles = body $ do
  p $ toHtml "The most modified files and the number of commits that modified them are shown below:"
  ul $ forM_ mostModifiedFiles (li . toHtml . modStr)

modStr :: (String, Int) -> String
modStr (name, num) = name ++ ", " ++ show num

writeHtmlToFile :: FilePath -> Html -> IO ()
writeHtmlToFile fileName htmlText =
  writeFile (fileName ++ ".html") (renderHtml htmlText)
