import Data.List

type Seat = (Int, Int)

binarypartition :: Bool -> [a] -> [a]
binarypartition takeUpperHalf ls
    | takeUpperHalf = drop n ls
    | otherwise     = take n ls
    where n = (length ls) `div` 2

applybinarypartitions :: [Bool] -> [a] -> [a]
applybinarypartitions [] ls = ls
applybinarypartitions _ (l:[]) = [l]
applybinarypartitions (u:us) ls = applybinarypartitions us $ binarypartition u ls

decodeticket :: String -> Seat
decodeticket t = (row, col)
    where rows = [0..127]
          cols = [0..7]
          rowUs = map (== 'B') $ take 7 t
          colUs = map (== 'R') $ drop 7 t
          row = head $ applybinarypartitions rowUs rows
          col = head $ applybinarypartitions colUs cols

getseatid :: Seat -> Int
getseatid (row, col) = (+) col $ row * 8

getSeatIdMaybe :: Maybe Seat -> Int
getSeatIdMaybe Nothing = error "Oops got nothing"
getSeatIdMaybe (Just s) = getseatid s

maxseatid :: [String] -> Int
maxseatid = maximum . map (getseatid . decodeticket)

sortseats :: [Seat] -> [Seat]
sortseats = sortOn fst . sortOn snd

sortedseats :: [String] -> [Seat]
sortedseats ts = sortseats $ map decodeticket ts

findEmptySeat :: [Seat] -> Maybe Seat
findEmptySeat [] = Nothing
findEmptySeat (_:[]) = Nothing
findEmptySeat (_:_:[]) = Nothing
findEmptySeat ((r0, c0):(r1, c1):xs)
    | r0 /= r1       = findEmptySeat $ x1:xs
    | (c1 - c0) == 2 = Just (r0, c0 + 1)
    | otherwise      = findEmptySeat $ x1:xs
    where x1 = (r1, c1)

main :: IO()
main = interact $ show . getSeatIdMaybe . findEmptySeat . sortedseats . lines
