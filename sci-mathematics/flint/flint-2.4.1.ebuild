# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils multilib flag-o-matic toolchain-funcs

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
	dev-libs/gmp
	"
RDEPEND="${DEPEND}"

pkg_setup(){
	if [[ ${CHOST} == *-darwin* ]] ; then
		append-flags -fno-common
	fi
}

src_prepare() {
	# make sure libraries have soname
	epatch "${FILESDIR}"/${PN}-2.4-makefile.patch
	# multilib fixes
	sed -e "s:\${GMP_DIR}/lib\":\${GMP_DIR}/$(get_libdir)\":" \
		-e "s:\${MPFR_DIR}/lib\":\${MPFR_DIR}/$(get_libdir)\":" \
		-e "s:\${NTL_DIR}/lib\":\${NTL_DIR}/$(get_libdir)\":" \
		-i configure
	sed -i "s:$(DESTDIR)$(PREFIX)/lib:$(DESTDIR)$(PREFIX)/$(get_libdir):g" \
		Makefile.in
}

src_configure() {
	# handwritten script, needs extra stabbing
	export FLINT_LIB=lib"${PN}$(get_libname ${PV})"
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
		--with-gmp="${EPREFIX}"/usr \
		--with-mpfr="${EPREFIX}"/usr \
		--with-ntl="${EPREFIX}"/usr \
		--prefix=/usr \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		AR=$(tc-getAR) || die
}

src_compile(){
	emake verbose
	ln -s lib"${PN}$(get_libname ${PV})" lib"${PN}$(get_libname)"
}

src_install(){
	default
	dosym ${FLINT_LIB} /usr/$(get_libdir)/lib${PN}$(get_libname)
}

src_test(){
	# default doesn't run anything. Seem to be parallel safe
	emake check AT="" QUIET_CC="" QUIET_CXX="" QUIET_AR=""
}
