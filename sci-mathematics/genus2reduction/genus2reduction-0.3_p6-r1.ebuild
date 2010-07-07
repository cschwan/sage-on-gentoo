# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit toolchain-funcs sage versionator eutils

MY_P="${PN}-$(replace_version_separator 2 '.')"

DESCRIPTION="Conductor and Reduction Types for Genus 2 Curves"
HOMEPAGE="http://www.math.u-bordeaux.fr/~liu/G2R/"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="mpir -pari24"

RESTRICT="mirror"

RDEPEND="pari24? ( sci-mathematics/pari:3[gmp] )
	!pari24? ( mpir? ( >=sci-mathematics/pari-2.3.3:0[mpir] )
		  !mpir? (  >=sci-mathematics/pari-2.3.3:0[gmp] ) )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	if use pari24 ; then
		sed -i \
			-e "s:pari:pari24/pari:" \
			-e "s:polun:pol_1:g" \
			-e "s:polx:pol_x:g" \
			-e "s:=zero:=(long)gen_0:g" \
			-e "s:=un:=(long)gen_1:g" \
			${PN}.c || die "patching for pari-2.4 failed."
	# FIXME we are missing a replacement for gi
	else
		sed -i "s:pari:pari/pari:" ${PN}.c || die "patching for pari-2.3 failed."
	fi
}

src_compile() {

	local mylflags=""
	if use pari24 ; then
		mylflags="${mylflags} -lpari24"
	else
		mylflags="${mylflags} -lpari"
	fi

	if use mpir ; then
		mylflags="${mylflags} -lmpir -lm"
	else
		mylflags="${mylflags} -lgmp -lm"
	fi

	$(tc-getCC ) ${CFLAGS} -o ${PN} ${PN}.c ${mylflags} || die "Compile failed!"
}

src_install() {
	dobin ${PN} || die "installation failed!"
	dodoc README RELEASE.NOTES WARNING
}
