# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ipython/ipython-0.13.2.ebuild,v 1.9 2013/09/12 22:29:31 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )
PYTHON_REQ_USE='readline,sqlite'

inherit distutils-r1 elisp-common eutils virtualx

DESCRIPTION="Advanced interactive shell for Python"
HOMEPAGE="http://ipython.org/"
SRC_URI="http://archive.ipython.org/release/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="doc emacs examples matplotlib mongodb notebook octave
	qt4 +smp test wxwidgets"

PY2_USEDEP=$(python_gen_usedep 'python2*')

CDEPEND="dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/pexpect[${PY2_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/simplegeneric[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	emacs? ( app-emacs/python-mode virtual/emacs )
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
	mongodb? ( dev-python/pymongo[${PY2_USEDEP}] )
	octave? ( dev-python/oct2py[${PY2_USEDEP}] )
	smp? ( dev-python/pyzmq[${PYTHON_USEDEP}] )
	wxwidgets? ( dev-python/wxpython[${PY2_USEDEP}] )"
RDEPEND="${CDEPEND}
	notebook? ( >=www-servers/tornado-2.1[${PY2_USEDEP}]
			dev-python/pygments[${PYTHON_USEDEP}]
			dev-python/pyzmq[${PYTHON_USEDEP}] )
	qt4? ( || ( dev-python/PyQt4[${PYTHON_USEDEP}] dev-python/pyside[${PYTHON_USEDEP}] )
			dev-python/pygments[${PYTHON_USEDEP}]
			dev-python/pyzmq[${PYTHON_USEDEP}] )"
DEPEND="${CDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

PY2_REQUSE="|| ( $(python_gen_useflags python2* ) )"
REQUIRED_USE="mongodb? ( ${PY2_REQUSE} )
	notebook? ( ${PY2_REQUSE} )
	octave? ( ${PY2_REQUSE} )
	wxwidgets? ( ${PY2_REQUSE} )"
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	epatch "${FILESDIR}"/${PN}-0.12-globalpath.patch
	epatch "${FILESDIR}"/${PN}-history-backport.patch
	epatch "${FILESDIR}"/prun_timeit_magics.patch

	# fix for gentoo python scripts
	sed -i \
		-e "/ipython_cmd/s/ipython3/ipython/g" \
		IPython/frontend/terminal/console/tests/test_console.py \
		IPython/lib/irunner.py \
		IPython/testing/tools.py || die

	sed -i \
		-e "s/find_scripts(True, suffix='3')/find_scripts(True)/" \
		setup.py || die

	# disable failing tests
	sed -i \
		-e 's/test_pylab_import_all_disabled/_&/' \
		-e 's/test_pylab_import_all_enabled/_&/' \
		IPython/lib/tests/test_irunner_pylab_magic.py || die

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

	# testsuite runs fine with in source

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use emacs && elisp-compile docs/emacs/ipython.el
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
		"${PYTHON}" ipython </dev/null >/dev/null || fail=1
		# Run tests (-v for more verbosity).
		PYTHONPATH=${PYTHONPATH}:. "${PYTHON}" iptest -v || fail=1
	}

	VIRTUALX_COMMAND=run_tests virtualmake

	[[ ${DB_PORT} != -1 ]] && mongod --dbpath "${dbpath}" --shutdown
	[[ ${fail} ]] && die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	if use emacs; then
		cd docs/emacs || die
		elisp-install ${PN} ${PN}.el*
		elisp-site-file-install "${FILESDIR}"/62ipython-gentoo.el
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
