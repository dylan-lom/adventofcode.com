-- 20200916 - All tests passing
-- ============================
-- I initially solved this using an additional 'corners' step inbetween
-- indexRows and diagonals, which would get the elements we cared about from
-- each row (`corners :: Matrix -> [(Int, Int)]`).
--
-- That attempt used folds to reduce the input array one step at a time. It was
-- really ugly (mostly thanks to rather long lambda functions) and confusing,
-- partly due to the bad function names (a problem which persists).
--
-- I'm somewhat happy with this solution, however I the where clause in the
-- diagonals function is emulating an imperitive style of programming which
-- isn't very good... Also the solve function seems really silly, and maybe
-- I should use a where clause in main (how?) in order to remove it.
--
-- I like the type aliases, however they're pretty unnecessary at this level.

type Matrix = [Row]
type Row = [Int]

parse :: String -> Matrix
parse = map (map read) . map words . tail . lines

type IndexedRow = (Int, Row)

indexRows :: Matrix-> [IndexedRow]
indexRows = zip [0..]

-- This function should probably be called diagonalLengths or something...
diagonals :: [IndexedRow] -> (Int, Int)
diagonals [] = (0, 0)
diagonals ((i, xs):rest) = (left + leftRest, right + rightRest)
    where left          = xs !! i
          right         = xs !! (length xs - 1 - i)
          restDiagonals = diagonals rest
          leftRest      = fst restDiagonals
          rightRest     = snd restDiagonals

-- This function kinda sucks.
solve :: (Int, Int) -> Int
solve (ls, rs) = abs (ls - rs)

main :: IO()
main = interact $ show . solve . diagonals . indexRows . parse

