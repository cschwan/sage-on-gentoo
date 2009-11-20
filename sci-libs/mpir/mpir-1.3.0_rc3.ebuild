# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils versionator autotools

DESCRIPTION="MPIR is a library for arbitrary precision arithmetic"
HOMEPAGE="http://www.mpir.org/"
SRC_URI="http://www.mpir.org/${PN}-$(replace_version_separator 3 -).tar.gz"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="cxx cpudetection"

# Beware: cpudetection aka fat binaries only works on x86/amd64
# When we enable more cpus we will have to carefully filter.

DEPEND="dev-lang/yasm"
RDEPEND=""

# TODO: add more USE-flags: readline? fft? malloc?
#	beware yasm is x86/amd64 only! filter it when we add more platforms
#	furthermore yasm do not appear to be used on my system (fbissey)

src_prepare(){
	epatch "${FILESDIR}/${P}-yasm.patch"
	epatch "${FILESDIR}/${P}-fix-yasm-path.patch"
	eautoreconf
}

src_configure() {
	# causes problems on amd64
	unset ABI

	# may help to fix the amd64 problem
	local ADDITIONAL_FLAGS="$(use amd64 && echo -m64)"

	econf CFLAGS="${CFLAGS} ${ADDITIONAL_FLAGS}" \
		CXXFLAGS="${CXXFLAGS} ${ADDITIONAL_FLAGS}" \
		$(use_enable cxx) \
		$(use_enable cpudetection fat) \
		|| "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README NEWS
}
