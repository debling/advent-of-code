main = do
  f <- readFile "input"
  print $ getFloor f
  print $ basement f

getFloor :: String -> Int
getFloor = last . toFloor

basement :: String -> Int
basement = length . takeWhile (/= -1) . toFloor

toFloor :: String -> [Int]
toFloor = scanl toFloor' 0
  where toFloor' f '(' = f + 1
        toFloor' f ')' = f - 1
