# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Collection of standard data structures for GAP"
HOMEPAGE="https://gap-packages.github.io/datastructures/"
SLOT="0"
SRC_URI="https://github.com/gap-packages/datastructures/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	|| ( >=sci-mathematics/gap-core-4.11.0 >=sci-mathematics/gap-4.11.0 )
	>=dev-gap/GAPDoc-1.6.4"

DOCS="CHANGES.md README.md"

PATCHES=( "${FILESDIR}"/${PN}-0.2.6-headers.patch )

src_prepare(){
	default

	cp -f "${EPREFIX}/usr/share/gap/etc/Makefile.gappkg" .
}

src_configure(){
	# Not a real configure script
	./configure "${EPREFIX}/usr/share/gap"
}

src_compile(){
	# TODO Find ways to reduce this line
	emake V=1
	#emake GAP="${EPREFIX}/usr/bin/gap" GAC="${EPREFIX}/usr/bin/gac" V=1 KEXT_LDFLAGS="-lgap"
}

src_install(){
	# make doesn't have an install target so we cannot use default
	insinto /usr/share/gap/pkg/"${P}"
	doins -r doc gap gen
	doins *.g
	# install the extension
	source "${EPREFIX}/usr/share/gap/sysinfo.gap"
	# dolib.so would add a lib{,64} subfolder
	exeinto "/usr/share/gap/pkg/${P}/bin/${GAParch}"
	doexe "bin/${GAParch}/${PN}.so"
	# install doc
	einstalldocs
}
