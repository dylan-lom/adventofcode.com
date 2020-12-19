input = "5\n1000000001 1000000002 1000000003 1000000004 1000000005"

main :: IO()
main = interact $ show . sum . map read . tail . words
