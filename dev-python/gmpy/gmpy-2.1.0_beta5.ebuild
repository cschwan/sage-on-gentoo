# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1 flag-o-matic

MY_PN="${PN}2"
MY_P="${MY_PN}-$(ver_cut 1-3)b5"

DESCRIPTION="Python bindings for GMP, MPC, MPFR and MPIR libraries"
HOMEPAGE="https://github.com/aleaxit/gmpy"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug doc"

RDEPEND="
	>=dev-libs/mpc-1.0.2
	>=dev-libs/mpfr-3.1.2
	dev-libs/gmp:0="
DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( dev-python/sphinx )"

S="${WORKDIR}"/${MY_P}

pkg_setup(){
	use debug || append-cflags -DNDEBUG
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" test/runtests.py || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
