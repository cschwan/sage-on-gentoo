# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="This is a sample skeleton ebuild file"
HOMEPAGE="http://linalg.org/"
SRC_URI="http://linalg.org/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc ntl sage"

CDEPEND="<sci-libs/givaro-3.3.0
	ntl? ( dev-libs/ntl )"
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}"

src_prepare() {
	if use doc ; then
		epatch "$FILESDIR/${P}-doc-install.patch"
	fi
}

src_configure() {
	econf \
		--with-gmp=/usr \
		--with-blas=/usr \
		--with-givaro=/usr \
		$(use ntl && use_with ntl) \
		$(use doc && use_enable doc) \
		$(use sage && use_enable sage) \
		|| die "econf failed"

	# TODO: It seems to me something isnt correct here
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README NEWS TODO
	if use doc ; then
		dohtml -r doc/linbox-html doc/linbox.html
	fi

	# TODO: install fails with USE=doc
}
