# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic multilib toolchain-funcs

DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="http://ecm.gforge.inria.fr/"
SRC_URI="http://www.loria.fr/~zimmerma/ecm-7.0-rc2.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos ~ppc-macos ~x64-macos"
IUSE="+custom-tune gwnum -openmp static-libs cpu_flags_x86_sse2"

DEPEND="
	dev-libs/gmp:=
	!sci-mathematics/ecm
	gwnum? ( sci-mathematics/gwnum )"
RDEPEND="${DEPEND}"

# can't be both enabled
REQUIRED_USE="gwnum? ( !openmp )
	x86-macos? ( !custom-tune )"

S="${WORKDIR}"/ecm-7.0-rc2

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_configure() {
	if [[ ${CHOST} == *-linux* ]] ; then
		append-ldflags "-Wl,-z,noexecstack"
	fi
	use gwnum && local myconf="--with-gwnum="${EPREFIX}"/usr/$(get_libdir)"
	# --enable-shellcmd is broken
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable openmp) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable custom-tune asm-redc) \
		${myconf}
}

src_install() {
	default
	mkdir -p "${ED}/usr/include/${PN}/"
	cp "${S}"/*.h "${ED}/usr/include/${PN}" || die "Failed to copy headers" # needed by other apps like YAFU
}
