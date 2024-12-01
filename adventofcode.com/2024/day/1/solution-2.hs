import Data.List

input = "3   4\n4   3\n2   5\n1   3\n3   9\n3   3"

rezip :: ([a], [b]) -> [(a, b)]
rezip (xs, ys) = zip xs ys

similarity :: [Integer] -> Integer -> Integer
similarity ys x = x * y
    where y = toInteger $ length $ filter (\y -> x == y) ys

both :: (a -> b) -> (a, a) -> (b, b)
both f (x, y) = (f x, f y)

-- < https://stackoverflow.com/a/7418828
split :: [a] -> ([a], [a])
split xs = (odds xs, evens xs)

odds :: [a] -> [a]
odds (x:xs) = x : evens xs
odds xs     = []

evens :: [a] -> [a]
evens xs = odds (drop 1 xs)
-- / https://stackoverflow.com/a/7418828 >

solve :: [Integer] -> Integer
solve = sum . (\(xs, ys) -> map (similarity ys) xs) . split

main :: IO()
main = interact $ show . solve . map read . words

