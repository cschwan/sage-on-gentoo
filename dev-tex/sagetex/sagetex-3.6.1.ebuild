# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 latex-package

DESCRIPTION="SageTeX allows you to embed Sage code into LaTeX documents"
HOMEPAGE="https://github.com/sagemath/sagetex https://pypi.org/project/sagetex/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

DEPEND="app-text/texlive[extra]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	sci-mathematics/sage[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-tex/pgf"

PATCHES=(
	"${FILESDIR}"/${PN}-3.6-install-python-files-only.patch
	)

DOCS="example.tex sagetex.pdf example.pdf"

src_prepare() {
	default
	# remove distributed sagetex.{sty,py}/sagetexparse.py files
	rm sagetex.sty || die "cannot remove sagetex.sty files"
	rm sagetex.py  || die "cannot remove sagetex.py  files"
	rm sagetexparse.py  || die "cannot remove sagetexparse.py  files"
}

src_compile() {
	latex-package_src_compile

	distutils-r1_src_compile
}

src_install() {
	latex-package_src_doinstall sty

	distutils-r1_src_install
}
