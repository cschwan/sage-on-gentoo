# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

# TODO: find a description

DESCRIPTION=""
HOMEPAGE="http://mpfi.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/22256/mpfi-1.4.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# TODO: is mpfr dependency optional ?

DEPEND="dev-libs/gmp
	dev-libs/mpfr"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--with-gmp-dir=/usr \
		--with-mpfr-dir=/usr \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog NEWS
}
