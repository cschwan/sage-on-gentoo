escons() {
	# extract number of jobs to run parallel
	local sconsjobs=$(echo ${MAKEOPTS} | \
		grep -oEe "-{1,2}j(obs)?[ =]?[[:digit:]]+")

	# disable cache because it wont be needed
	scons --cache-disable ${sconsjobs} "$@" || die
}
