module Report(Report,
              report,
              reportName,
              writeReportHtml,
              strListComp) where

import Control.Monad
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A

import Plot
import Utils

data Report
  = Report String [ReportComponent]
    deriving (Eq, Ord, Show)

report n cs = Report n cs

reportName (Report n _) = n

data ReportComponent
  = IntBarPlot String String [(Int, Int)]
  | StrList String [String]
    deriving (Eq, Ord, Show)

strListComp n strs = StrList n strs

reportComponentToHtml :: String -> ReportComponent -> IO Html
reportComponentToHtml filePath (IntBarPlot pName pSeriesName pData) = do
  gChartToSVG (filePath ++ "/charts") (barChart pName pSeriesName pData)
  return $ chartHtml pName "alt tag"
reportComponentToHtml filePath (StrList lName lItems) =
  return $ stringListToHtml lName lItems

compRCHtml :: String -> Html -> ReportComponent -> IO Html
compRCHtml filePath ht rc = do
  nextHt <- reportComponentToHtml filePath rc
  return $ do { ht ; nextHt }
  
reportToHtml :: String -> Report -> IO Html
reportToHtml topDirPath (Report n comps) =
  let docFront = docTypeHtml $ do
        H.head $ do
          H.title $ toHtml n
        body $ do
          toHtml n in
  foldM (compRCHtml topDirPath) docFront comps

writeReportHtml :: String -> Report -> IO ()
writeReportHtml topDirPath rep@(Report n _) = do
  repHtml <- reportToHtml topDirPath rep
  writeHtmlToFile (topDirPath ++ "/" ++ n) repHtml
