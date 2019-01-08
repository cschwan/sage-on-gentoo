# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Homological Algebra Programming"
HOMEPAGE="http://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION=4.8.6
SRC_URI="https://www.gap-system.org/pub/gap/gap48/tar.bz2/gap4r8p6_2016_11_12-14_25.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/${GAP_VERSION}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}
	dev-gap/polycyclic:${SLOT}
	dev-gap/crystcat:${SLOT}"

S="${WORKDIR}/gap4r8/pkg/Hap${PV}"

src_install(){
	insinto /usr/$(get_libdir)/gap/pkg/Hap"${PV}"
	doins -r doc lib pdfdoc test
	doins *.g boolean

	dodoc README.HAP
}

pkg_postinst(){
	elog "Some optional functions, require the following"
	elog "dependencies to be installed at runtime:"
	elog ""
	elog "sci-mathematics/polymake"
	elog "media-gfx/graphviz"
}
