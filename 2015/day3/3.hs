import qualified Data.Set as Set

type Direction = Char
type Pos       = (Int , Int)
type State     = (Pos, Set.Set Pos)

main = do
  readFile "input" >>= print . partOne
  readFile "input" >>= print . partTwo

partOne :: String -> Int
partOne = Set.size . houses
 
partTwo :: String -> Int
partTwo input = Set.size $ Set.union santa bot
  where santa        = houses mvs0
        bot          = houses mvs1
        (mvs0, mvs1) = splitMvs input

houses :: String -> Set.Set Pos
houses = snd . foldl move ((0, 0), Set.singleton (0, 0))

move :: State -> Direction -> State
move (pos, s) d = (pos', Set.insert pos' s)
  where pos' = nextPos pos d

nextPos :: Pos -> Direction -> Pos
nextPos (x, y) '^' = (x,     y - 1)
nextPos (x, y) 'v' = (x,     y + 1)
nextPos (x, y) '<' = (x - 1, y)
nextPos (x, y) '>' = (x + 1, y)

splitMvs :: [a] -> ([a], [a])
splitMvs = foldr intoTuple ([], [])
  where intoTuple x (y0, y1) = (x:y1, y0)
