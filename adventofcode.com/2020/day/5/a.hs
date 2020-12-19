binarypartition :: Bool -> [a] -> [a]
binarypartition takeUpperHalf ls
    | takeUpperHalf = drop n ls
    | otherwise     = take n ls
    where n = (length ls) `div` 2

applybinarypartitions :: [Bool] -> [a] -> [a]
applybinarypartitions [] ls = ls
applybinarypartitions _ (l:[]) = [l]
applybinarypartitions (u:us) ls = applybinarypartitions us $ binarypartition u ls

decodeticket :: String -> (Int, Int)
decodeticket t = (row, col)
    where rows = [0..127]
          cols = [0..7]
          rowUs = map (== 'B') $ take 7 t
          colUs = map (== 'R') $ drop 7 t
          row = head $ applybinarypartitions rowUs rows
          col = head $ applybinarypartitions colUs cols

getseatid :: (Int, Int) -> Int
getseatid (row, col) = (+) col $ row * 8

maxseatid :: [String] -> Int
maxseatid = maximum . map (getseatid . decodeticket)

main :: IO()
main = interact $ show . maxseatid . lines
