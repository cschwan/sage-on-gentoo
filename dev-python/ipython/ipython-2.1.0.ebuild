# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ipython/ipython-1.2.1.ebuild,v 1.2 2014/03/16 02:42:19 vapier Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )
PYTHON_REQ_USE='readline,sqlite'

inherit distutils-r1 elisp-common eutils virtualx

DISTUTILS_IN_SOURCE_BUILD=1

DESCRIPTION="Advanced interactive shell for Python"
HOMEPAGE="http://ipython.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/rel-${PV}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples matplotlib mongodb notebook nbconvert octave
	qt4 +smp test wxwidgets"

PY2_USEDEP=$(python_gen_usedep 'python2*')

gen_python_deps() {
	local flag
	for flag in $(python_gen_useflags '*'); do
		echo "${flag}? ( ${1}[${flag}(-)] )"
	done
}

CDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/simplegeneric[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
	mongodb? ( dev-python/pymongo[${PYTHON_USEDEP}] )
	octave? ( dev-python/oct2py[${PY2_USEDEP}] )
	smp? ( dev-python/pyzmq[${PYTHON_USEDEP}] )
	wxwidgets? ( dev-python/wxpython[${PY2_USEDEP}] )"
RDEPEND="${CDEPEND}
	notebook? (
		>=www-servers/tornado-2.1[${PY2_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/pyzmq[${PYTHON_USEDEP}]
		dev-libs/mathjax
		$(gen_python_deps dev-python/jinja)
	)
	nbconvert? (
		app-text/pandoc
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		$(gen_python_deps dev-python/jinja)
	)
	qt4? ( || ( dev-python/PyQt4[${PYTHON_USEDEP}] dev-python/pyside[${PYTHON_USEDEP}] )
			dev-python/pygments[${PYTHON_USEDEP}]
			dev-python/pyzmq[${PYTHON_USEDEP}] )"
DEPEND="${CDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

PY2_REQUSE="|| ( $(python_gen_useflags python2* ) )"
REQUIRED_USE="
	mongodb? ( ${PY2_REQUSE} )
	notebook? ( ${PY2_REQUSE} )
	octave? ( ${PY2_REQUSE} )
	wxwidgets? ( ${PY2_REQUSE} )"

python_prepare_all() {
	# fix for gentoo python scripts
	sed -i \
		-e "/ipython_cmd/s/ipython3/ipython/g" \
		IPython/terminal/console/tests/test_console.py \
		IPython/testing/tools.py || die

	sed -i \
		-e "s/find_scripts(True, suffix='3')/find_scripts(True)/" \
		setup.py || die

	# fix gentoo installation directory for documentation
	sed -i \
		-e "/docdirbase  = pjoin/s/ipython/${PF}/" \
		-e "/pjoin(docdirbase,'manual')/s/manual/html/" \
		setupbase.py || die "sed failed"

	if ! use doc; then
		sed -i \
			-e "/(pjoin(docdirbase, 'extensions'), igridhelpfiles),/d" \
			-e 's/ + manual_files//' \
			setupbase.py || die
	fi

	if ! use examples; then
		sed -i \
			-e 's/+ example_files//' \
			setupbase.py || die
	fi

	distutils-r1_python_prepare_all
}

src_test() {
	# virtualx has trouble with parallel runs.
	local DISTUTILS_NO_PARALLEL_BUILD=1
	distutils-r1_src_test
}

python_test() {
	# https://github.com/ipython/ipython/issues/2083
	unset PYTHONWARNINGS

	# ipython skips mongodb tests only if it's not running.
	# since we want the widest test range, and don't want it to fiddle
	# with user-running mongodb, we always run it if it's available.

	local DB_IP=127.0.0.1
	local DB_PORT=-1 # disable

	pushd "${BUILD_DIR}"/../IPython/scripts/ > /dev/null

	if has_version dev-db/mongodb; then
		# please keep in sync with dev-python/pymongo

		local dbpath=${TMPDIR}/mongo.db
		local logpath=${TMPDIR}/mongod.log

		# prefer starting with non-default one
		DB_PORT=27018

		mkdir -p "${dbpath}" || die
		while true; do
			ebegin "Trying to start mongod on port ${DB_PORT}"

			LC_ALL=C \
			mongod --dbpath "${dbpath}" --smallfiles --nojournal \
				--bind_ip ${DB_IP} --port ${DB_PORT} \
				--unixSocketPrefix "${TMPDIR}" \
				--logpath "${logpath}" --fork \
			&& sleep 2

			# Now we need to check if the server actually started...
			if [[ ${?} -eq 0 && -S "${TMPDIR}"/mongodb-${DB_PORT}.sock ]]; then
				# yay!
				eend 0
				break
			elif grep -q 'Address already in use' "${logpath}"; then
				# ay, someone took our port!
				eend 1
				: $(( DB_PORT += 1 ))
				continue
			else
				eend 1
				ewarn "Unable to start mongod for tests."
				break
			fi
		done
	fi

	# No support for DB_IP and DB_PORT.
	# https://github.com/ipython/ipython/pull/2910
	sed -i -e "s:Connection(:&host='${DB_IP}', port=${DB_PORT}:" \
		"${BUILD_DIR}"/lib/IPython/parallel/tests/test_mongodb.py \
		|| die "Unable to sed mongod port into tests"

	local fail
	run_tests() {
		# Initialize ~/.ipython directory.
		"${EPYTHON}" ipython </dev/null >/dev/null || fail=1
		# Run tests (-v for more verbosity).
		PYTHONPATH=${PYTHONPATH}:. "${EPYTHON}" iptest -v || fail=1
	}

	VIRTUALX_COMMAND=run_tests virtualmake

	[[ ${DB_PORT} != -1 ]] && mongod --dbpath "${dbpath}" --shutdown
	[[ ${fail} ]] && die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install
	ln -snf "${EPREFIX}"/usr/share/mathjax \
		"${D}$(python_get_sitedir)"/IPython/html/static/mathjax || die

	# Create ipythonX.Y symlinks.
	# TODO:
	# 1. do we want them for pypy?
	# 2. handle it in the eclass instead (use _python_ln_rel).
	if [[ ${EPYTHON} == python* ]]; then
		dosym ../lib/python-exec/${EPYTHON}/ipython \
			/usr/bin/ipython${EPYTHON#python}
	fi
}

python_install_all() {
	distutils-r1_python_install_all
}
