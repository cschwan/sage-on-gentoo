# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#EAPI=0

inherit eutils

DESCRIPTION="A portable, high performance parallel ray tracing system"
HOMEPAGE="http://jedi.ks.uiuc.edu/~johns/raytracer/"
SRC_URI="http://jedi.ks.uiuc.edu/~johns/raytracer/files/${PV}/${P}.tar.gz"

# TODO: has its own license

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nptl opengl"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

# TODO: add other architectures
# TODO: this ebuild needs more work

TACHYON_MAKE_TARGET=linux

pkg_setup() {
	if ! use nptl ; then
		if use opengl ; then
			eerror "you can not use opengl without USE=nptl"

			# TODO: does errror imply die ?
		fi

		if use ia64 ; then
			TACHYON_MAKE_TARGET=linux-ia64
	    elif use amd64 ; then
			TACHYON_MAKE_TARGET=linux-64
		else
			TACHYON_MAKE_TARGET=linux
		fi
	fi

	if use amd64 || use ia64 ; then
		if use opengl ; then
			TACHYON_MAKE_TARGET=linux-lam-64-ogl
		else
			TACHYON_MAKE_TARGET=linux-64-thr
		fi
	elif use opengl ; then
		TACHYON_MAKE_TARGET=linux-thr-ogl
	else
		TACHYON_MAKE_TARGET=linux-thr
	fi

	# TODO: support other architectures and check for MPI targets
}

src_compile() {
	cd "unix"

	emake ${TACHYON_MAKE_TARGET} || die "emake failed"
}

src_install() {
	dodoc Changes README

	cd "compile/${TACHYON_MAKE_TARGET}"

	exeinto /usr/bin
	doexe tachyon
}
