# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils autotools

DESCRIPTION="Integer Matrix Library"
HOMEPAGE="http://www.cs.uwaterloo.ca/~astorjoh/iml.html"
SRC_URI="http://www.cs.uwaterloo.ca/~astorjoh/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="mpir"

RESTRICT="mirror"

DEPEND="dev-util/pkgconfig
	mpir? ( sci-libs/mpir )
	!mpir? ( >=dev-libs/gmp-3.1.1 )
	virtual/cblas"
RDEPEND="mpir? ( sci-libs/mpir )
	!mpir? ( >=dev-libs/gmp-3.1.1 )
	virtual/cblas"

src_prepare() {
	# do not need atlas specifically any cblas will do...
	epatch "${FILESDIR}"/${P}-combined-cblas-mpir.patch

	# apply patch supplied by debian bugreport #494819
	epatch "${FILESDIR}"/fix-undefined-symbol.patch

	eautoreconf
}

src_configure() {
	if ( use mpir ); then
		gmplib="-lmpir"
	else
		gmplib="-lgmp"
	fi

	econf \
		--enable-shared \
		--with-cblas-lib="$(pkg-config cblas --libs)" \
		$(use_enable mpir) \
		--with-gmp-lib=${gmplib} \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README || die "dodoc failed"
}
