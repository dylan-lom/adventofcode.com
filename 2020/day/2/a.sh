#!/usr/bin/env sh
#
# CFLAGS=-Ofast

passp() {
	input="$1"
	range="$(echo $input | cut -d' ' -f1)"
	range_start="$(echo $range | cut -d'-' -f1)"
	range_end="$(echo $range | cut -d'-' -f2)"
	char="$(echo $input | cut -d' ' -f2 | cut -d':' -f1)"
	pass="$(echo $input | cut -d':' -f2)"

	regex="s/$char/$char\n/g"
	num_char="$(echo $pass | sed $regex | wc -l | echo $(cat) - 1 | bc)"
	pass_valid="$(echo $range_start \<= $num_char \&\& $range_end \>= $num_char | bc)"

	echo $pass_valid
}

valid_count=0
while read p; do
	valid_count="$(passp "$p" | echo $(cat) + $valid_count | bc)"
done < input

echo $valid_count
