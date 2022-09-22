# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="interrupt and signal handling for Cython"
HOMEPAGE="https://github.com/sagemath/cysignals"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/cython-0.29.24[${PYTHON_USEDEP}]
	>=sci-mathematics/pari-2.13.0:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.11.0-helper_loc.patch
	)

python_test(){
	PATH="${BUILD_DIR}/scripts:${PATH}" "${EPYTHON}" -B "${S}"/rundoctests.py "${S}"/src/cysignals/*.pyx
}
