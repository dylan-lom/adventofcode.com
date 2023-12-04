import sys
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

def adjacent(x, y) -> list[tuple[int, int]]:
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
candidates: list[tuple[int, int]] = []
for y in range(len(lines)):
	for x in range(len(lines[0])):
		if (not isSymbol(x, y)): continue
		for x2, y2 in adjacent(x, y):
			if isDigit(x2, y2):
				candidates.append((x2, y2))

# pass 2 - accumulate candidates into sum
sum = 0
processed: list[tuple[int, int]] = []
for x, y in candidates:
	if (x, y) in processed: continue

	startX = x
	while (isDigit(startX, y)): startX -= 1
	startX += 1

	endX = x
	while (isDigit(endX, y)): endX += 1

	n = int(lines[y][startX:endX])

	sum += n
	processed += zip(range(startX, endX), [y] * (endX - startX))

print(sum)

