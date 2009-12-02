# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PN="guava"

DESCRIPTION="GUAVA is a package that implements coding theory algorithms in GAP"
HOMEPAGE="http://sage.math.washington.edu/home/wdj/guava/"
SRC_URI="http://sage.math.washington.edu/home/wdj/${MY_PN}/${MY_PN}${PV}.tar.bz2"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-mathematics/gap"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

S="${WORKDIR}/${MY_PN}${PV}"

src_compile() {
	# not a true configuration script from autoconf.
	./configure /usr/share/gap || die "econf failed"
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	source /usr/share/gap/sysinfo.gap

	exeinto "/usr/share/gap/pkg/${MY_PN}/bin"
	doexe bin/* || die "installation of binaries failed"

	exeinto "/usr/share/gap/pkg/${MY_PN}/bin/leon"
	doexe bin/leon/* || die "installation of leon's binaries failed"

	rm "bin/${GAParch}"/*.o
	exeinto "/usr/share/gap/pkg/${MY_PN}/bin/${GAParch}"
	doexe  "bin/${GAParch}"/* || die "installation of gaparch binaries failed"

	insinto "/usr/share/gap/pkg/${MY_PN}"
	doins -r htm lib tbl guava_gapdoc.gap init.g PackageInfo.g read.g \
		|| die "installation of miscallenous files failed"
	dodoc README.guava COPYING.guava doc/manual.pdf \
		src/leon/doc/leon_guava_manual.pdf
}
