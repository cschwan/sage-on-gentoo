# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ipython/ipython-0.10.2.ebuild,v 1.7 2011/07/17 11:52:36 xarthisius Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
# When a new version of this package supports Python 3, then 3.* Python ABIs should be unrestricted in dev-python/ipdb.
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils elisp-common eutils

DESCRIPTION="An interactive computing environment for Python"
HOMEPAGE="http://ipython.scipy.org/ http://pypi.python.org/pypi/ipython"
SRC_URI="http://ipython.scipy.org/dist/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 ~s390 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc emacs examples gnuplot readline smp test wxwidgets"

RDEPEND="dev-python/pexpect
	emacs? (
		app-emacs/python-mode
		virtual/emacs
	)
	gnuplot? ( dev-python/gnuplot-py )
	readline? ( sys-libs/readline )
	smp? (
		dev-python/foolscap
		dev-python/pyopenssl
		net-zope/zope-interface
	)
	wxwidgets? ( dev-python/wxpython )"
DEPEND="${DEPEND}
	test? ( dev-python/nose )"

DOCS="docs/source/changes.txt"
PYTHON_MODNAME="IPython"

SITEFILE="62ipython-gentoo.el"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.9.1-globalpath.patch"
	sed -e "s:share/doc/ipython:share/doc/${PF}:" -i setupbase.py || die "sed failed"

	if ! use doc; then
		sed \
			-e "/extensions/d" \
			-e "s/+ manual_files//" \
			-i setupbase.py || die "sed failed"
	fi

	if ! use examples; then
		sed -e "s/+ example_files//" -i setupbase.py || die "sed failed"
	fi

	# Don't install files requiring Numeric.
	rm -f IPython/numutils.py IPython/UserConfig/ipythonrc-numeric

	# Disable failing test.
	sed -e "s/test_obj_del/_&/" -i IPython/tests/test_magic.py || die "sed failed"

	# Disable tests requiring foolscap when foolscap is unavailable.
	sed -e "/^if not have_twisted:$/i if not have_foolscap:\n    EXCLUDE.append(pjoin('IPython', 'kernel'))\n" -i IPython/testing/iptest.py || die "sed failed"
}

src_compile() {
	distutils_src_compile

	if use emacs; then
		elisp-compile docs/emacs/ipython.el || die "elisp-compile failed"
	fi
}

src_test() {
	testing() {
		"$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" install --home="${WORKDIR}/test-${PYTHON_ABI}" > /dev/null || die "Installation for tests failed with $(python_get_implementation) $(python_get_version)"
		pushd "${WORKDIR}/test-${PYTHON_ABI}" > /dev/null
		# First initialize .ipython stuff.
		PATH="${WORKDIR}/test-${PYTHON_ABI}/bin:${PATH}" PYTHONPATH="${WORKDIR}/test-${PYTHON_ABI}/lib/python" ipython > /dev/null <<-EOF
		EOF
		# Run tests (-v for more verbosity).
		PATH="${WORKDIR}/test-${PYTHON_ABI}/bin:${PATH}" PYTHONPATH="${WORKDIR}/test-${PYTHON_ABI}/lib/python" iptest -v || return 1
		popd > /dev/null
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use emacs; then
		pushd docs/emacs > /dev/null
		elisp-install ${PN} ${PN}.el* || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
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
