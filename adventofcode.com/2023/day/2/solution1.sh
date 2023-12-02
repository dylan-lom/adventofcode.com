#!/bin/sh

grep -vE '((1[3-9]|[2-9][0-9]) red)|(1[4-9]|[2-9][0-9]) green|(1[5-9]|[2-9][0-9]) blue' \
	| cut -d ':' -f1 \
	| cut -d ' ' -f2 \
	| tr '\n' '+' \
	| echo "$(cat) 0" \
	| bc

