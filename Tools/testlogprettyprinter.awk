status = 0

function html_escape(text) {
	gsub(/</, "\\&lt;", text)
	gsub(/>/, "\\&gt;", text)

	return text
}

function begin() {
	print "<html>"
	print "<head><title></title></head>"
	print "<body>"
	print "<table border='yes'>"
}

function end() {
	print "</table>"
	print "</body>"
	print "</html>"
}

function testcase_failure_begin(filename, linenumber, command) {
	status = 0

	print "<tr>"
	print "<td>Location</td>"
	print "<td><tt>"filename":"linenumber"</tt></td>"
	print "</tr>"

	print "<tr>"
	print "<td>Command</td>"
	print "<td><tt>"command"</tt></td>"
	print "</tr>"

	print "<tr>"
	print "<td>Expected</td>"
	printf "<td><pre>"
}

function testcase_failure_expected(expected) {
	if (status == 0) {
		status = 1
	} else {
		print ""
	}

	printf html_escape(expected)
}

function testcase_failure_got(got) {
	if (status == 1) {
		print "</pre></td>"
		print "</tr>"

		print "<tr>"
		print "<td>Got</td>"
		printf "<td><pre>"

		status = 2
	} else {
		print ""
	}

	printf html_escape(got)
}

function testcase_failure_end() {
	print "</pre></td>"
	print "</tr>"
}

function testcase_exception_begin(filename, linenumber, command) {

}

function testcase_exception_text(text) {

}

function testcase_exception_end() {

}

function begin_failed_test(testcommand) {

}

function end_failed_test() {

}

function test_error(error) {

}
