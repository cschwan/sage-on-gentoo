# FAI = failed test
# FIL = file name
# NUM = line number
# COM = command
# EXP = expected
# GOT = got
# EXC = exception
# ERR = error

# WARNING: program must be started with --re-interval

function parse_failed_testcases() {
	# every failed testcase begins with its filename and linenumber
	while ($0 ~ /^File ".+", line [[:digit:]]+/) {
		print "<<FIL>>"
		print gensub(/File "([^"]+)", line ([[:digit:]]+):/, "\\1", "g")
		print "<<NUM>>"
		print gensub(/File "([^"]+)", line ([[:digit:]]+):/, "\\2", "g")
		getline

		# save command
		print "<<COM>>"
		print gensub(/^    sage: /, "", "g")
		getline

		if ($0 ~ /^Expected/) {
			getline
			print "<<EXP>>"

			do {
				print gensub(/^    /, "", "g")
				getline
			} while ($0 !~ /^Got/)

			# skip "Got:"
			getline
			print "<<GOT>>"

			do {
				print gensub(/^    /, "", "g")
				getline
			} while ($0 !~ /\*{70}/)
		} else if ($0 ~ /^Exception raised/) {
			getline
			print "<<EXC>>"

			do {
				print gensub(/^    /, "", "g")
				getline
			} while ($0 !~ /\*{70}/)
		}

		# skip "***..."
		getline
	}
}

/^sage \-t/ {
	# save file name of test
	test = $0

	# go to the next line
	getline

	# look for failed tests
	if ($0 !~ /^[[:blank:]]+\[[[:digit:]]+.[[:digit:]] s\]/ &&
		$0 !~ /^sage \-t/) {
		# lines matching following 70 '*'-chars contain information about failed
		# testcases
		if ($0 ~ /\*{70}/) {
			getline

			# TODO: fix regular expression
			print "<<FAI>>"
			print gensub(/sage \-t  "([^"]+)"/, "\\1", "g", test)

			parse_failed_testcases()
		} else {
			print "<<ERR>>"

			do {
				print $0
				getline
			} while ($0 !~ /^sage \-t/)
		}
	}
}
