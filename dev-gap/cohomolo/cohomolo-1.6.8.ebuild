# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Cohomology groups of finite groups on finite modules"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/gap-4.10.1"
RDEPEND="${DEPEND}"

DOCS="CHANGES README.md"
HTML_DOCS=htm/*

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.7-make_install.patch
	"${FILESDIR}"/${PN}-1.6.8-gcc10.patch
	)

pkg_setup(){
	tc-export CC
}

src_configure(){
	# Not a real configure script
	./configure "${EPREFIX}/usr/share/gap"
}

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc gap testdata
	doins *.g
	# do not install standalone/progs.d - it the source code as
	# well as compiled objects for the executables.
	insinto /usr/share/gap/pkg/"${P}"/standalone
	doins -r standalone/data.d standalone/info.d
	# installing executables
	source "${EPREFIX}/usr/share/gap/sysinfo.gap"
	exeinto /usr/share/gap/pkg/"${P}/bin/${GAParch}"
	doexe bin/"${GAParch}"/*
}
