# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils latex-package

MY_P="sagetex-${PV}"

DESCRIPTION="SageTeX package allows to embed code from the Sage mathematics
software suite into LaTeX documents"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples"

RESTRICT="mirror"

# TODO: Check dependencies
# TODO: enable/disable documentation with USE=doc ?

DEPEND=""
RDEPEND="dev-tex/pgf"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	# LaTeX file are installed by eclass functions
	epatch "${FILESDIR}"/${P}-install-python-files-only.patch
	# Don't regenerate the documentation
	rm *.dtx sagetexpackage.ins

	distutils_src_prepare
}

# TODO: dvis are not correctly rendered
# TODO: install example file with USE=example ?

src_compile() {
	latex-package_src_compile
	distutils_src_compile
}

src_install() {
	if use examples ; then
		dodoc example.tex
	fi
	rm example.tex

	latex-package_src_install
	distutils_src_install
}

pkg_install() {
	einfo "sage-latex needs to connect to sage to work properly."
	einfo "This connection can be local, with a copy of sage installed via portage,"
	einfo "or a remote session of sage thanks to the \"remote-sagetex.py\" script."
	einfo "See the shipped documentation for details."
}
