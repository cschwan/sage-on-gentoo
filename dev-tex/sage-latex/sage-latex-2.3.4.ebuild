# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 latex-package

MY_PN="sagetex"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="SageTeX package allows to embed code from the Sage mathematics software suite into LaTeX documents"
HOMEPAGE="http://www.sagemath.org https://bitbucket.org/ddrake/sagetex/overview"
SRC_URI="mirror://sageupstream/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-macos"
IUSE="examples"

RESTRICT="mirror"

DEPEND=""
RDEPEND="dev-tex/pgf"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	# LaTeX file are installed by eclass functions
	epatch "${FILESDIR}"/${PN}-2.3.4-install-python-files-only.patch

	# Don't regenerate the documentation
	rm *.dtx

	distutils-r1_src_prepare
}

src_compile() {
	latex-package_src_compile
	distutils-r1_src_compile
}

src_install() {
	if use examples ; then
		dodoc example.tex
	fi

	rm example.tex || die "failed to remove example file"

	latex-package_src_install
	distutils-r1_src_install
}

pkg_install() {
	einfo "sage-latex needs to connect to sage to work properly."
	einfo "This connection can be local, with a copy of sage installed via"
	einfo "portage, or a remote session of sage thanks to the"
	einfo "\"remote-sagetex.py\" script."
	einfo "See the shipped documentation for details."
}
