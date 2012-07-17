# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cython/cython-0.15.1-r1.ebuild,v 1.1 2012/03/31 19:13:10 floppym Exp $

EAPI="3"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython 2.7-pypy-*"

inherit distutils eutils

DESCRIPTION="Compiler for writing C extensions for the Python language"
HOMEPAGE="http://www.cython.org/ http://pypi.python.org/pypi/Cython"
SRC_URI="http://sage.math.washington.edu/home/release/sage-5.2.rc0/sage-5.2.rc0/spkg/standard/cython-0.17pre.spkg -> ${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/cython-0.17pre/src"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DOCS="README.txt ToDo.txt USAGE.txt"
PYTHON_MODNAME="Cython cython.py pyximport"

src_test() {
	testing() {
		"$(PYTHON)" runtests.py -vv --work-dir tests-${PYTHON_ABI}
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	python_generate_wrapper_scripts -E -f -q "${ED}usr/bin/cython"
}
