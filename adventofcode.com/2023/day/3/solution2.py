import sys
import typing

Coord = tuple[int, int]
# 😒

lines = [line.strip() for line in sys.stdin]

def isOutOfBounds(x, y) -> bool:
	if (x < 0 or x >= len(lines[0])): return True
	if (y < 0 or y >= len(lines)): return True
	return False

def isBlank(x, y) -> bool:
	if isOutOfBounds(x, y): return False
	return lines[y][x] == '.'

def isDigit(x, y) -> bool:
	if isOutOfBounds(x, y): return False
	return lines[y][x].isdigit()

def isSymbol(x, y) -> bool:
	return not isDigit(x, y) and not isBlank(x, y)

def isGearSymbol(x, y) -> bool:
	return isSymbol(x, y) and lines[y][x] == '*'

def adjacent(x, y) -> list[Coord]:
	return [
		(x-1, y-1),
		(x, y-1),
		(x+1, y-1),
		(x-1, y),
		(x+1, y),
		(x-1, y+1),
		(x, y+1),
		(x+1, y+1)
	]

# pass 1 - find candidate numbers
gearRatios: list[tuple[Coord, Coord]] = []
for y in range(len(lines)):
	for x in range(len(lines[0])):
		if (not isGearSymbol(x, y)): continue
		adjacentDigits = list(filter(
			lambda cs: isDigit(*cs),
			adjacent(x, y)
		))

		# exclude contiguous runs (ie. if 12. is above, should only occur once)
		adjacentDigitsCondensed = list(filter(
			lambda cs: (cs[0]-1, cs[1]) not in adjacentDigits,
			adjacentDigits
		))

		if (len(adjacentDigitsCondensed) == 2):
			gearRatios.append((adjacentDigitsCondensed[0], adjacentDigitsCondensed[1]))

def extractNumber(x, y):
	startX = x
	while (isDigit(startX, y)): startX -= 1
	startX += 1

	endX = x
	while (isDigit(endX, y)): endX += 1

	n = int(lines[y][startX:endX])
	return n

# pass 2 - accumulate gearRatios into sum
sum = 0
for c1, c2 in gearRatios:
	n1 = extractNumber(*c1)
	n2 = extractNumber(*c2)
	sum += n1 * n2

print(sum)

