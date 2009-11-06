# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="This is a sample skeleton ebuild file"
HOMEPAGE="http://linalg.org/"
SRC_URI="http://linalg.org/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE="doc givaro ntl"

CDEPEND="givaro? ( >=sci-libs/givaro-3.2.6 )
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
		$(use givaro && use_with givaro) \
		$(use ntl && use_with ntl) \
		$(use doc && use_enable doc) \
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
