#!/usr/bin/env sh
#
# CFLAGS=-Ofast

passp() {
	input="$1"
	range="$(echo $input | cut -d' ' -f1)"
	c1="$(echo $range | cut -d'-' -f1)"
	c2="$(echo $range | cut -d'-' -f2)"
	char="$(echo $input | cut -d' ' -f2 | cut -d':' -f1)"
	pass="$(echo $input | cut -d':' -f2)"

	c1_valid="$(echo $pass | cut -c$c1 | test $(cat) = $char && echo 1 || echo 0)"
	c2_valid="$(echo $pass | cut -c$c2 | test $(cat) = $char && echo 1 || echo 0)"
	pass_valid="$(echo \($c1_valid + $c2_valid\) == 1 | bc)"
	echo $pass_valid
}

valid_count=0
while read p; do
	valid_count="$(passp "$p" | echo $(cat) + $valid_count | bc)"
done < input

echo $valid_count
