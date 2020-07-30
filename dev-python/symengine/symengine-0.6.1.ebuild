# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

MYP=${PN}.py-${PV}

DESCRIPTION="Python wrappers to the symengine C++ library"
HOMEPAGE="https://github.com/symengine/symengine.py"
SRC_URI="https://github.com/symengine/symengine.py/archive/v${PV}.tar.gz -> ${MYP}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.1-no_sage_test.patch
)

DOCS=( README.md )

RESTRICT="!test? ( test )"

# Note that the version of symengine officially supported is encoded
# in the file symengine_version.txt
# Only one version of symegine is supported.
RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	~sci-libs/symengine-0.6.0"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/sympy[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MYP}"

src_prepare() {
	default

	rm symengine/tests/test_sage.py || die "Failed to remove outdated sage test"
}

python_test() {
	cd "${BUILD_DIR}" || die
	nosetests -v || die "tests failed with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install
	python_optimize
}

python_install_all() {
	distutils-r1_python_install_all
	rm "${ED}"/usr/share/doc/${PF}/README.md || die
}
