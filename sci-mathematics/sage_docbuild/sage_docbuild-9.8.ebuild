# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

MY_PN="sage-docbuild"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Tool to help install sage and sage related packages"
HOMEPAGE="https://www.sagemath.org"
SRC_URI="$(pypi_sdist_url --no-normalize "${MY_PN}")"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RESTRICT="mirror test"

DEPEND=""
RDEPEND="
	>=dev-python/sphinx-5.2.0[${PYTHON_USEDEP}]
	<dev-python/sphinx-6.0.0
	dev-python/jupyter_sphinx[${PYTHON_USEDEP}]
"
PDEPEND="~sci-mathematics/sage-${PV}[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/sage-9.3-linguas.patch
)

S="${WORKDIR}/${MY_P}"
