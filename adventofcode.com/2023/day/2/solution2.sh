#!/bin/sh

sum=0

while read line; do
	colors="$(echo "$line" | cut -d ':' -f2 \
		| tr -d ' ' \
		| tr '[,;]' '\n')"

	red=$(echo "$colors" | grep 'red' | tr -d '[a-z]' | sort -n | tail -1)
	blue=$(echo "$colors" | grep 'blue' | tr -d '[a-z]' | sort -n | tail -1)
	green=$(echo "$colors" | grep 'green' | tr -d '[a-z]' | sort -n | tail -1)

	sum=$((sum + (red * blue * green)))
done

echo $sum
