# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

Parent_PN="p_group_cohomology"
Parent_P="${Parent_PN}-${PV}"
DESCRIPTION="Modular Cohomology Rings of Finite Groups"
HOMEPAGE="https://users.fmi.uni-jena.de/cohomology/"
SRC_URI="https://github.com/sagemath/${Parent_PN}/releases/download/v${PV}/${Parent_P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=sci-mathematics/sage-9.3[meataxe,${PYTHON_USEDEP}]
	sci-mathematics/shared_meataxe
	sci-mathematics/modular_resolution"
RDEPEND="${DEPEND}
	dev-gap/p_group_cohomology_helper
	sci-mathematics/singular"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]
	<dev-python/cython-3.0.0"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3.2-pyx.patch
	"${FILESDIR}"/${PN}-3.3.2-local.patch
	"${FILESDIR}"/${PN}-3.3.2-str.patch
)

S="${WORKDIR}/${Parent_P}/${P}"

# NOTE: building html doc would require installing sage_setup.
python_install_all(){
	distutils-r1_python_install_all

	# install singular helper
	insinto /usr/share/singular/LIB
	doins "${WORKDIR}/${Parent_P}"/singular_helper/dickson.lib
}
