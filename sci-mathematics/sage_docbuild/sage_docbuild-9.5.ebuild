# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

MY_PN="sage-docbuild"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Tool to documentation for sage and sage related packages"
HOMEPAGE="https://www.sagemath.org"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RESTRICT="test"

DEPEND=""
RDEPEND="
	>=dev-python/sphinx-4.3.1[${PYTHON_USEDEP}]
"
PDEPEND=">=sci-mathematics/sage-9.5[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/sage-9.3-linguas.patch
)

S="${WORKDIR}/${MY_P}"
