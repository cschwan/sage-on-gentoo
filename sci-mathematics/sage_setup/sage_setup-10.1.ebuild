# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="readline,sqlite"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

MY_PN="sage-setup"
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

DEPEND="
	>=dev-python/pkgconfig-1.2.2[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	<dev-python/cython-3.0.0[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-9.6-verbosity.patch
)

python_prepare_all() {
	if [[ ${PV} == 9999 ]]; then
		sage-git_src_prepare "${MY_PN}"
	fi

	distutils-r1_python_prepare_all
}
