# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Homological Algebra Programming"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
GAP_VERSION=4.10.2
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/${GAP_VERSION}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}
	>=dev-gap/aclib-1.3.1
	>=dev-gap/polycyclic-2.14
	>=dev-gap/crystcat-1.1.9
	>=dev-gap/fga-1.4.0"

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/Hap${PV}"

DOCS="README.HAP"
HTML_DOCS=www/*

src_install(){
	default

	insinto /usr/share/gap/pkg/Hap"${PV}"
	doins -r doc lib pdfdoc
	doins *.g boolean
}

pkg_postinst(){
	elog "Some optional functions, require the following"
	elog "dependencies to be installed at runtime:"
	elog ""
	elog "sci-mathematics/polymake"
	elog "media-gfx/graphviz"
}
