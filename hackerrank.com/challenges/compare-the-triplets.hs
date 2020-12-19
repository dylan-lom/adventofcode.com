-- 20200914 - All tests passing
-- ============================
-- It probably would've been shorter to use lists over tuples, however I found
-- reasoning easier using the tuples.
--
-- Not sure what the haskell-y name for `reducer` would be -- 'binary operator'
-- maybe (based on description of the foldl function found @ hoogle).
--
-- It would be nice to make the `parse` and `unparse` functions simpler / as
-- where's to `main`, I'd like to elimate `takeTwo` as well.

-- Convert input to something meaningful.
parse :: String -> ([Int], [Int])
parse = takeTwo . map (map read . words) . lines
    where takeTwo (xs:ys:_) = (xs, ys)

-- Pair/Zip related scores.
pair :: ([Int], [Int]) -> [(Int, Int)]
pair (xs, ys) = zip xs ys

-- Calculate total scores.
solve :: [(Int, Int)] -> (Int, Int)
solve scores = foldl reducer (0, 0) scores
    where
    reducer (x, y) (x1, y1)
        | x1 > y1  = (x+1, y)
        | x1 == y1 = (x, y)
        | x1 < y1  = (x, y+1)

-- Convert total scores to output format.
unparse :: (Int, Int) -> String
unparse (x, y) = show x ++ " " ++ show y

main :: IO ()
main = interact $ unparse . solve . pair . parse

