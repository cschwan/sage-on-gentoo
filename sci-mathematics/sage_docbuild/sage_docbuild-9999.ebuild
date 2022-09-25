# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 git-r3

EGIT_REPO_URI="https://github.com/sagemath/sage.git"
EGIT_BRANCH=develop
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
KEYWORDS=""

DESCRIPTION="Tool to help install sage and sage related packages"
HOMEPAGE="https://www.sagemath.org"
S="${WORKDIR}/${P}/src"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RESTRICT="mirror test"

DEPEND=""
RDEPEND="
	>=dev-python/sphinx-4.3.1[${PYTHON_USEDEP}]
	dev-python/jupyter_sphinx[${PYTHON_USEDEP}]
"
PDEPEND="~sci-mathematics/sage-${PV}[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/sage-9.3-linguas.patch
)

src_unpack(){
	git-r3_src_unpack

	default
}

src_prepare(){
	# Replace setup.* with the file files from the appropriate package.
	# We don't point S to build/pkgs/${PN}/src because patch doesn't work on links
	cp "${WORKDIR}/${P}/build/pkgs/${PN}"/src/setup.* . || die "failed to copy appropriate setuo files"

	default
}
