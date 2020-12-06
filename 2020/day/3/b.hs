wouldhit :: String -> Int -> Bool
wouldhit ln pos = ln!!rpos == '#'
    where rpos = mod pos $ length ln

solveaux :: Num t => [String] -> (Int, Int) -> Int -> t -> t
solveaux [] _ _ count  = count
solveaux lns (r,d) pos count = solveaux nlns (r,d) npos ncount
    where ln     = head lns
          hit    = wouldhit ln pos
          ncount = if hit then count + 1 else count
          npos   = pos + r
          nlns   = drop d lns

solve :: [String] -> String
solve lns = show $ foldl1 (\b a -> a * b) $ map (\angle -> solveaux lns angle 0 0) routes
    where routes = [(1,1), (3,1), (5,1), (7,1), (1,2)]

main :: IO()
main = interact $ solve . lines
