module Parser(parseModifiedFilesString) where

parseModifiedFilesString :: String -> Maybe [String]
parseModifiedFilesString str = Just $ lines str
