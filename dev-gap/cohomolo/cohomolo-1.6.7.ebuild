# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Cohomology groups of finite groups on finite modules"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION="4.10.0"
SLOT="0/${GAP_VERSION}"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-mathematics/gap:${SLOT}"
RDEPEND="${DEPEND}"

DOCS="CHANGES README.md"
HTML_DOCS=htm/*

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.7-make_install.patch
	)

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${P}"

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
