# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cython/cython-0.20.ebuild,v 1.2 2014/01/31 07:42:01 jlec Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} pypy2_0 )

inherit distutils-r1 flag-o-matic

MY_PN="Cython"
MY_P="${MY_PN}-${PV/_/}"

DESCRIPTION="A Python to C compiler"
HOMEPAGE="http://www.cython.org/ http://pypi.python.org/pypi/Cython"
SRC_URI="http://www.cython.org/release/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris ~x64-solaris"
IUSE="doc test"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/numpy[$(python_gen_usedep python{2_6,2_7,3_2,3_3})] )"

S="${WORKDIR}/${MY_PN}-${PV%_*}"

python_compile() {
	if [[ ${EPYTHON} == python2* ]]; then
		local CFLAGS CXXFLAGS
		append-flags -fno-strict-aliasing
	fi

	# Python gets confused when it is in sys.path before build.
	local PYTHONPATH
	export PYTHONPATH

	distutils-r1_python_compile
}

python_compile_all() {
	use doc && unset XDG_CONFIG_HOME && emake -C docs html
}

python_test() {
	"${PYTHON}" runtests.py -vv --work-dir "${BUILD_DIR}"/tests \
		|| die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGES.rst README.txt ToDo.txt USAGE.txt )
	use doc && local HTML_DOCS=( docs/build/html/. )

	distutils-r1_python_install_all
}
