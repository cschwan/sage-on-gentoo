# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="interrupt and signal handling for Cython"
HOMEPAGE="https://github.com/sagemath/cysignals"
SRC_URI="https://github.com/sagemath/cysignals/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/cython-0.25[${PYTHON_USEDEP}]
	>=sci-mathematics/pari-2.9.0:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.2-helper_loc.patch
	)

python_test(){
	PATH="${BUILD_DIR}/scripts:${PATH}" "${EPYTHON}" -B "${S}"/rundoctests.py "${S}"/src/cysignals/*.pyx
}
