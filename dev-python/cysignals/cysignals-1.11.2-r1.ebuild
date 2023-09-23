# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="interrupt and signal handling for Cython"
HOMEPAGE="https://github.com/sagemath/cysignals"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/pari-2.13.0:="
RDEPEND="${DEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${PN}-1.11.0-helper_loc.patch
)

src_prepare() {
	if has_version ">=dev-python/cython-3.0.0"; then
		PATCHES+=( "${FILESDIR}"/cython-3.patch )
	fi

	distutils-r1_python_prepare_all
}

python_test(){
	PATH="${BUILD_DIR}/scripts:${PATH}" "${EPYTHON}" -B "${S}"/rundoctests.py "${S}"/src/cysignals/*.pyx
}
