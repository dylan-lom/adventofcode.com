wouldhit :: String -> Int -> Bool
wouldhit ln pos = ln!!rpos == '#'
    where rpos = mod pos $ length ln

solveaux :: [String] -> Int -> Int -> Int
solveaux [] pos count = count
solveaux (ln:lns) pos count = solveaux lns npos ncount
    where hit    = wouldhit ln pos
          ncount = if hit then count + 1 else count
          npos   = pos + 3

solve :: [String] -> String
solve lns = show $ solveaux lns 0 0

main :: IO()
main = interact $ solve . lines
