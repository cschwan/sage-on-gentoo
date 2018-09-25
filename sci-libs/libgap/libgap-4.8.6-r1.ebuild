# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A cython library interface to gap for sage"
HOMEPAGE="https://bitbucket.org/vbraun/libgap"
SRC_URI="mirror://sageupstream/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos ~x86-macos"
IUSE="static-libs"

DEPEND=">=dev-libs/gmp-5.0.2
	~sci-mathematics/gap-${PV}"
RDEPEND="${DEPEND}"

src_prepare(){
	# location of the gap install
	sed \
		-e "s:/home/vbraun/Sage/sage/local/gap/latest:${EPREFIX}/usr/$(get_libdir)/gap:" \
		-e "s:/home/vbraun/Sage/git/local/gap/latest:${EPREFIX}/usr/$(get_libdir)/gap:" \
		-i test/*.c

	default
}

src_configure(){
	source "${EPREFIX}"/etc/sysinfo.gap

	econf \
		$(use_enable static-libs static) \
		--with-sage="${EPREFIX}"/usr \
		--with-gap_system_arch=$GAParch_system
}

src_install(){
	default
	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
