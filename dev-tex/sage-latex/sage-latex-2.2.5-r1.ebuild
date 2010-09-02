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
IUSE=""

RESTRICT="mirror"

# TODO: Check dependencies
# TODO: enable/disable documentation with USE=doc ?

DEPEND=">=dev-tex/tkz-berge-2.8
	sci-mathematics/sage"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	# LaTeX file are installed by eclass functions
	epatch "${FILESDIR}"/${P}-install-python-files-only.patch

	distutils_src_prepare
}

# TODO: dvis are not correctly rendered
# TODO: install example file with USE=example ?

src_compile() {
	latex-package_src_compile
	distutils_src_compile
}

src_install() {
	latex-package_src_install
	distutils_src_install
}
