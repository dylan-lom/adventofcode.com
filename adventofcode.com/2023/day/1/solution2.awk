#nb. babbies first awk program :^)
BEGIN { sum = 0 }

/^/ {
	#lol

	for (i = 0; i < length($0); i += 1) {
		s = substr($0, i)
		if (s ~ /^one/) sub(/one/, "1")
		if (s ~ /^two/) sub(/two/, "2")
		if (s ~ /^three/) sub(/three/, "3")
		if (s ~ /^four/) sub(/four/, "4")
		if (s ~ /^five/) sub(/five/, "5")
		if (s ~ /^six/) sub(/six/, "6")
		if (s ~ /^seven/) sub(/seven/, "7")
		if (s ~ /^eight/) sub(/eight/, "8")
		if (s ~ /^nine/) sub(/nine/, "9")
		# print i ":" $0
	}

	gsub(/[^0-9]/, "")
	# print $0,  substr($0, 1, 1), substr($0, length($0), 1)
	sum += substr($0, 1, 1) substr($0, length($0), 1)
}

END { print sum }
