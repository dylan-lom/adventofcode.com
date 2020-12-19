-- 20200917 - All tests passing
-- ============================
import Data.List (sort)

solve :: [Int] -> [Int]
solve xs = [sum $ tail $ reverse sorted, sum $ tail sorted]
    where sorted = sort xs

main :: IO()
main = interact $ unwords . map show . solve . map read . words

