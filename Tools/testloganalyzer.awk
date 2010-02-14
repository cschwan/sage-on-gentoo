# FAI = failed test
# FIL = file name
# NUM = line number
# COM = command
# EXP = expected
# GOT = got
# EXC = exception
# ERR = error

# WARNING: program must be started with --re-interval

function parse_failed_testcases(     filename, linenumber, command, expected, got, exception) {
	# every failed testcase begins with its filename and linenumber
	while ($0 ~ /^File ".+", line [[:digit:]]+/) {
		# save position which failed the test
		filename = gensub(/File "([^"]+)", line ([[:digit:]]+):/, "\\1", "g")
		linenumber = gensub(/File "([^"]+)", line ([[:digit:]]+):/, "\\2", "g")
		getline

		# save command
		command = gensub(/^    sage: /, "", "g")
		getline

		if ($0 ~ /^Expected/) {
			getline

			#
			testcase_failure_begin(filename, linenumber, command)

			do {
				testcase_failure_expected(gensub(/^    /, "", "g"))
				getline
			} while ($0 !~ /^Got/)

			# skip "Got:"
			getline

			do {
				testcase_failure_got(gensub(/^    /, "", "g"))
				getline
			} while ($0 !~ /\*{70}/)

			#
			testcase_failure_end()
		} else if ($0 ~ /^Exception raised/) {
			getline

			#
			testcase_exception_begin(filename, linenumber, command)

			do {
				testcase_exception_text(gensub(/^    /, "", "g"))
				getline
			} while ($0 !~ /\*{70}/)

			#
			testcase_exception_end()
		}

		# skip "***..."
		getline
	}
}

BEGIN {
	begin()
}

/^sage \-t/ {
	# save file name of test
	testcommand = $0

	# go to the next line
	getline

	# look for failed tests
	if ($0 !~ /^[[:blank:]]+\[[[:digit:]]+.[[:digit:]] s\]/ &&
		$0 !~ /^sage \-t/) {
		# lines matching following 70 '*'-chars contain information about failed
		# testcases
		if ($0 ~ /\*{70}/) {
			getline

			# signal failed test
			begin_failed_test(testcommand)
			parse_failed_testcases()
			end_failed_test()
		} else {
			do {
				error = error"\n"$0
				getline
			} while ($0 !~ /^sage \-t/)

			#
			test_error(error)
		}
	}
}

END {
	end()
}
