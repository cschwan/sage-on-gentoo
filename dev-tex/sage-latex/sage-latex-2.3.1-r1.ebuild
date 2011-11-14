# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2:2.6:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils latex-package

MY_P="sagetex-${PV}"

DESCRIPTION="SageTeX package allows to embed code from the Sage mathematics software suite into LaTeX documents"
HOMEPAGE="http://www.sagemath.org https://bitbucket.org/ddrake/sagetex/overview"
SRC_URI="http://sage.math.washington.edu/home/release/sage-4.7.2/sage-4.7.2/spkg/standard/${MY_P}.spkg -> ${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RESTRICT="mirror"

DEPEND="sci-mathematics/sage"
RDEPEND="dev-tex/pgf"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	# LaTeX file are installed by eclass functions
	epatch "${FILESDIR}"/${P}-install-python-files-only.patch

	# Don't regenerate the documentation
	rm *.dtx

	distutils_src_prepare
}

src_compile() {
	latex-package_src_compile
	distutils_src_compile
}

src_install() {
	if use examples ; then
		dodoc example.tex || die
	fi

	rm example.tex tkz-* || die "failed to remove example and tkz sty files"

	latex-package_src_install
	distutils_src_install
}

pkg_install() {
	einfo "sage-latex needs to connect to sage to work properly."
	einfo "This connection can be local, with a copy of sage installed via"
	einfo "portage, or a remote session of sage thanks to the"
	einfo "\"remote-sagetex.py\" script."
	einfo "See the shipped documentation for details."
}
