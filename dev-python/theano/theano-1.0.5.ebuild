# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1 eutils

DESCRIPTION="Define and optimize multi-dimensional arrays mathematical expressions"
HOMEPAGE="https://github.com/Theano/Theano"
SRC_URI="mirror://pypi/T/${PN^}/${PN^}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
		dev-python/pyflakes[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${PN^}-${PV}"

src_prepare(){
	default

	rm theano/tests/test_flake8.py || die "Failed to remove flaky test test_flake8.py"
}

python_test() {
	distutils_install_for_testing
	nosetests --verbosity=3 || die
}

pkg_postinst() {
	optfeature "Make picture of Theano computation graph" dev-python/pydot-ng
	optfeature "Required for GPU/CPU code generation" dev-python/pygpu
}
