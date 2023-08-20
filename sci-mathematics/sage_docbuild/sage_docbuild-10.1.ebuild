# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

MY_PN="sage-docbuild"
MY_P="${MY_PN}-${PV}"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3 sage-git
	EGIT_REPO_URI="https://github.com/sagemath/sage.git"
else
	inherit pypi
	SRC_URI="$(pypi_sdist_url --no-normalize "${MY_PN}")"
	KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Tool to help install sage and sage related packages"
HOMEPAGE="https://www.sagemath.org"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RESTRICT="mirror test"

DEPEND=""
RDEPEND="
	>=dev-python/sphinx-5.2.0[${PYTHON_USEDEP}]
	dev-python/jupyter-sphinx[${PYTHON_USEDEP}]
"
PDEPEND="~sci-mathematics/sage-${PV}[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/sage-9.3-linguas.patch
)

python_prepare_all() {
	if [[ ${PV} == 9999 ]]; then
		sage-git_src_prepare "${MY_PN}"
	fi

	distutils-r1_python_prepare_all
}
