# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cython/cython-0.15.1-r1.ebuild,v 1.1 2012/03/31 19:13:10 floppym Exp $

EAPI="3"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython 2.7-pypy-*"

inherit distutils eutils

MY_PN="Cython"
MY_P="${MY_PN}-${PV/_/}"

DESCRIPTION="Compiler for writing C extensions for the Python language"
HOMEPAGE="http://www.cython.org/ http://pypi.python.org/pypi/Cython"
SRC_URI="http://www.cython.org/release/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="doc examples numpy"

DEPEND="numpy? ( >=dev-python/numpy-1.6.1-r1 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV%_*}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DOCS="README.txt ToDo.txt USAGE.txt"
PYTHON_MODNAME="Cython cython.py pyximport"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-test.patch
}

src_test() {
	testing() {
		"$(PYTHON)" runtests.py -vv --work-dir tests-${PYTHON_ABI}
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	python_generate_wrapper_scripts -E -f -q "${ED}usr/bin/cython"

	if use doc; then
		# "-A c" is for ignoring of "Doc/primes.c".
		dohtml -A c -r Doc/* || die "Installation of documentation failed"
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r Demos/* || die "Installation of examples failed"
	fi
}
