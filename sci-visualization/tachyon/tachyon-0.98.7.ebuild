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
KEYWORDS="~x86"
IUSE="opengl"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

# TODO: add other architectures
# TODO: this ebuild needs more work

PORTAGE_MAKE_TARGET=linux-thr

src_compile() {
	cd "unix"

	if use opengl ; then
		PORTAGE_MAKE_TARGET=linux-thr-ogl
	fi

	emake ${PORTAGE_MAKE_TARGET} || die "emake failed"
}

src_install() {
	dodoc Changes README

	cd "compile/${PORTAGE_MAKE_TARGET}"

	exeinto /usr/bin
	doexe tachyon
}
