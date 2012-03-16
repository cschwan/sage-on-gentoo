# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/tachyon/tachyon-0.98.9-r2.ebuild,v 1.1 2012/03/12 13:05:10 alexxy Exp $

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="A portable, high performance parallel ray tracing system"
HOMEPAGE="http://jedi.ks.uiuc.edu/~johns/raytracer/"
SRC_URI="http://jedi.ks.uiuc.edu/~johns/raytracer/files/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-macos ~x64-macos"
IUSE="doc examples jpeg mpi opengl png threads"

CDEPEND="jpeg? ( virtual/jpeg )
	mpi? ( virtual/mpi )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng )"
DEPEND="${CDEPEND}
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}"

REQUIRED_USE="^^ ( opengl mpi )"

S="${WORKDIR}/${PN}/unix"

# TODO: Test on alpha, ia64, ppc
# TODO: add other architectures
# TODO: X, Motif, MBOX, Open Media Framework, Spaceball I/O, MGF ?

TACHYON_MAKE_TARGET=

pkg_setup() {
	local ostarget=linux
	local ostarget2=linux
	if  [[ ${CHOST} == *-darwin* ]] ; then
		ostarget=macosx
		ostarget2=macosx-x86
		if use mpi; then
			die " mpi is not supported on macos"
		fi
	fi

	if use threads ; then
		if use opengl ; then
			TACHYON_MAKE_TARGET=${ostarget2}-thr-ogl
		elif use mpi ; then
			TACHYON_MAKE_TARGET=${ostarget2}-mpi-thr
		else
			TACHYON_MAKE_TARGET=${ostarget2}-thr
		fi

		# TODO: Support for linux-athlon-thr ?
	else
		if use mpi ; then
			TACHYON_MAKE_TARGET=${ostarget}-mpi
		else
			TACHYON_MAKE_TARGET=${ostarget}
		fi
	fi

	if [[ -z "${TACHYON_MAKE_TARGET}" ]]; then
		die "No target found, check use flags"
	else
		einfo "Using target: ${TACHYON_MAKE_TARGET}"
	fi
}

src_prepare() {
	if use jpeg ; then
		sed -i \
			-e "s:USEJPEG=:USEJPEG=-DUSEJPEG:g" \
			-e "s:JPEGLIB=:JPEGLIB=-ljpeg:g" Make-config \
			|| die "sed failed"
	fi

	if use png ; then
		sed -i \
			-e "s:USEPNG=:USEPNG=-DUSEPNG:g" \
			-e "s:PNGINC=:PNGINC=$(pkg-config libpng --cflags):g" \
			-e "s:PNGLIB=:PNGLIB=$(pkg-config libpng --libs):g" Make-config \
			|| die "sed failed"
	fi

	if use mpi ; then
		sed -i "s:MPIDIR=:MPIDIR=/usr:g" Make-config || die "sed failed"
		sed -i "s:linux-lam:linux-mpi:g" Make-config || die "sed failed"
	fi
	sed -i \
		-e "s:-O3::g;s:-g::g;s:-pg::g" \
		-e "s:-m32:${CFLAGS}:g" \
		-e "s:-m64:${CFLAGS}:g" \
		-e "s:-ffast-math::g" \
		-e "s:STRIP = strip:STRIP = touch:g" \
		-e "s:CC = *cc:CC = $(tc-getCC):g" \
		-e "s:-fomit-frame-pointer::g" Make-arch || die "sed failed"

	epatch "${FILESDIR}"/${PV}-ldflags.patch
}

src_compile() {
	emake ${TACHYON_MAKE_TARGET} || die "emake failed"
}

src_install() {
	cd ..
	dodoc Changes README || die "dodoc failed"

	if use doc ; then
		dohtml docs/tachyon/* || die "dohtml failed"
	fi

	cd compile/${TACHYON_MAKE_TARGET}

	dobin tachyon || die "dobin failed"

	if use examples; then
		cd "${S}/../scenes"
		insinto "/usr/share/${PN}/examples"
		doins * || die "doins failed"
	fi
}
