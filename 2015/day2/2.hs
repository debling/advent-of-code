import Data.List.Split (splitOn)
import Data.List (sort)

main = do
  print $ calcPaper "2x3x4"  == 58
  print $ calcPaper "1x1x10" == 43
  readFile "input" >>= print . calcFromInput calcPaper 

  print $ calcRibbon "2x3x4"  == 34
  print $ calcRibbon "1x1x10" == 14
  readFile "input" >>= print . calcFromInput calcRibbon  

calcPaper :: String -> Int
calcPaper s = (2 * a * b) + (2 * b * c)  + (2 * c * a) + (a * b)
  where [a, b, c] = parseInput s

calcRibbon :: String -> Int
calcRibbon s = a + a + b + b + (a * b * c) 
  where [a, b, c] = parseInput s

calcFromInput :: (String -> Int) -> String -> Int
calcFromInput f s = sum . map f $ lines s

parseInput :: String -> [Int]
parseInput = sort . map read . splitOn "x"
