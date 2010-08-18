# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils toolchain-funcs versionator

MY_P="${PN}-$(replace_version_separator 2 '.')"

DESCRIPTION="Conductor and Reduction Types for Genus 2 Curves"
HOMEPAGE="http://www.math.u-bordeaux.fr/~liu/G2R/"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="mpir"

RESTRICT="mirror"

RDEPEND="mpir? ( >=sci-mathematics/pari-2.3.3:0[mpir] )
	!mpir? (  >=sci-mathematics/pari-2.3.3:0[gmp] )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.3.p2.patch
}

src_compile() {
	local mylib="-lgmp"

	if use mpir ; then
		mylib="-mpir"
	fi

	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} ${PN}.c -lpari ${mylib} -lm \
		|| die "compilation of source failed"
}

src_install() {
	dobin ${PN} || die "installation failed!"
	dodoc README RELEASE.NOTES WARNING || die
}
