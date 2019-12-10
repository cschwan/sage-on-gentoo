# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 latex-package

MY_PN="sagetex"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="SageTeX allows you to embed Sage code into LaTeX documents"
HOMEPAGE="http://www.sagemath.org https://github.com/dandrake/sagetex"
SRC_URI="https://github.com/sagemath/${MY_PN}/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="examples"

RESTRICT="mirror"

DEPEND="app-text/texlive[extra]"
RDEPEND="${DEPEND}
	dev-tex/pgf"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0-install-python-files-only.patch
	)

S="${WORKDIR}"/${MY_P}

src_prepare() {
	# Remove pre-made objects
	rm -f *.pdf *.sty
	rm -f extractsagecode.py \
		makestatic.py \
		remote-sagetex.py \
		run-sagetex-if-necessary.py \
		sagetexparse.py \
		sagetex.py

	# move stuff around so building doc do not break
	mkdir sub || die "faile to create sub"
	for i in scripts.dtx remote-sagetex.dtx py-and-sty.dtx; do
		mv "${i}" sub/ || die "failed to move ${i} to sub"
		sed -i "s:${i}:sub/${i}:g" sagetex.dtx sagetex.ins || die "failed to change ${i} in sagetex.*"
	done

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
