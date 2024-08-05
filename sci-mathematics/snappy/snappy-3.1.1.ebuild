# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
PYTHON_REQ_USE="tk"
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="SnapPy is for studying the topology and geometry of 3-manifolds"
HOMEPAGE="https://github.com/3-manifolds/SnapPy
	https://pypi.org/project/snappy/"
# Not using pypi. Ship with cythonized files without the sources.
SRC_URI="https://github.com/3-manifolds/SnapPy/archive/refs/tags/${PV}_as_released.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/SnapPy-${PV}_as_released"

LICENSE="GPL-2+ BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/cypari2[${PYTHON_USEDEP}]
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/pypng[${PYTHON_USEDEP}]
	virtual/opengl"
RDEPEND="${DEPEND}
	>=sci-mathematics/spherogram-2.1[${PYTHON_USEDEP}]
	>=sci-mathematics/plink-2.4.1[${PYTHON_USEDEP}]
	sci-mathematics/snappy-manifolds[${PYTHON_USEDEP}]
	sci-mathematics/FXrays[${PYTHON_USEDEP}]
	!!dev-python/python-snappy"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/cython-3-linkage.patch
)

distutils_enable_tests setup.py

src_prepare(){
	default
	# TODO completely unvendor togl.
	# Removing vendored togl binaries from the wrong archs
	if use amd64 || use linux-amd64 ; then
		rm -rf python/togl/darwin*
		rm -rf python/togl/win32*
	fi
	# Remove doc_src. If found building doc will be attempted and fail
	# as it requires snappy to be installed
	rm -rf doc_src
}
