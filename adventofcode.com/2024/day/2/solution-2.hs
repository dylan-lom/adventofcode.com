import Data.List
import qualified Data.Set as Set

input = "7 6 4 2 1\n1 2 7 8 9\n9 7 6 2 1\n1 3 2 4 5\n8 6 4 4 1\n1 3 6 7 9"

isGradual :: [Integer] -> Bool
isGradual xs = maximum steps <= 3
    where z = zip xs (drop 1 xs)
          steps = map (\(a,b) -> abs $ a-b) z

isUniq :: Ord a => [a] -> Bool
isUniq xs = length xs == (length $ Set.fromList xs)
 
isAsc :: Ord a => [a] -> Bool
isAsc xs = xs == sorted
    where sorted = sort xs

isDesc :: Ord a => [a] -> Bool
isDesc = isAsc . reverse

isSafe :: [Integer] -> Bool
isSafe xs = isGradual xs && isUniq xs && (isAsc xs || isDesc xs)

splice :: Int -> Int -> [a] -> [a]
splice i j xs = front ++ back 
    where front = take i xs
          back = drop j xs

canBeSafe :: [Integer] -> Bool
canBeSafe xs = not $ null $ dropWhile (not . isSafe) variations
    where is = take (length xs) [0..]
          variations = [xs] ++ map (\i -> splice i (i+1) xs) is

solve :: [[Integer]] -> Int
solve = length . filter (True ==) . map canBeSafe

parse :: String -> [[Integer]]
parse = map (map read) . map words . lines

main :: IO()
main = interact $ show . solve . parse
