# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="readline,sqlite"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

MY_PN="sage-setup"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Tool to help install sage and sage related packages"
HOMEPAGE="https://www.sagemath.org"
SRC_URI="$(pypi_sdist_url --no-normalize "${MY_PN}")"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RESTRICT="test"

DEPEND="
	>=dev-python/pkgconfig-1.2.2[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	>=dev-python/cython-0.29.24[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-9.6-verbosity.patch
)

S="${WORKDIR}/${MY_P}"
