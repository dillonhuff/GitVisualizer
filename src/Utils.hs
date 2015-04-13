module Utils(writeHtmlToFile,
             chartHtml,
             stringListToHtml,
             stringListToHyperLinkList) where

import Control.Monad
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.String

writeHtmlToFile :: FilePath -> Html -> IO ()
writeHtmlToFile fileName htmlText =
  writeFile (fileName ++ ".html") (renderHtml htmlText)

chartHtml :: String -> String -> Html
chartHtml imgPath imgAltTagText =
  img ! src (toValue ("charts/" ++ imgPath ++ ".svg")) ! alt (toValue imgAltTagText)

stringListToHtml :: String -> [String] -> Html
stringListToHtml title items = body $ do
  p $ toHtml title
  ul $ forM_ items (li . toHtml)

stringListToHyperLinkList :: String -> [String] -> Html
stringListToHyperLinkList title items = body $ do
  p $ toHtml title
  ul $ forM_ items (\linkName -> li $ a ! href (toValue $ linkName ++ ".html") $ toHtml linkName)
