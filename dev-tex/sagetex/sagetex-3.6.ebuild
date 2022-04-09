# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 latex-package

DESCRIPTION="SageTeX allows you to embed Sage code into LaTeX documents"
HOMEPAGE="https://www.sagemath.org https://github.com/dandrake/sagetex"
SRC_URI="https://github.com/sagemath/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="examples"

RESTRICT=primaryuri

DEPEND="app-text/texlive[extra]"
RDEPEND="${DEPEND}
	dev-tex/pgf"

PATCHES=(
	"${FILESDIR}"/${PN}-3.6-install-python-files-only.patch
	)

DOCS="sagetex.pdf"

src_prepare() {
	# Remove some pre-made objects
	# But not the pdf as they require an already installed sagetex to be properly generated.
	rm -f *.sty
	rm -f sagetexparse.py \
		sagetex.py

	distutils-r1_src_prepare
}

src_compile() {
	latex-package_src_compile
	distutils-r1_src_compile
}

src_install() {
	if use examples ; then
		DOCS+=" example.pdf example.tex"
	fi

	# do not rely on latex-package_src_install as it will try building things not meant to be built
	einstalldocs

	latex-package_src_doinstall sty
	distutils-r1_src_install
}

pkg_install() {
	einfo "sagetex needs to connect to sage to work properly."
	einfo "This connection can be local, with a copy of sage installed via"
	einfo "portage, or a remote session of sage thanks to the"
	einfo "\"remote-sagetex.py\" script."
	einfo "See the shipped documentation for details."
}
