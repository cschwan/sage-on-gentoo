# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils multilib flag-o-matic

DESCRIPTION="Fast Library for Number Theory"
HOMEPAGE="http://www.flintlib.org/"
SRC_URI="http://www.flintlib.org/${P}.tar.gz"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x86-macos ~x64-macos ~amd64-linux ~x86-linux"
IUSE="-static"

DEPEND="dev-libs/mpfr
	dev-libs/ntl
	sci-libs/mpir
	"
RDEPEND="${DEPEND}"

pkg_setup(){
	if [[ ${CHOST} == *-darwin* ]] ; then
		append-flags -fno-common
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/flint-2.3-build.patch
	sed -i "s:/lib:/$(get_libdir):" Makefile.in
}

src_configure() {
	# handwritten script, needs extra stabbing
	export FLINT_LIB=lib"${PN}$(get_libname ${PV})"
	export FLINT_LIB2=lib"${PN}$(get_libname)"
	if ! (use static) ; then
		sed -i "s:STATIC=1:STATIC=0:" configure
	fi

	if [[ ${CHOST} == *-darwin* ]] ; then
		export SHARE_FLAGS="-install_name ${EPREFIX}/usr/$(get_libdir)/${FLINT_LIB}"
	else
		# linux type target assumed
		export SHARE_FLAGS="-Wl,-soname,${FLINT_LIB}"
	fi

	./configure \
		--with-mpir="${EPREFIX}"/usr \
		--with-mpfr="${EPREFIX}"/usr \
		--with-ntl="${EPREFIX}"/usr \
		--prefix="${ED}/usr" || die
}

src_install(){
	default
	dosym /usr/"$(get_libdir)/${FLINT_LIB}" /usr/"$(get_libdir)/lib${PN}$(get_libname)"
}

src_test(){
	# default doesn't run anything. Seem to be parallel safe
	emake check
}
