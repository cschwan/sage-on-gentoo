# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

# python eclass cruft
PYTHON_DEPEND="*:2.6"
PYTHON_USE_WITH="readline sqlite"
PYTHON_MODNAME="IPython"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5 *-jython *-pypy-*"

inherit distutils elisp-common eutils virtualx

DESCRIPTION="Advanced interactive shell for Python"
HOMEPAGE="http://ipython.org/"
SRC_URI="http://archive.ipython.org/release/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc emacs examples matplotlib mongodb notebook octave
	qt4 +smp test wxwidgets"

CDEPEND="dev-python/decorator
	dev-python/pexpect
	virtual/pyparsing
	dev-python/simplegeneric
	virtual/python-argparse
	emacs? ( app-emacs/python-mode virtual/emacs )
	matplotlib? ( dev-python/matplotlib )
	mongodb? ( dev-python/pymongo )
	octave? ( dev-python/oct2py )
	smp? ( dev-python/pyzmq )
	wxwidgets? ( dev-python/wxpython )"
RDEPEND="${CDEPEND}
	notebook? ( >=www-servers/tornado-2.1
			dev-python/pygments
			dev-python/pyzmq )
	qt4? ( || ( dev-python/PyQt4 dev-python/pyside )
			dev-python/pygments
			dev-python/pyzmq )"
DEPEND="${CDEPEND}
	test? ( dev-python/nose )"

src_prepare() {
	distutils_src_prepare
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
}

src_compile() {
	distutils_src_compile
	use emacs && elisp-compile docs/emacs/ipython.el
}

src_test() {
	# https://github.com/ipython/ipython/issues/2083
	unset PYTHONWARNINGS

	if use mongodb; then
		mkdir -p "${T}/mongo.db"
		mongod --dbpath "${T}/mongo.db" --fork --logpath "${T}/mongo.log"
	fi

	testing() {
		"$(PYTHON)" setup.py \
			build -b "build-${PYTHON_ABI}" \
			install --root="${T}/tests-${PYTHON_ABI}" > /dev/null || die
		# Initialize ~/.ipython directory.
		PATH="${T}/tests-${PYTHON_ABI}${EPREFIX}/usr/bin:${PATH}" \
			PYTHONPATH="${T}/tests-${PYTHON_ABI}${EPREFIX}$(python_get_sitedir)" \
			ipython <<< "" > /dev/null || return 1
		# Run tests (-v for more verbosity).
		PATH="${T}/tests-${PYTHON_ABI}${EPREFIX}/usr/bin:${PATH}" \
			PYTHONPATH="${T}/tests-${PYTHON_ABI}${EPREFIX}$(python_get_sitedir)" \
			iptest -v || return 1
	}
	VIRTUALX_COMMAND="python_execute_function" virtualmake testing

	use mongodb && killall -u "$(id -nu)" mongod
}

src_install() {
	distutils_src_install
	if use emacs; then
		pushd docs/emacs > /dev/null
		elisp-install ${PN} ${PN}.el*
		elisp-site-file-install "${FILESDIR}"/62ipython-gentoo.el
		popd > /dev/null
	fi
}

pkg_postinst() {
	distutils_pkg_postinst
	use emacs && elisp-site-regen
}

pkg_postrm() {
	distutils_pkg_postrm
	use emacs && elisp-site-regen
}
