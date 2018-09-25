# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1 flag-o-matic

MY_PN="${PN}2"
MY_P="${MY_PN}-$(ver_cut 1-3)a2"

DESCRIPTION="Python bindings for GMP, MPC, MPFR and MPIR libraries"
HOMEPAGE="https://github.com/aleaxit/gmpy"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug doc mpir"

RDEPEND="
	>=dev-libs/mpc-1.0.2
	>=dev-libs/mpfr-3.1.2
	!mpir? ( dev-libs/gmp:0= )
	mpir? ( sci-libs/mpir )"
DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

S="${WORKDIR}"/${MY_P}

pkg_setup(){
	use debug || append-cflags -DNDEBUG
}

# Massive hack until I find how to do it properly.
# gmpy2 needs to instal .pxd and .h for pplpy.
python_prepare(){
	cp gmpy2/* src/
	rm -rf gmpy2
	mv src gmpy2
	sed -i "s:src:gmpy2:g" setup.py
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
