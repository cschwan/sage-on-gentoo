# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="readline,sqlite"
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1 prefix toolchain-funcs

MY_PN="sage-setup"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Tool to help install sage and sage related packages"
HOMEPAGE="https://www.sagemath.org"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RESTRICT="test"

DEPEND="
	>=dev-python/cython-0.29.24[${PYTHON_USEDEP}]
	>=dev-python/pkgconfig-1.2.2[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	!<=sci-mathematics/sage-9.4
"

PATCHES=(
	"${FILESDIR}"/${PN}-9.5-options.patch
	"${FILESDIR}"/${PN}-9.6-no_build.patch
)

S="${WORKDIR}/${MY_P}"
